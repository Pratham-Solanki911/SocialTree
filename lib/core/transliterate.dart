/// Simple Gujarati <-> Latin transliteration for name suggestions. It is a
/// starting point the user edits, not a linguistic engine.
library;

const _vowels = {
  'અ': 'a', 'આ': 'aa', 'ઇ': 'i', 'ઈ': 'i', 'ઉ': 'u', 'ઊ': 'oo', 'ઋ': 'ru', 'એ': 'e', 'ઐ': 'ai', 'ઓ': 'o', 'ઔ': 'au',
};
const _matras = {
  'ા': 'a', 'િ': 'i', 'ી': 'i', 'ુ': 'u', 'ૂ': 'u', 'ૃ': 'ru', 'ે': 'e', 'ૈ': 'ai', 'ો': 'o', 'ૌ': 'au',
};
const _consonants = {
  'ક': 'k', 'ખ': 'kh', 'ગ': 'g', 'ઘ': 'gh', 'ઙ': 'ng', 'ચ': 'ch', 'છ': 'chh', 'જ': 'j', 'ઝ': 'jh', 'ઞ': 'ny',
  'ટ': 't', 'ઠ': 'th', 'ડ': 'd', 'ઢ': 'dh', 'ણ': 'n', 'ત': 't', 'થ': 'th', 'દ': 'd', 'ધ': 'dh', 'ન': 'n',
  'પ': 'p', 'ફ': 'ph', 'બ': 'b', 'ભ': 'bh', 'મ': 'm', 'ય': 'y', 'ર': 'r', 'લ': 'l', 'વ': 'v', 'શ': 'sh',
  'ષ': 'sh', 'સ': 's', 'હ': 'h', 'ળ': 'l',
};

/// Gujarati -> Latin, e.g. દીનેશ -> Dinesh, સોલંકી -> Solanki.
String gujaratiToLatin(String s) {
  final out = StringBuffer();
  final chars = s.runes.map((r) => String.fromCharCode(r)).toList();
  for (var i = 0; i < chars.length; i++) {
    final c = chars[i];
    if (_vowels.containsKey(c)) {
      out.write(_vowels[c]);
    } else if (_consonants.containsKey(c)) {
      out.write(_consonants[c]);
      final next = i + 1 < chars.length ? chars[i + 1] : null;
      final isLast = next == null || next == ' ';
      // Inherent 'a' unless followed by a matra, virama, or at word end.
      if (next != null && (_matras.containsKey(next) || next == '્')) {
        // handled by the next character
      } else if (!isLast) {
        out.write('a');
      }
    } else if (_matras.containsKey(c)) {
      out.write(_matras[c]);
    } else if (c == '્') {
      // virama: no vowel
    } else if (c == 'ં' || c == 'ઁ') {
      out.write('n');
    } else if (c == 'ઃ') {
      out.write('h');
    } else {
      out.write(c);
    }
  }
  // Capitalise each word.
  return out.toString().split(' ').map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
}

const _latinCons = <String, String>{
  'chh': 'છ', 'kh': 'ખ', 'gh': 'ઘ', 'ch': 'ચ', 'jh': 'ઝ', 'th': 'થ', 'dh': 'ધ', 'ph': 'ફ', 'bh': 'ભ', 'sh': 'શ',
  'k': 'ક', 'g': 'ગ', 'j': 'જ', 't': 'ત', 'd': 'દ', 'n': 'ન', 'p': 'પ', 'f': 'ફ', 'b': 'બ', 'm': 'મ',
  'y': 'ય', 'r': 'ર', 'l': 'લ', 'v': 'વ', 'w': 'વ', 's': 'સ', 'h': 'હ', 'c': 'ક', 'q': 'ક', 'x': 'ક્ષ', 'z': 'ઝ',
};
const _latinVowelsInitial = <String, String>{'aa': 'આ', 'ee': 'ઈ', 'oo': 'ઊ', 'ai': 'ઐ', 'au': 'ઔ', 'a': 'અ', 'i': 'ઇ', 'u': 'ઉ', 'e': 'એ', 'o': 'ઓ'};
const _latinMatras = <String, String>{'aa': 'ા', 'ee': 'ી', 'oo': 'ૂ', 'ai': 'ૈ', 'au': 'ૌ', 'a': '', 'i': 'િ', 'u': 'ુ', 'e': 'ે', 'o': 'ો'};

/// Latin -> Gujarati, best effort: Dinesh -> દિનેશ, Solanki -> સોલંકિ.
String latinToGujarati(String s) {
  final out = StringBuffer();
  for (final word in s.toLowerCase().split(' ')) {
    var i = 0;
    var afterConsonant = false;
    while (i < word.length) {
      var matched = false;
      for (final len in [3, 2, 1]) {
        if (i + len > word.length) continue;
        final chunk = word.substring(i, i + len);
        if (_latinCons.containsKey(chunk)) {
          if (afterConsonant) out.write('્');
          out.write(_latinCons[chunk]);
          afterConsonant = true;
          i += len;
          matched = true;
          break;
        }
        final vowelTable = afterConsonant ? _latinMatras : _latinVowelsInitial;
        if (vowelTable.containsKey(chunk)) {
          out.write(vowelTable[chunk]);
          afterConsonant = false;
          i += len;
          matched = true;
          break;
        }
      }
      if (!matched) {
        out.write(word[i]);
        afterConsonant = false;
        i++;
      }
    }
    out.write(' ');
  }
  return out.toString().trim();
}
