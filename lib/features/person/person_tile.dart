import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n_ext.dart';
import '../../core/widgets.dart';
import '../../models/models.dart';

String lifespan(BuildContext context, Person p) {
  final l = context.l;
  final parts = <String>[];
  if (p.dob != null) parts.add(l.born('${p.dobIsApprox ? '~' : ''}${p.dob!.year}'));
  if (!p.isAlive) parts.add(p.dod != null ? l.died('${p.dod!.year}') : l.deceased);
  return parts.join(' · ');
}

class PersonTile extends StatelessWidget {
  const PersonTile({super.key, required this.person, this.subtitle, this.trailing, this.onTap});
  final Person person;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sub = subtitle ?? [lifespan(context, person), if (person.currentPlace != null) person.currentPlace!].where((s) => s.isNotEmpty).join(' · ');
    return ListTile(
      leading: PersonAvatar(path: person.passportPhotoPath, initials: person.initials, size: 36),
      title: Text(person.fullName),
      subtitle: sub.isEmpty ? null : Text(sub),
      trailing: trailing,
      onTap: onTap ?? () => context.push('/persons/${person.id}'),
    );
  }
}
