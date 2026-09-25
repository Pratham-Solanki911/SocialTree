import 'package:flutter_test/flutter_test.dart';
import 'package:socialtree/core/names.dart';
import 'package:socialtree/core/transliterate.dart';

void main() {
  test('display order follows the reader, Hindi converts Gujarati script', () {
    expect(displayNameFor('gu', gu: 'દીનેશ સોલંકી', en: 'Dinesh Solanki').primary, 'દીનેશ સોલંકી');
    expect(displayNameFor('gu', gu: 'દીનેશ સોલંકી', en: 'Dinesh Solanki').secondary, 'Dinesh Solanki');
    expect(displayNameFor('en', gu: 'દીનેશ સોલંકી', en: 'Dinesh Solanki').primary, 'Dinesh Solanki');
    expect(displayNameFor('hi', gu: 'દીનેશ', en: 'Dinesh').primary, 'दीनेश');
    expect(displayNameFor('en', gu: 'દીનેશ', en: null).primary, 'દીનેશ');
    expect(displayNameFor('gu', gu: null, en: 'Dinesh').secondary, isNull);
  });

  test('transliteration gives an editable suggestion', () {
    expect(gujaratiToLatin('દીનેશ'), 'Dinesh');
    expect(gujaratiToLatin('સોલંકી'), 'Solanki');
    expect(gujaratiToLatin('મીઠાભાઈ'), 'Mithabhai');
    expect(latinToGujarati('Dinesh'), 'દિનેશ');
    expect(latinToGujarati('Solanki').startsWith('સોલ'), isTrue);
  });
}
