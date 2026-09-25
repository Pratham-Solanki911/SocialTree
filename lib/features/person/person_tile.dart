import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/names.dart';
import '../../core/widgets.dart';
import '../../models/models.dart';

String lifespan(BuildContext context, Person p) {
  final l = context.l;
  final parts = <String>[];
  if (p.dob != null) parts.add(l.born('${p.dobIsApprox ? '~' : ''}${p.dob!.year}'));
  if (!p.isAlive) parts.add(p.dod != null ? l.died('${p.dod!.year}') : l.deceased);
  return parts.join(' · ');
}

/// "son of X" when the search result carried the father.
String? fatherLine(BuildContext context, Person p) =>
    parentLine(context, p, p.fatherName, p.fatherNameEn, context.l.sonOf, context.l.daughterOf);

class PersonTile extends StatelessWidget {
  const PersonTile({super.key, required this.person, this.subtitle, this.trailing, this.onTap, this.showFamily = false});
  final Person person;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showFamily;

  @override
  Widget build(BuildContext context) {
    final sub = subtitle ??
        [
          ?fatherLine(context, person),
          lifespan(context, person),
          if (showFamily && person.familyName != null) displayName(context, gu: person.familyName, en: person.familyNameEn).primary,
          if (person.currentPlace != null) person.currentPlace!,
        ].where((s) => s.isNotEmpty).join(' · ');
    return ListTile(
      leading: PersonAvatar(path: person.passportPhotoPath, initials: person.initials, size: 36),
      title: NameText(personName(context, person)),
      subtitle: sub.isEmpty ? null : Text(sub),
      isThreeLine: person.fullNameEn != null && sub.isNotEmpty,
      trailing: trailing ??
          (person.claimedBy != null
              ? Tooltip(message: context.l.linkedToMember, child: const Icon(Icons.verified_user_outlined, size: 18))
              : (!person.isAlive ? const Icon(Icons.local_florist_outlined, size: 18) : null)),
      onTap: onTap ?? () => context.push('/persons/${person.id}'),
    );
  }
}
