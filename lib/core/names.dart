import 'package:flutter/widgets.dart';

import '../models/models.dart';

/// Gujarati and Devanagari share one layout, 0x180 apart.
String gujaratiToDevanagari(String s) =>
    String.fromCharCodes(s.runes.map((r) => r >= 0x0A80 && r <= 0x0AFF ? r - 0x180 : r));

bool _hasGujarati(String s) => s.runes.any((r) => r >= 0x0A80 && r <= 0x0AFF);

/// One rule for showing a name in two scripts: the reader's script first,
/// the other below. `primary` is never empty when either script exists.
class DisplayName {
  const DisplayName(this.primary, this.secondary);
  final String primary;
  final String? secondary;
  String get oneLine => secondary == null ? primary : '$primary ($secondary)';
}

DisplayName displayName(BuildContext context, {required String? gu, required String? en}) {
  final lang = Localizations.localeOf(context).languageCode;
  return displayNameFor(lang, gu: gu, en: en);
}

DisplayName displayNameFor(String lang, {required String? gu, required String? en}) {
  final g = (gu ?? '').trim();
  final e = (en ?? '').trim();
  if (g.isEmpty && e.isEmpty) return const DisplayName('?', null);
  if (g.isEmpty) return DisplayName(e, null);
  final local = lang == 'hi' && _hasGujarati(g) ? gujaratiToDevanagari(g) : g;
  if (e.isEmpty) return DisplayName(local, null);
  return lang == 'en' ? DisplayName(e, local) : DisplayName(local, e);
}

DisplayName personName(BuildContext context, Person p) => displayName(context, gu: p.fullName, en: p.fullNameEn);
DisplayName personShortName(BuildContext context, Person p) => displayName(context, gu: p.shortName, en: p.shortNameEn);
DisplayName familyName(BuildContext context, Family f) => displayName(context, gu: f.name, en: f.nameEn);

/// "son of X" / "daughter of X" line for telling same-named people apart.
String? parentLine(BuildContext context, Person p, String? fatherGu, String? fatherEn, String Function(String) sonOf, String Function(String) daughterOf) {
  if ((fatherGu ?? fatherEn) == null) return null;
  final f = displayName(context, gu: fatherGu, en: fatherEn).primary;
  return p.gender == 'female' ? daughterOf(f) : sonOf(f);
}

/// Two-line name widget.
class NameText extends StatelessWidget {
  const NameText(this.name, {super.key, this.style, this.secondaryStyle, this.maxLines = 2, this.textAlign});
  final DisplayName name;
  final TextStyle? style;
  final TextStyle? secondaryStyle;
  final int maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name.primary, style: base, maxLines: maxLines, overflow: TextOverflow.ellipsis, textAlign: textAlign),
        if (name.secondary != null)
          Text(name.secondary!,
              style: secondaryStyle ?? base.copyWith(fontSize: (base.fontSize ?? 14) * 0.8, color: base.color?.withValues(alpha: 0.7)),
              maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: textAlign),
      ],
    );
  }
}
