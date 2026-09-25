import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';
import 'person_picker.dart';

/// Adds a parent / child / spouse to `person`, either by creating a new
/// record or linking an existing one. Returns true when a relationship was
/// written.
Future<bool> showAddRelativeSheet(BuildContext context, WidgetRef ref, Person person, {String? kind}) async {
  final l = context.l;
  final relation = kind ??
      await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(leading: const Icon(Icons.arrow_upward), title: Text(l.addParent), onTap: () => Navigator.pop(ctx, 'parent')),
              ListTile(leading: const Icon(Icons.favorite_outline), title: Text(l.addSpouse), onTap: () => Navigator.pop(ctx, 'spouse')),
              ListTile(leading: const Icon(Icons.arrow_downward), title: Text(l.addChild), onTap: () => Navigator.pop(ctx, 'child')),
            ],
          ),
        ),
      );
  if (relation == null || !context.mounted) return false;

  final how = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: const Icon(Icons.person_add_alt_1_outlined), title: Text(l.createNew), onTap: () => Navigator.pop(ctx, 'new')),
          ListTile(leading: const Icon(Icons.link), title: Text(l.linkExisting), onTap: () => Navigator.pop(ctx, 'existing')),
        ],
      ),
    ),
  );
  if (how == null || !context.mounted) return false;

  String? otherId;
  if (how == 'new') {
    // Spouses usually come from another family; ask which. Parents/children share the family.
    var familyId = person.familyId;
    if (relation == 'spouse') {
      final families = ref.read(familiesProvider).value ?? const <Family>[];
      final chosen = await showDialog<String>(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l.chooseFamilyForSpouse),
          children: [for (final f in families) SimpleDialogOption(onPressed: () => Navigator.pop(ctx, f.id), child: Text(f.name))],
        ),
      );
      if (chosen == null || !context.mounted) return false;
      familyId = chosen;
    }
    otherId = await context.push<String>('/persons/new?familyId=$familyId');
  } else {
    otherId = (await pickPerson(context, exclude: {person.id}))?.id;
  }
  if (otherId == null || !context.mounted) return false;

  DateTime? marriedOn;
  if (relation == 'spouse') {
    marriedOn = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1800), lastDate: DateTime.now(), helpText: l.marriedOn);
  }
  if (!context.mounted) return false;

  try {
    final repos = ref.read(reposProvider);
    switch (relation) {
      case 'parent':
        await repos.addRelationship(kind: 'parent', personId: otherId, relatedId: person.id);
      case 'child':
        await repos.addRelationship(kind: 'parent', personId: person.id, relatedId: otherId);
      default:
        await repos.addRelationship(kind: 'spouse', personId: person.id, relatedId: otherId, marriedOn: marriedOn);
    }
    if (context.mounted) showMessage(context, l.relationshipAdded);
    return true;
  } catch (e) {
    if (context.mounted) showError(context, e);
    return false;
  }
}
