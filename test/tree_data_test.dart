import 'package:flutter_test/flutter_test.dart';
import 'package:socialtree/core/phone.dart';
import 'package:socialtree/models/models.dart';

Person p(String id, {String gender = 'male', String? family}) => Person(
      id: id,
      familyId: family ?? 'f1',
      firstName: id,
      lastName: 'Solanki',
      gender: gender,
    );

Relationship rel(String kind, String a, String b) => Relationship(id: '$kind-$a-$b', kind: kind, personId: a, relatedId: b);

void main() {
  // Govind -> Bharat + Manju -> Ramesh, Sunita ; Ramesh + Nita -> Aarav
  final tree = TreeData(
    [p('govind'), p('bharat'), p('manju', gender: 'female'), p('ramesh'), p('sunita', gender: 'female'), p('nita', gender: 'female', family: 'f2'), p('aarav')],
    [
      rel('parent', 'govind', 'bharat'),
      rel('parent', 'bharat', 'ramesh'),
      rel('parent', 'manju', 'ramesh'),
      rel('parent', 'bharat', 'sunita'),
      rel('parent', 'manju', 'sunita'),
      rel('spouse', 'nita', 'ramesh'),
      rel('parent', 'ramesh', 'aarav'),
      rel('parent', 'nita', 'aarav'),
    ],
  );

  test('relatives are resolved from both edge directions', () {
    expect(tree.parentsOf('ramesh').map((x) => x.id), unorderedEquals(['bharat', 'manju']));
    expect(tree.fatherOf('ramesh')?.id, 'bharat');
    expect(tree.motherOf('ramesh')?.id, 'manju');
    expect(tree.spousesOf('ramesh').single.id, 'nita');
    expect(tree.spousesOf('nita').single.id, 'ramesh');
    expect(tree.siblingsOf('ramesh').single.id, 'sunita');
    expect(tree.childrenOf('govind').single.id, 'bharat');
  });

  test('descendants are depth-first with depth', () {
    final rows = tree.descendantsOf('govind').map((r) => '${r.$1.id}:${r.$2}').toList();
    expect(rows.first, 'bharat:1');
    expect(rows, containsAll(['ramesh:2', 'sunita:2', 'aarav:3']));
    expect(rows.length, 4);
  });

  test('generations: spouses share a level, parents above, children below', () {
    final g = tree.generationsFrom('ramesh');
    expect(g['ramesh'], 0);
    expect(g['nita'], 0);
    expect(g['bharat'], -1);
    expect(g['govind'], -2);
    expect(g['aarav'], 1);
    expect(g['sunita'], 0);
  });

  test('phones: E.164 join/split and WhatsApp link', () {
    expect(toE164('+91', '098765 43210'), '+919876543210');
    expect(toE164('44', '07700 900123'), '+447700900123');
    expect(toE164('+91', '123'), isNull);
    expect(splitE164('+447700900123'), ('+44', '7700900123'));
    expect(whatsappUri('+919876543210').toString(), 'https://wa.me/919876543210');
  });

  test('Person.fromMap reads phones and coordinates', () {
    final person = Person.fromMap({
      'id': 'x',
      'family_id': 'f',
      'first_name': 'Ramesh',
      'last_name': 'Solanki',
      'gender': 'male',
      'dob': '1990-03-03',
      'birth_lat': 22,
      'birth_lng': 70.5,
      'phones': [
        {'number': '+919876543210', 'label': 'mobile', 'whatsapp': true}
      ],
    });
    expect(person.dob, DateTime(1990, 3, 3));
    expect(person.birthLat, 22.0);
    expect(person.phones.single.whatsapp, isTrue);
    expect(person.fullName, 'Ramesh Solanki');
    expect(person.initials, 'RS');
  });
}

