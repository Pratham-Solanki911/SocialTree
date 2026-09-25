import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import '../person/person_tile.dart';

/// "Are you already in the tree?" One question per screen, big buttons.
class FindMeScreen extends ConsumerStatefulWidget {
  const FindMeScreen({super.key});

  @override
  ConsumerState<FindMeScreen> createState() => _FindMeScreenState();
}

class _FindMeScreenState extends ConsumerState<FindMeScreen> {
  late final TextEditingController _first;
  late final TextEditingController _last;
  final _village = TextEditingController();
  final _year = TextEditingController();
  final _phone = TextEditingController();
  List<SelfCandidate>? _results;
  final _rejected = <String>{};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final name = (ref.read(myProfileProvider).value?.fullName ?? '').trim().split(RegExp(r'\s+'));
    _first = TextEditingController(text: name.isNotEmpty ? name.first : '');
    _last = TextEditingController(text: name.length > 1 ? name.last : '');
    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  Future<void> _search() async {
    if (_first.text.trim().isEmpty && _last.text.trim().isEmpty) return;
    setState(() => _busy = true);
    try {
      final r = await ref.read(reposProvider).findMyself(
            firstName: _first.text.trim(),
            lastName: _last.text.trim(),
            village: _village.text.trim().isEmpty ? null : _village.text.trim(),
            birthYear: int.tryParse(_year.text.trim()),
            phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          );
      if (mounted) setState(() => _results = r);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _later() async {
    try {
      await ref.read(reposProvider).updateMyProfile({'onboarding_done': true});
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  Future<void> _yes(Person p) async {
    final l = context.l;
    try {
      final status = await ref.read(reposProvider).requestClaim(p.id);
      ref.invalidate(myPersonProvider);
      ref.invalidate(claimRequestsProvider);
      if (!mounted) return;
      showMessage(context, status == 'approved' ? l.linkedNow : l.requestSent);
      if (status != 'approved') await ref.read(reposProvider).updateMyProfile({'onboarding_done': true});
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final shown = (_results ?? const <SelfCandidate>[]).where((c) => !_rejected.contains(c.person.id)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.findMeTitle), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.findMeIntro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          TextField(controller: _first, decoration: InputDecoration(labelText: l.yourFirstName)),
          TextField(controller: _last, decoration: InputDecoration(labelText: l.yourLastName)),
          TextField(controller: _village, decoration: InputDecoration(labelText: l.yourVillage)),
          TextField(controller: _year, decoration: InputDecoration(labelText: l.yourBirthYear), keyboardType: TextInputType.number),
          TextField(controller: _phone, decoration: InputDecoration(labelText: l.yourMobile), keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _busy ? null : _search, icon: const Icon(Icons.search), label: Text(l.searchForMe)),
          const SizedBox(height: 16),
          if (_busy) const LinearProgressIndicator(),
          if (_results != null && shown.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(l.noCandidates, style: Theme.of(context).textTheme.bodyLarge)),
          for (final c in shown)
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PersonTile(
                    person: c.person,
                    subtitle: [
                      lifespan(context, c.person),
                      if (c.person.nativeVillage != null) c.person.nativeVillage!,
                      if (c.parents != null) l.parentsLabel(c.parents!),
                    ].where((s) => s.isNotEmpty).join('\n'),
                    trailing: const SizedBox.shrink(),
                    onTap: () => context.push('/persons/${c.person.id}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l.areYouThisPerson, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        FilledButton.icon(onPressed: () => _yes(c.person), icon: const Icon(Icons.check), label: Text(l.yesThisIsMe)),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(onPressed: () => setState(() => _rejected.add(c.person.id)), icon: const Icon(Icons.close), label: Text(l.noNotMe)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.push('/persons/new?me=1'),
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: Text(l.notInListAddMe),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _later, child: Text(l.doThisLater)),
        ],
      ),
    );
  }
}
