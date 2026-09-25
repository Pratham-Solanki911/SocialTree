// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'SocialTree';

  @override
  String get samajName => 'શ્રી મચ્છુકાઠિયા સઈ સુથાર સમાજ';

  @override
  String get signInTagline => 'આપણા સમાજના વંશવૃક્ષ, નોંધો અને મૂળ';

  @override
  String get signInWithGoogle => 'Google થી ચાલુ રાખો';

  @override
  String signInFailed(String message) {
    return 'સાઇન-ઇન નિષ્ફળ: $message';
  }

  @override
  String get pendingTitle => 'મંજૂરીની રાહ';

  @override
  String get pendingBody =>
      'સમાજના એડમિન તમારી સભ્યપદ મંજૂર કરશે. આ સ્ક્રીન આપમેળે અપડેટ થશે.';

  @override
  String get rejectedBody =>
      'તમારી સભ્યપદ વિનંતી મંજૂર થઈ નથી. સમાજના એડમિનનો સંપર્ક કરો.';

  @override
  String get blockedBody =>
      'તમારું ખાતું બ્લોક કરાયું છે. સમાજના એડમિનનો સંપર્ક કરો.';

  @override
  String get signOut => 'સાઇન આઉટ';

  @override
  String get setupTitle => 'એપ ગોઠવાયેલી નથી';

  @override
  String get setupBody =>
      '--dart-define=SUPABASE_URL=... અને --dart-define=SUPABASE_ANON_KEY=... સાથે બિલ્ડ કરો. README.md જુઓ.';

  @override
  String get navHome => 'હોમ';

  @override
  String get navFamilies => 'પરિવારો';

  @override
  String get navSearch => 'શોધ';

  @override
  String get navMap => 'નકશો';

  @override
  String get navAccount => 'ખાતું';

  @override
  String get homeFeed => 'સમાજ સમાચાર';

  @override
  String get noUpdates => 'હજુ કોઈ જન્મ, લગ્ન કે અવસાન નોંધાયા નથી.';

  @override
  String get quickActions => 'ઝડપી ક્રિયાઓ';

  @override
  String get myProfile => 'મારી પ્રોફાઇલ';

  @override
  String get createMyProfile => 'મારી પ્રોફાઇલ બનાવો';

  @override
  String get claimProfile => 'આ હું છું';

  @override
  String get claimed => 'રેકોર્ડ તમારા ખાતા સાથે જોડાયો';

  @override
  String get addRelative => 'સંબંધી ઉમેરો';

  @override
  String get viewTree => 'વૃક્ષ જુઓ';

  @override
  String get matches => 'મેચ';

  @override
  String get gotraLookup => 'ગોત્ર અને કુળદેવી';

  @override
  String get albums => 'આલ્બમ';

  @override
  String get chat => 'ચેટ';

  @override
  String get support => 'સહાય';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get admin => 'એડમિન';

  @override
  String get familiesTitle => 'પરિવારો';

  @override
  String get newFamily => 'નવો પરિવાર';

  @override
  String get familyName => 'પરિવારનું નામ';

  @override
  String get surname => 'અટક';

  @override
  String get nativeVillage => 'મૂળ ગામ';

  @override
  String get description => 'વર્ણન';

  @override
  String get members => 'સભ્યો';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count સભ્યો',
      one: '1 સભ્ય',
      zero: 'કોઈ સભ્ય નથી',
    );
    return '$_temp0';
  }

  @override
  String get noFamilies => 'હજુ કોઈ પરિવાર નથી. પહેલો બનાવો.';

  @override
  String get createFamily => 'પરિવાર બનાવો';

  @override
  String get familyTree => 'વંશવૃક્ષ';

  @override
  String get familyAlbum => 'પરિવાર આલ્બમ';

  @override
  String get addPerson => 'વ્યક્તિ ઉમેરો';

  @override
  String get personDetails => 'વ્યક્તિની વિગતો';

  @override
  String get firstName => 'નામ';

  @override
  String get middleName => 'પિતા / પતિનું નામ';

  @override
  String get lastName => 'અટક';

  @override
  String get maidenName => 'પિયરની અટક';

  @override
  String get nickname => 'હુલામણું નામ';

  @override
  String get gender => 'લિંગ';

  @override
  String get male => 'પુરુષ';

  @override
  String get female => 'સ્ત્રી';

  @override
  String get other => 'અન્ય';

  @override
  String get dateOfBirth => 'જન્મ તારીખ';

  @override
  String get approximate => 'અંદાજિત';

  @override
  String get dateOfDeath => 'અવસાન તારીખ';

  @override
  String get deceased => 'સ્વર્ગસ્થ';

  @override
  String get alive => 'હયાત';

  @override
  String get birthPlace => 'જન્મ સ્થળ';

  @override
  String get currentPlace => 'હાલનું સ્થળ';

  @override
  String get pickOnMap => 'નકશા પર પસંદ કરો';

  @override
  String get locationSet => 'સ્થાન સેટ થયું';

  @override
  String get phones => 'ફોન નંબર';

  @override
  String get addPhone => 'ફોન ઉમેરો';

  @override
  String get phoneNumber => 'નંબર';

  @override
  String get countryCode => 'દેશ';

  @override
  String get phoneLabel => 'લેબલ';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get openWhatsApp => 'WhatsApp ખોલો';

  @override
  String get call => 'કૉલ';

  @override
  String get invalidPhone => 'ફક્ત અંકો, 6 થી 14';

  @override
  String get email => 'ઈમેલ';

  @override
  String get occupation => 'વ્યવસાય';

  @override
  String get education => 'શિક્ષણ';

  @override
  String get maritalStatus => 'વૈવાહિક સ્થિતિ';

  @override
  String get bloodGroup => 'બ્લડ ગ્રુપ';

  @override
  String get biography => 'જીવનચરિત્ર';

  @override
  String get notes => 'નોંધ';

  @override
  String get passportPhoto => 'પાસપોર્ટ ફોટો';

  @override
  String get takePhoto => 'ફોટો લો';

  @override
  String get chooseFromGallery => 'ગેલેરીમાંથી પસંદ કરો';

  @override
  String get removePhoto => 'ફોટો દૂર કરો';

  @override
  String photoCompressedTo(String size) {
    return '$size સુધી સંકોચાયો';
  }

  @override
  String get save => 'સાચવો';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get edit => 'સંપાદિત કરો';

  @override
  String get gotra => 'ગોત્ર';

  @override
  String get kuldevi => 'કુળદેવી';

  @override
  String get kuldevta => 'કુળદેવતા';

  @override
  String fromGotra(String value) {
    return 'ગોત્ર મુજબ: $value';
  }

  @override
  String fromFamily(String value) {
    return 'પરિવાર મુજબ: $value';
  }

  @override
  String get family => 'પરિવાર';

  @override
  String get requiredField => 'જરૂરી';

  @override
  String get saved => 'સાચવાયું';

  @override
  String errorWithMessage(String message) {
    return 'કંઈક ખોટું થયું: $message';
  }

  @override
  String get confirmDelete => 'આ કાઢી નાખવું? આ પાછું નહીં લઈ શકાય.';

  @override
  String get about => 'વિશે';

  @override
  String get timeline => 'સમયરેખા';

  @override
  String get media => 'મીડિયા';

  @override
  String get parents => 'માતા-પિતા';

  @override
  String get children => 'સંતાનો';

  @override
  String get spouses => 'જીવનસાથી';

  @override
  String get siblings => 'ભાઈ-બહેન';

  @override
  String get addParent => 'માતા/પિતા ઉમેરો';

  @override
  String get addChild => 'સંતાન ઉમેરો';

  @override
  String get addSpouse => 'જીવનસાથી ઉમેરો';

  @override
  String get linkExisting => 'હાલની વ્યક્તિ જોડો';

  @override
  String get createNew => 'નવી વ્યક્તિ બનાવો';

  @override
  String get selectPerson => 'વ્યક્તિ પસંદ કરો';

  @override
  String get marriedOn => 'લગ્ન તારીખ';

  @override
  String get relationshipAdded => 'સંબંધ ઉમેરાયો';

  @override
  String get removeRelationship => 'સંબંધ દૂર કરો';

  @override
  String get treeGraph => 'આલેખ';

  @override
  String get ancestors => 'પૂર્વજો';

  @override
  String get descendants => 'વંશજો';

  @override
  String get generations => 'પેઢીઓ';

  @override
  String get noRelatives => 'હજુ કોઈ સંબંધી જોડાયા નથી.';

  @override
  String get lifeEvents => 'જીવન પ્રસંગો';

  @override
  String get addEvent => 'પ્રસંગ ઉમેરો';

  @override
  String get eventKind => 'પ્રકાર';

  @override
  String get eventTitle => 'શીર્ષક';

  @override
  String get eventDate => 'તારીખ';

  @override
  String get place => 'સ્થળ';

  @override
  String get kindBirth => 'જન્મ';

  @override
  String get kindEducation => 'શિક્ષણ';

  @override
  String get kindMigration => 'સ્થળાંતર';

  @override
  String get kindMarriage => 'લગ્ન';

  @override
  String get kindCareer => 'કારકિર્દી';

  @override
  String get kindDeath => 'અવસાન';

  @override
  String get kindOther => 'અન્ય';

  @override
  String get noEvents => 'હજુ કોઈ પ્રસંગ નથી.';

  @override
  String get migrationMap => 'સ્થળાંતર નકશો';

  @override
  String get mapSource => 'નકશા સ્ત્રોત';

  @override
  String get mapBharatmaps => 'ભારતમેપ્સ (ભારત સરકાર)';

  @override
  String get mapBhuvan => 'ભુવન (ISRO)';

  @override
  String get mapOsm => 'OpenStreetMap';

  @override
  String get mapTilesFailed =>
      'આ સ્ત્રોતના નકશા લોડ થતા નથી. બીજો સ્ત્રોત અજમાવો.';

  @override
  String get allFamilies => 'બધા પરિવારો';

  @override
  String get tapToPick => 'સ્થાન સેટ કરવા નકશા પર ટૅપ કરો';

  @override
  String get clearLocation => 'સ્થાન દૂર કરો';

  @override
  String get noPaths =>
      'હજુ કોઈ સ્થળ નોંધાયું નથી. જન્મ સ્થળ, હાલનું સ્થળ કે સ્થળાંતર પ્રસંગો ઉમેરો.';

  @override
  String get searchHint => 'નામ, ગામ કે સ્થળથી શોધો';

  @override
  String get noResults => 'કોઈ પરિણામ નથી';

  @override
  String get onlyMyAncestors => 'ફક્ત મારા પૂર્વજો';

  @override
  String get findMatches => 'મેચ શોધો';

  @override
  String get noMatches => 'કોઈ સંભવિત ડુપ્લિકેટ મળ્યા નથી.';

  @override
  String get possibleDuplicate => 'સંભવિત ડુપ્લિકેટ';

  @override
  String matchScore(int score) {
    return '$score% મેચ';
  }

  @override
  String get mergeInto => 'મર્જ કરો (એડમિન)';

  @override
  String get keepWhich => 'કયો રેકોર્ડ રાખવો?';

  @override
  String get dismiss => 'અવગણો';

  @override
  String matchesRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count મેચ મળી',
      one: '1 મેચ મળી',
      zero: 'કોઈ નવી મેચ નથી',
    );
    return '$_temp0';
  }

  @override
  String get lookupBySurname => 'અટકથી શોધો';

  @override
  String get addMapping => 'અટક-ગોત્ર ઉમેરો';

  @override
  String get addGotra => 'ગોત્ર ઉમેરો';

  @override
  String get verified => 'ચકાસાયેલ';

  @override
  String get unverified => 'અચકાસાયેલ';

  @override
  String get village => 'ગામ';

  @override
  String get communityContributed =>
      'એન્ટ્રીઓ સભ્યો ઉમેરે છે. વડીલો સાથે ખાતરી કરો; એડમિન ચકાસાયેલ ચિહ્નિત કરે છે.';

  @override
  String get markVerified => 'ચકાસાયેલ ચિહ્નિત કરો';

  @override
  String get newAlbum => 'નવું આલ્બમ';

  @override
  String get albumTitle => 'આલ્બમનું નામ';

  @override
  String get uploadPhoto => 'ફોટો અપલોડ કરો';

  @override
  String get addVideoLink => 'વિડિયો લિંક ઉમેરો';

  @override
  String get uploadDocument => 'દસ્તાવેજ અપલોડ કરો (PDF)';

  @override
  String get videoUrl => 'વિડિયો URL (YouTube, Drive)';

  @override
  String get caption => 'કૅપ્શન';

  @override
  String get noMedia => 'હજુ કંઈ નથી.';

  @override
  String get premiumOnly => 'પ્રીમિયમ યોજનાની સુવિધા';

  @override
  String get freePlanAlbumLimit => 'મફત યોજનામાં એક આલ્બમ મળે છે.';

  @override
  String get fileTooLarge => 'ફાઇલ 5 MB થી મોટી છે.';

  @override
  String get markAllRead => 'બધું વાંચેલું કરો';

  @override
  String get noNotifications => 'કોઈ સૂચનાઓ નથી.';

  @override
  String get newChat => 'નવી ચેટ';

  @override
  String get messageHint => 'સંદેશ';

  @override
  String get send => 'મોકલો';

  @override
  String get noConversations => 'હજુ કોઈ વાતચીત નથી.';

  @override
  String get startChatPremium =>
      'ચેટ શરૂ કરવા પ્રીમિયમ યોજના જોઈએ. જવાબ આપવો બધા માટે મફત છે.';

  @override
  String get newTicket => 'નવી ટિકિટ';

  @override
  String get subject => 'વિષય';

  @override
  String get message => 'સંદેશ';

  @override
  String get priority => 'પ્રાથમિકતા';

  @override
  String get status => 'સ્થિતિ';

  @override
  String get statusOpen => 'ખુલ્લી';

  @override
  String get statusInProgress => 'ચાલુ';

  @override
  String get statusResolved => 'ઉકેલાઈ';

  @override
  String get priorityHigh => 'ઉચ્ચ';

  @override
  String get priorityNormal => 'સામાન્ય';

  @override
  String get reply => 'જવાબ';

  @override
  String get noTickets => 'કોઈ ટિકિટ નથી.';

  @override
  String get language => 'ભાષા';

  @override
  String get english => 'English';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get plan => 'યોજના';

  @override
  String get planFree => 'મફત';

  @override
  String get planPremium => 'પ્રીમિયમ';

  @override
  String get planInfo =>
      'યોજના સમાજના એડમિન નક્કી કરે છે. એપમાં કોઈ ચુકવણી નથી.';

  @override
  String get successor => 'વારસ સંપર્ક';

  @override
  String get successorInfo =>
      'તમારા અવસાન પછી આ સભ્ય તમારો રેકોર્ડ સાચવી શકશે.';

  @override
  String get chooseSuccessor => 'સભ્ય પસંદ કરો';

  @override
  String get none => 'કોઈ નહીં';

  @override
  String get exportData => 'મારો ડેટા નિકાસ કરો (JSON)';

  @override
  String get exportDone => 'નિકાસ શેર કરવા તૈયાર';

  @override
  String get digitalAccount => 'ડિજિટલ ખાતું';

  @override
  String get pendingMembers => 'બાકી સભ્યો';

  @override
  String get approve => 'મંજૂર';

  @override
  String get reject => 'નામંજૂર';

  @override
  String get block => 'બ્લોક';

  @override
  String get allMembers => 'બધા સભ્યો';

  @override
  String get makeAdmin => 'એડમિન બનાવો';

  @override
  String get removeAdmin => 'એડમિન દૂર કરો';

  @override
  String get supportAgent => 'સહાય એજન્ટ';

  @override
  String get noPending => 'કોઈ બાકી વિનંતી નથી.';

  @override
  String get loading => 'લોડ થઈ રહ્યું છે...';

  @override
  String get retry => 'ફરી પ્રયાસ';

  @override
  String get ok => 'ઠીક';

  @override
  String get close => 'બંધ';

  @override
  String get share => 'શેર';

  @override
  String get done => 'થઈ ગયું';

  @override
  String get unknown => 'અજ્ઞાત';

  @override
  String born(String date) {
    return 'જ. $date';
  }

  @override
  String died(String date) {
    return 'અ. $date';
  }

  @override
  String get premiumBadge => 'પ્રીમિયમ';

  @override
  String get adminBadge => 'એડમિન';

  @override
  String get you => 'તમે';

  @override
  String get openLink => 'લિંક ખોલો';

  @override
  String get document => 'દસ્તાવેજ';

  @override
  String get video => 'વિડિયો';

  @override
  String get photo => 'ફોટો';

  @override
  String generationsHint(int count) {
    return 'દર્શાવેલ પેઢીઓ: $count';
  }

  @override
  String get deletePerson => 'વ્યક્તિ કાઢી નાખો (એડમિન)';

  @override
  String get linkedToYou => 'તમારા ખાતા સાથે જોડાયેલ';

  @override
  String get claimedBySomeone => 'એક સભ્ય સાથે જોડાયેલ';

  @override
  String get selectFamily => 'પરિવાર પસંદ કરો';

  @override
  String get chooseFamilyForSpouse => 'જીવનસાથીનો પરિવાર (પિયર)';

  @override
  String get recentlyAdded => 'તાજેતરમાં ઉમેરાયેલ';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વ્યક્તિઓ',
      one: '1 વ્યક્તિ',
      zero: 'કોઈ વ્યક્તિ નથી',
    );
    return '$_temp0';
  }

  @override
  String get yourRecord => 'તમારો રેકોર્ડ';

  @override
  String get noProfileYet =>
      'તમે હજુ કોઈ વ્યક્તિ રેકોર્ડ જોડ્યો નથી. નવો બનાવો અથવા વંશવૃક્ષમાં તમારો રેકોર્ડ ખોલી \"આ હું છું\" દબાવો.';

  @override
  String get relatives => 'સંબંધીઓ';

  @override
  String get contact => 'સંપર્ક';

  @override
  String get identity => 'ઓળખ';

  @override
  String get places => 'સ્થળો';

  @override
  String get chooseMember => 'સભ્ય પસંદ કરો';

  @override
  String get mapAttribution =>
      'નકશા ડેટા પસંદ કરેલા સ્ત્રોતમાંથી. સરકારી સ્તરો: NIC ભારતમેપ્સ / ISRO ભુવન.';
}
