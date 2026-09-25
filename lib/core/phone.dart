/// Country calling codes where Samaj members commonly live. Any other code can
/// be typed by hand; the field only requires E.164 digits.
const countryCodes = <(String, String)>[
  ('+91', 'India'),
  ('+44', 'United Kingdom'),
  ('+1', 'USA / Canada'),
  ('+971', 'UAE'),
  ('+968', 'Oman'),
  ('+974', 'Qatar'),
  ('+966', 'Saudi Arabia'),
  ('+965', 'Kuwait'),
  ('+973', 'Bahrain'),
  ('+254', 'Kenya'),
  ('+255', 'Tanzania'),
  ('+256', 'Uganda'),
  ('+27', 'South Africa'),
  ('+61', 'Australia'),
  ('+64', 'New Zealand'),
  ('+65', 'Singapore'),
  ('+60', 'Malaysia'),
  ('+49', 'Germany'),
  ('+351', 'Portugal'),
  ('+33', 'France'),
];

final _e164 = RegExp(r'^\+[1-9][0-9]{6,14}$');

bool isE164(String s) => _e164.hasMatch(s);

/// Joins a country code and a local number into E.164, or null if invalid.
String? toE164(String code, String local) {
  final digits = local.replaceAll(RegExp(r'[^0-9]'), '').replaceFirst(RegExp(r'^0+'), '');
  final c = code.startsWith('+') ? code : '+$code';
  final full = '$c$digits';
  return isE164(full) ? full : null;
}

/// wa.me wants the number without the plus sign.
Uri whatsappUri(String e164) => Uri.parse('https://wa.me/${e164.replaceAll('+', '')}');

Uri telUri(String e164) => Uri.parse('tel:$e164');

/// Splits an E.164 number into (code, local) using the known code list,
/// defaulting to a 2-digit code.
(String, String) splitE164(String e164) {
  for (final (code, _) in countryCodes) {
    if (e164.startsWith(code)) return (code, e164.substring(code.length));
  }
  return (e164.substring(0, 3), e164.substring(3));
}
