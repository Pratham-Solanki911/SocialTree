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
  String get signInTagline => 'આપણા પરિવારો, આપણું વંશવૃક્ષ, આપણાં મૂળ';

  @override
  String get signInWithGoogle => 'મારા Google ખાતાથી ખોલો';

  @override
  String signInFailed(String message) {
    return 'ખોલી શકાયું નહીં: $message';
  }

  @override
  String get pendingTitle => 'થોડી રાહ જુઓ';

  @override
  String get pendingBody =>
      'સમાજના સંચાલક તમને અંદર લેશે. આ સ્ક્રીન આપમેળે બદલાશે.';

  @override
  String get rejectedBody =>
      'તમને અંદર લેવાયા નથી. સમાજના સંચાલક સાથે વાત કરો.';

  @override
  String get blockedBody =>
      'તમારું ખાતું બંધ કરાયું છે. સમાજના સંચાલક સાથે વાત કરો.';

  @override
  String get signOut => 'એપમાંથી બહાર નીકળો';

  @override
  String get setupTitle => 'એપ તૈયાર નથી';

  @override
  String get setupBody =>
      '--dart-define=SUPABASE_URL=... અને --dart-define=SUPABASE_ANON_KEY=... સાથે બિલ્ડ કરો. README.md જુઓ.';

  @override
  String get navHome => 'ઘર';

  @override
  String get navFamilies => 'પરિવારો';

  @override
  String get navSearch => 'વ્યક્તિ શોધો';

  @override
  String get navMap => 'નકશો';

  @override
  String get navAccount => 'મારું ખાતું';

  @override
  String get homeFeed => 'સમાજના સમાચાર';

  @override
  String get noUpdates => 'હજુ કોઈ જન્મ, લગ્ન કે અવસાન લખાયા નથી.';

  @override
  String get quickActions => 'તમે શું કરવા માંગો છો?';

  @override
  String get myProfile => 'મારી નોંધ';

  @override
  String get createMyProfile => 'મને વૃક્ષમાં ઉમેરો';

  @override
  String get addRelative => 'સગું ઉમેરો';

  @override
  String get viewTree => 'વંશવૃક્ષ જુઓ';

  @override
  String get matches => 'એક જ વ્યક્તિ બે વાર લખાઈ છે?';

  @override
  String get gotraLookup => 'ગોત્ર અને કુળદેવી';

  @override
  String get albums => 'ફોટા';

  @override
  String get chat => 'સંદેશા';

  @override
  String get support => 'મદદ માંગો';

  @override
  String get notifications => 'તમારા માટે સંદેશા';

  @override
  String get admin => 'સમાજ સંચાલન';

  @override
  String get familiesTitle => 'પરિવારો';

  @override
  String get newFamily => 'પરિવાર ઉમેરો';

  @override
  String get familyName => 'પરિવારનું નામ (દા.ત. સોલંકી પરિવાર, મોરબી)';

  @override
  String get surname => 'અટક';

  @override
  String get nativeVillage => 'મૂળ ગામ';

  @override
  String get description => 'થોડું વર્ણન';

  @override
  String get members => 'આ પરિવારના લોકો';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વ્યક્તિ',
      one: '1 વ્યક્તિ',
      zero: 'હજુ કોઈ નહીં',
    );
    return '$_temp0';
  }

  @override
  String get noFamilies => 'હજુ કોઈ પરિવાર ઉમેરાયો નથી. પહેલો ઉમેરો.';

  @override
  String get createFamily => 'આ પરિવાર ઉમેરો';

  @override
  String get familyTree => 'વંશવૃક્ષ';

  @override
  String get familyAlbum => 'પરિવારના ફોટા';

  @override
  String get addPerson => 'વ્યક્તિ ઉમેરો';

  @override
  String get personDetails => 'આ વ્યક્તિ વિશે';

  @override
  String get firstName => 'નામ';

  @override
  String get middleName => 'પિતા કે પતિનું નામ';

  @override
  String get lastName => 'અટક';

  @override
  String get maidenName => 'લગ્ન પહેલાંની અટક';

  @override
  String get nickname => 'ઘરનું નામ';

  @override
  String get gender => 'સ્ત્રી કે પુરુષ';

  @override
  String get male => 'પુરુષ';

  @override
  String get female => 'સ્ત્રી';

  @override
  String get other => 'અન્ય';

  @override
  String get dateOfBirth => 'જન્મ તારીખ';

  @override
  String get approximate => 'ચોક્કસ નહીં, આશરે';

  @override
  String get dateOfDeath => 'અવસાનની તારીખ';

  @override
  String get deceased => 'અવસાન પામ્યા છે';

  @override
  String get alive => 'હયાત છે';

  @override
  String get birthPlace => 'જન્મ સ્થળ';

  @override
  String get currentPlace => 'હાલ ક્યાં રહે છે';

  @override
  String get pickOnMap => 'નકશા પર બતાવો';

  @override
  String get locationSet => 'નકશા પર બતાવ્યું';

  @override
  String get phones => 'મોબાઇલ નંબર';

  @override
  String get addPhone => 'મોબાઇલ નંબર ઉમેરો';

  @override
  String get phoneNumber => 'નંબર';

  @override
  String get countryCode => 'કયો દેશ';

  @override
  String get phoneLabel => 'કયો નંબર છે (ઘર, દુકાન, UK...)';

  @override
  String get whatsapp => 'આ નંબર પર WhatsApp છે';

  @override
  String get openWhatsApp => 'WhatsApp પર સંદેશ મોકલો';

  @override
  String get call => 'ફોન કરો';

  @override
  String get invalidPhone => 'ફક્ત આંકડા લખો, 6 થી 14';

  @override
  String get email => 'ઈમેલ';

  @override
  String get occupation => 'કામ-ધંધો';

  @override
  String get education => 'ભણતર';

  @override
  String get maritalStatus => 'પરણેલા કે અપરિણીત';

  @override
  String get bloodGroup => 'બ્લડ ગ્રુપ';

  @override
  String get biography => 'જીવનની વાત';

  @override
  String get notes => 'બીજી નોંધ';

  @override
  String get passportPhoto => 'પાસપોર્ટ ફોટો';

  @override
  String get takePhoto => 'હમણાં ફોટો પાડો';

  @override
  String get chooseFromGallery => 'ફોનમાંથી ફોટો પસંદ કરો';

  @override
  String get removePhoto => 'આ ફોટો કાઢો';

  @override
  String photoCompressedTo(String size) {
    return 'ફોટો નાનો કર્યો: $size';
  }

  @override
  String get save => 'સાચવો';

  @override
  String get savePerson => 'આ વ્યક્તિ સાચવો';

  @override
  String get cancel => 'પાછા જાઓ';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get edit => 'વિગતો બદલો';

  @override
  String get gotra => 'ગોત્ર';

  @override
  String get kuldevi => 'કુળદેવી';

  @override
  String get kuldevta => 'કુળદેવતા';

  @override
  String fromGotra(String value) {
    return 'ગોત્ર પ્રમાણે: $value';
  }

  @override
  String fromFamily(String value) {
    return 'પરિવાર પ્રમાણે: $value';
  }

  @override
  String get family => 'પરિવાર';

  @override
  String get requiredField => 'આ ભરવું જરૂરી છે';

  @override
  String get saved => 'સાચવાઈ ગયું';

  @override
  String errorWithMessage(String message) {
    return 'કંઈક ખોટું થયું: $message';
  }

  @override
  String get confirmDelete => 'આ કાઢી નાખવું? પછી પાછું નહીં આવે.';

  @override
  String get about => 'વિગતો';

  @override
  String get timeline => 'જીવનના પ્રસંગો';

  @override
  String get media => 'ફોટા અને ફાઇલો';

  @override
  String get parents => 'માતા-પિતા';

  @override
  String get children => 'સંતાનો';

  @override
  String get spouses => 'પતિ / પત્ની';

  @override
  String get siblings => 'ભાઈ-બહેન';

  @override
  String get addParent => 'માતા કે પિતા ઉમેરો';

  @override
  String get addChild => 'દીકરો કે દીકરી ઉમેરો';

  @override
  String get addSpouse => 'પતિ કે પત્ની ઉમેરો';

  @override
  String get linkExisting => 'તેઓ વૃક્ષમાં છે જ, પસંદ કરો';

  @override
  String get createNew => 'નવી વ્યક્તિ તરીકે ઉમેરો';

  @override
  String get selectPerson => 'વ્યક્તિ પસંદ કરો';

  @override
  String get marriedOn => 'લગ્નની તારીખ';

  @override
  String get relationshipAdded => 'સંબંધ ઉમેરાયો';

  @override
  String get removeRelationship => 'આ સંબંધ કાઢો';

  @override
  String get treeGraph => 'આખું વૃક્ષ';

  @override
  String get ancestors => 'પૂર્વજો';

  @override
  String get descendants => 'વંશજો';

  @override
  String get generations => 'પેઢીઓ';

  @override
  String get noRelatives => 'હજુ કોઈ સગાં જોડાયાં નથી.';

  @override
  String get lifeEvents => 'જીવનના પ્રસંગો';

  @override
  String get addEvent => 'જીવનનો પ્રસંગ લખો';

  @override
  String get eventKind => 'શું થયું';

  @override
  String get eventTitle => 'ટૂંકમાં';

  @override
  String get eventDate => 'ક્યારે';

  @override
  String get place => 'ક્યાં';

  @override
  String get kindBirth => 'જન્મ';

  @override
  String get kindEducation => 'ભણતર';

  @override
  String get kindMigration => 'નવી જગ્યાએ રહેવા ગયા';

  @override
  String get kindMarriage => 'લગ્ન';

  @override
  String get kindCareer => 'કામ-ધંધો';

  @override
  String get kindDeath => 'અવસાન';

  @override
  String get kindOther => 'બીજું કંઈક';

  @override
  String get noEvents => 'હજુ કંઈ લખાયું નથી.';

  @override
  String get migrationMap => 'આપણા લોકો ક્યાં ગયા';

  @override
  String get mapSource => 'નકશાનો પ્રકાર';

  @override
  String get mapBharatmaps => 'ભારતમેપ્સ (ભારત સરકાર)';

  @override
  String get mapBhuvan => 'ભુવન (ISRO)';

  @override
  String get mapOsm => 'OpenStreetMap';

  @override
  String get mapTilesFailed => 'આ નકશો ખૂલતો નથી. બીજો નકશો અજમાવો.';

  @override
  String get allFamilies => 'બધા પરિવારો';

  @override
  String get tapToPick => 'જગ્યા જ્યાં છે ત્યાં નકશા પર આંગળી મૂકો';

  @override
  String get clearLocation => 'નિશાન કાઢો';

  @override
  String get noPaths =>
      'હજુ કોઈ જગ્યા લખાઈ નથી. લોકો ક્યાં જન્મ્યા અને હાલ ક્યાં રહે છે તે ઉમેરો.';

  @override
  String get searchHint => 'નામ, ગામ કે જગ્યા લખો';

  @override
  String get noResults => 'કોઈ મળ્યું નહીં';

  @override
  String get onlyMyAncestors => 'ફક્ત મારા પૂર્વજો';

  @override
  String get findMatches => 'બેવડી નોંધ તપાસો';

  @override
  String get noMatches => 'કોઈ બેવડી નોંધ મળી નથી.';

  @override
  String get possibleDuplicate => 'આ બંને એક જ વ્યક્તિ હોઈ શકે';

  @override
  String matchScore(int score) {
    return '$score% મળતું';
  }

  @override
  String get mergeInto => 'બંનેને એક કરો (સંચાલક)';

  @override
  String get keepWhich => 'કઈ નોંધ રાખવી?';

  @override
  String get dismiss => 'તેઓ જુદા લોકો છે';

  @override
  String matchesRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count બેવડી નોંધ મળી',
      one: '1 બેવડી નોંધ મળી',
      zero: 'કોઈ બેવડી નોંધ નથી',
    );
    return '$_temp0';
  }

  @override
  String get lookupBySurname => 'અટક લખો';

  @override
  String get addMapping => 'અટક અને તેનું ગોત્ર ઉમેરો';

  @override
  String get addGotra => 'ગોત્ર ઉમેરો';

  @override
  String get verified => 'સમાજે ખાતરી કરી';

  @override
  String get unverified => 'હજુ ખાતરી બાકી';

  @override
  String get village => 'ગામ';

  @override
  String get communityContributed =>
      'આ સભ્યો લખે છે. વડીલોને પણ પૂછો; સમાજ ખાતરી કરેલાને નિશાની આપે છે.';

  @override
  String get markVerified => 'ખાતરી થઈ, નિશાની આપો';

  @override
  String get newAlbum => 'નવો આલ્બમ બનાવો';

  @override
  String get albumTitle => 'આલ્બમનું નામ';

  @override
  String get uploadPhoto => 'ફોટો ઉમેરો';

  @override
  String get addVideoLink => 'વિડિયોની લિંક ઉમેરો (YouTube)';

  @override
  String get uploadDocument => 'PDF ફાઇલ ઉમેરો';

  @override
  String get videoUrl => 'વિડિયોની લિંક અહીં લખો';

  @override
  String get caption => 'આ ફોટો શેનો છે';

  @override
  String get noMedia => 'હજુ અહીં કંઈ નથી.';

  @override
  String get fileTooLarge => 'આ ફાઇલ બહુ મોટી છે (5 MB થી વધુ).';

  @override
  String get markAllRead => 'બધા વાંચી લીધા';

  @override
  String get noNotifications => 'તમારા માટે કોઈ સંદેશ નથી.';

  @override
  String get newChat => 'કોઈને સંદેશ મોકલો';

  @override
  String get messageHint => 'તમારો સંદેશ લખો';

  @override
  String get send => 'મોકલો';

  @override
  String get noConversations => 'તમે હજુ કોઈને સંદેશ મોકલ્યો નથી.';

  @override
  String get newTicket => 'મદદ માંગો';

  @override
  String get subject => 'શેના વિશે';

  @override
  String get message => 'વધુ લખો';

  @override
  String get priority => 'કેટલું જરૂરી';

  @override
  String get status => 'ક્યાં પહોંચ્યું';

  @override
  String get statusOpen => 'હજુ જોયું નથી';

  @override
  String get statusInProgress => 'જોવાઈ રહ્યું છે';

  @override
  String get statusResolved => 'ઉકેલાઈ ગયું';

  @override
  String get priorityHigh => 'તાકીદનું';

  @override
  String get priorityNormal => 'સામાન્ય';

  @override
  String get reply => 'જવાબ લખો';

  @override
  String get noTickets => 'તમે હજુ મદદ માંગી નથી.';

  @override
  String get language => 'ભાષા';

  @override
  String get english => 'English';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get successor => 'મારા પછી મારી નોંધ કોણ સાચવશે';

  @override
  String get successorInfo =>
      'એક સભ્ય પસંદ કરો. તમારા પછી તેઓ તમારી નોંધ સુધારી શકશે.';

  @override
  String get chooseSuccessor => 'સભ્ય પસંદ કરો';

  @override
  String get none => 'કોઈ નહીં';

  @override
  String get digitalAccount => 'સમાજમાં મારી નોંધ';

  @override
  String get pendingMembers => 'જોડાવા રાહ જોતા લોકો';

  @override
  String get approve => 'અંદર લો';

  @override
  String get reject => 'અંદર ન લો';

  @override
  String get block => 'આ ખાતું બંધ કરો';

  @override
  String get allMembers => 'બધા સભ્યો';

  @override
  String get makeAdmin => 'સમાજ સંચાલક બનાવો';

  @override
  String get removeAdmin => 'સંચાલક પદેથી હટાવો';

  @override
  String get supportAgent => 'મદદના સવાલોના જવાબ આપે છે';

  @override
  String get noPending => 'કોઈ રાહ જોતું નથી.';

  @override
  String get loading => 'થોડી રાહ જુઓ...';

  @override
  String get retry => 'ફરી પ્રયત્ન કરો';

  @override
  String get ok => 'બરાબર';

  @override
  String get close => 'બંધ કરો';

  @override
  String get share => 'કોઈને મોકલો';

  @override
  String get done => 'થઈ ગયું';

  @override
  String get unknown => 'ખબર નથી';

  @override
  String born(String date) {
    return 'જન્મ $date';
  }

  @override
  String died(String date) {
    return 'અવસાન $date';
  }

  @override
  String get adminBadge => 'સમાજ સંચાલક';

  @override
  String get you => 'તમે';

  @override
  String get openLink => 'ખોલો';

  @override
  String get document => 'PDF ફાઇલ';

  @override
  String get video => 'વિડિયો';

  @override
  String get photo => 'ફોટો';

  @override
  String generationsHint(int count) {
    return '$count પેઢી બતાવો';
  }

  @override
  String get deletePerson => 'આ વ્યક્તિ કાઢી નાખો (સંચાલક)';

  @override
  String get linkedToYou => 'આ તમે છો';

  @override
  String get linkedToMember => 'આ વ્યક્તિ એપ વાપરે છે';

  @override
  String get selectFamily => 'કયો પરિવાર';

  @override
  String get chooseFamilyForSpouse => 'લગ્ન પહેલાંનો તેમનો પરિવાર';

  @override
  String get recentlyAdded => 'હમણાં ઉમેરાયેલા';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count વ્યક્તિ',
      one: '1 વ્યક્તિ',
      zero: 'કોઈ નહીં',
    );
    return '$_temp0';
  }

  @override
  String get yourRecord => 'તમારી નોંધ';

  @override
  String get noProfileYet =>
      'તમે હજુ કોઈ નોંધ સાથે જોડાયા નથી. વૃક્ષમાં તમને શોધો, અથવા તમને ઉમેરો.';

  @override
  String get relatives => 'સગાં';

  @override
  String get contact => 'સંપર્ક';

  @override
  String get identity => 'નામ';

  @override
  String get places => 'જગ્યાઓ';

  @override
  String get chooseMember => 'સભ્ય પસંદ કરો';

  @override
  String get mapAttribution =>
      'નકશો: પસંદ કરેલો સ્ત્રોત. સરકારી સ્તરો: NIC ભારતમેપ્સ / ISRO ભુવન.';

  @override
  String get downloadTreePdf => 'વંશવૃક્ષ ડાઉનલોડ કરો (PDF)';

  @override
  String get treePdfInfo => 'ઉપર-નીચે પાંચ પેઢી, ભાઈ-બહેન અને પતિ-પત્ની સાથે.';

  @override
  String get includePhotos => 'પાસપોર્ટ ફોટા પણ મૂકો';

  @override
  String get generatingPdf => 'PDF બની રહી છે...';

  @override
  String get pdfReady => 'PDF તૈયાર છે';

  @override
  String get generationsUp => 'ઉપરની પેઢીઓ';

  @override
  String get generationsDown => 'નીચેની પેઢીઓ';

  @override
  String get welcomeTitle => 'આપણા સમાજની એપમાં આપનું સ્વાગત છે';

  @override
  String get chooseLanguage => 'તમને કઈ ભાષા ગમશે?';

  @override
  String get continueLabel => 'આગળ વધો';

  @override
  String get greetingJayShreeKrishna => 'જય શ્રી કૃષ્ણ 🙏';

  @override
  String get greetingJayMataji => 'જય માતાજી 🙏';

  @override
  String get greetingRamRam => 'રામ રામ 🙏';

  @override
  String get greetingJayVishwakarma => 'જય વિશ્વકર્મા 🙏';

  @override
  String pdfGeneratedOn(String date) {
    return '$date ના રોજ SocialTree થી બનાવેલ';
  }

  @override
  String treeOf(String name) {
    return '$name નું વંશવૃક્ષ';
  }

  @override
  String pageOf(int page, int total) {
    return 'પાનું $page / $total';
  }

  @override
  String get findMeTitle => 'શું તમે વૃક્ષમાં છો જ?';

  @override
  String get findMeIntro => 'કદાચ કોઈ સગાએ તમને લખી દીધા હોય. ચાલો જોઈએ.';

  @override
  String get yourFirstName => 'તમારું નામ';

  @override
  String get yourLastName => 'તમારી અટક';

  @override
  String get yourVillage => 'તમારું મૂળ ગામ (ઈચ્છો તો)';

  @override
  String get yourBirthYear => 'જન્મનું વર્ષ (ઈચ્છો તો)';

  @override
  String get yourMobile => 'તમારો મોબાઇલ નંબર (ઈચ્છો તો)';

  @override
  String get searchForMe => 'મને શોધો';

  @override
  String get areYouThisPerson => 'શું આ તમે જ છો?';

  @override
  String get yesThisIsMe => 'હા, આ હું જ છું';

  @override
  String get noNotMe => 'ના, આ હું નથી';

  @override
  String get notInListAddMe => 'હું યાદીમાં નથી, મને ઉમેરો';

  @override
  String get doThisLater => 'હું આ પછી કરીશ';

  @override
  String get requestSent =>
      'અમે તમારા પરિવારને ખાતરી કરવા કહ્યું છે. તમને અહીં સંદેશ મળશે.';

  @override
  String get linkedNow => 'થઈ ગયું. હવે આ નોંધ તમારી છે.';

  @override
  String parentsLabel(String names) {
    return 'માતા-પિતા: $names';
  }

  @override
  String get noCandidates => 'અમને તમે મળ્યા નહીં. તમે તમને ઉમેરી શકો છો.';

  @override
  String get waitingForFamily => 'તમારા પરિવારની ખાતરીની રાહ છે કે આ તમે જ છો';

  @override
  String get cancelRequest => 'મારી વિનંતી રદ કરો';

  @override
  String get unlinkMe => 'હવે આ મારી નોંધ નથી';

  @override
  String get inMemoryOf => 'સ્મરણાંજલિ';

  @override
  String passedAwayOn(String date) {
    return 'અવસાન: $date';
  }

  @override
  String lookedAfterBy(String name) {
    return 'આ નોંધ $name સાચવે છે';
  }

  @override
  String get chooseCaretaker => 'આ નોંધ કોણ સાચવશે તે પસંદ કરો';

  @override
  String get claimsTitle => '\"આ હું છું\" વિનંતીઓ';

  @override
  String get pendingRequests => 'જવાબની રાહમાં';

  @override
  String get pastRequests => 'અગાઉ જવાબ અપાયેલા';

  @override
  String get confirmYes => 'હા, આ તેઓ જ છે';

  @override
  String get confirmNo => 'ના, આ તેઓ નથી';

  @override
  String get noRequests => 'કોઈ વિનંતી નથી.';

  @override
  String requestFrom(String name) {
    return '$name કહે છે: આ હું છું';
  }

  @override
  String get mergeIntoMine => 'આ પણ હું જ છું. મારી નોંધ સાથે જોડો';

  @override
  String yourRecordLinked(String name) {
    return 'તમારી નોંધ: $name';
  }

  @override
  String get findMyselfAgain => 'વૃક્ષમાં મારી નોંધ શોધો';

  @override
  String get requestDecided => 'જવાબ અપાયો';

  @override
  String get statusApproved => 'ખાતરી થઈ';

  @override
  String get statusRejected => 'ખાતરી ન થઈ';

  @override
  String get statusWithdrawn => 'રદ થયું';

  @override
  String get statusPending => 'રાહમાં';
}
