// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'SocialTree';

  @override
  String get samajName => 'श्री मच्छुकाठिया सई सुथार समाज';

  @override
  String get signInTagline => 'हमारे समाज के वंशवृक्ष, अभिलेख और जड़ें';

  @override
  String get signInWithGoogle => 'Google से जारी रखें';

  @override
  String signInFailed(String message) {
    return 'साइन-इन विफल: $message';
  }

  @override
  String get pendingTitle => 'स्वीकृति की प्रतीक्षा';

  @override
  String get pendingBody =>
      'समाज का एडमिन आपकी सदस्यता स्वीकृत करेगा। यह स्क्रीन अपने आप अपडेट होगी।';

  @override
  String get rejectedBody =>
      'आपका सदस्यता अनुरोध स्वीकृत नहीं हुआ। समाज के एडमिन से संपर्क करें।';

  @override
  String get blockedBody =>
      'आपका खाता ब्लॉक किया गया है। समाज के एडमिन से संपर्क करें।';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get setupTitle => 'ऐप कॉन्फ़िगर नहीं है';

  @override
  String get setupBody =>
      '--dart-define=SUPABASE_URL=... और --dart-define=SUPABASE_ANON_KEY=... के साथ बिल्ड करें। README.md देखें।';

  @override
  String get navHome => 'होम';

  @override
  String get navFamilies => 'परिवार';

  @override
  String get navSearch => 'खोज';

  @override
  String get navMap => 'नक्शा';

  @override
  String get navAccount => 'खाता';

  @override
  String get homeFeed => 'समाज समाचार';

  @override
  String get noUpdates => 'अभी तक कोई जन्म, विवाह या निधन दर्ज नहीं है।';

  @override
  String get quickActions => 'त्वरित क्रियाएँ';

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get createMyProfile => 'मेरी प्रोफ़ाइल बनाएँ';

  @override
  String get claimProfile => 'यह मैं हूँ';

  @override
  String get claimed => 'रिकॉर्ड आपके खाते से जुड़ गया';

  @override
  String get addRelative => 'रिश्तेदार जोड़ें';

  @override
  String get viewTree => 'वृक्ष देखें';

  @override
  String get matches => 'मिलान';

  @override
  String get gotraLookup => 'गोत्र और कुलदेवी';

  @override
  String get albums => 'एल्बम';

  @override
  String get chat => 'चैट';

  @override
  String get support => 'सहायता';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get admin => 'एडमिन';

  @override
  String get familiesTitle => 'परिवार';

  @override
  String get newFamily => 'नया परिवार';

  @override
  String get familyName => 'परिवार का नाम';

  @override
  String get surname => 'उपनाम';

  @override
  String get nativeVillage => 'मूल गाँव';

  @override
  String get description => 'विवरण';

  @override
  String get members => 'सदस्य';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
      zero: 'कोई सदस्य नहीं',
    );
    return '$_temp0';
  }

  @override
  String get noFamilies => 'अभी कोई परिवार नहीं। पहला बनाएँ।';

  @override
  String get createFamily => 'परिवार बनाएँ';

  @override
  String get familyTree => 'वंशवृक्ष';

  @override
  String get familyAlbum => 'परिवार एल्बम';

  @override
  String get addPerson => 'व्यक्ति जोड़ें';

  @override
  String get personDetails => 'व्यक्ति का विवरण';

  @override
  String get firstName => 'नाम';

  @override
  String get middleName => 'पिता / पति का नाम';

  @override
  String get lastName => 'उपनाम';

  @override
  String get maidenName => 'मायके का उपनाम';

  @override
  String get nickname => 'उपनाम (घर का नाम)';

  @override
  String get gender => 'लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get other => 'अन्य';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get approximate => 'अनुमानित';

  @override
  String get dateOfDeath => 'निधन तिथि';

  @override
  String get deceased => 'स्वर्गीय';

  @override
  String get alive => 'जीवित';

  @override
  String get birthPlace => 'जन्म स्थान';

  @override
  String get currentPlace => 'वर्तमान स्थान';

  @override
  String get pickOnMap => 'नक्शे पर चुनें';

  @override
  String get locationSet => 'स्थान सेट हुआ';

  @override
  String get phones => 'फ़ोन नंबर';

  @override
  String get addPhone => 'फ़ोन जोड़ें';

  @override
  String get phoneNumber => 'नंबर';

  @override
  String get countryCode => 'देश';

  @override
  String get phoneLabel => 'लेबल';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get openWhatsApp => 'WhatsApp खोलें';

  @override
  String get call => 'कॉल';

  @override
  String get invalidPhone => 'केवल अंक, 6 से 14';

  @override
  String get email => 'ईमेल';

  @override
  String get occupation => 'व्यवसाय';

  @override
  String get education => 'शिक्षा';

  @override
  String get maritalStatus => 'वैवाहिक स्थिति';

  @override
  String get bloodGroup => 'रक्त समूह';

  @override
  String get biography => 'जीवनी';

  @override
  String get notes => 'टिप्पणियाँ';

  @override
  String get passportPhoto => 'पासपोर्ट फ़ोटो';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get removePhoto => 'फ़ोटो हटाएँ';

  @override
  String photoCompressedTo(String size) {
    return '$size तक संकुचित';
  }

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get edit => 'संपादित करें';

  @override
  String get gotra => 'गोत्र';

  @override
  String get kuldevi => 'कुलदेवी';

  @override
  String get kuldevta => 'कुलदेवता';

  @override
  String fromGotra(String value) {
    return 'गोत्र के अनुसार: $value';
  }

  @override
  String fromFamily(String value) {
    return 'परिवार के अनुसार: $value';
  }

  @override
  String get family => 'परिवार';

  @override
  String get requiredField => 'आवश्यक';

  @override
  String get saved => 'सहेजा गया';

  @override
  String errorWithMessage(String message) {
    return 'कुछ गलत हुआ: $message';
  }

  @override
  String get confirmDelete => 'इसे हटाएँ? यह पूर्ववत नहीं किया जा सकता।';

  @override
  String get about => 'परिचय';

  @override
  String get timeline => 'समयरेखा';

  @override
  String get media => 'मीडिया';

  @override
  String get parents => 'माता-पिता';

  @override
  String get children => 'संतान';

  @override
  String get spouses => 'जीवनसाथी';

  @override
  String get siblings => 'भाई-बहन';

  @override
  String get addParent => 'माता/पिता जोड़ें';

  @override
  String get addChild => 'संतान जोड़ें';

  @override
  String get addSpouse => 'जीवनसाथी जोड़ें';

  @override
  String get linkExisting => 'मौजूदा व्यक्ति जोड़ें';

  @override
  String get createNew => 'नया व्यक्ति बनाएँ';

  @override
  String get selectPerson => 'व्यक्ति चुनें';

  @override
  String get marriedOn => 'विवाह तिथि';

  @override
  String get relationshipAdded => 'रिश्ता जोड़ा गया';

  @override
  String get removeRelationship => 'रिश्ता हटाएँ';

  @override
  String get treeGraph => 'ग्राफ़';

  @override
  String get ancestors => 'पूर्वज';

  @override
  String get descendants => 'वंशज';

  @override
  String get generations => 'पीढ़ियाँ';

  @override
  String get noRelatives => 'अभी कोई रिश्तेदार नहीं जुड़ा।';

  @override
  String get lifeEvents => 'जीवन की घटनाएँ';

  @override
  String get addEvent => 'घटना जोड़ें';

  @override
  String get eventKind => 'प्रकार';

  @override
  String get eventTitle => 'शीर्षक';

  @override
  String get eventDate => 'तिथि';

  @override
  String get place => 'स्थान';

  @override
  String get kindBirth => 'जन्म';

  @override
  String get kindEducation => 'शिक्षा';

  @override
  String get kindMigration => 'प्रवास';

  @override
  String get kindMarriage => 'विवाह';

  @override
  String get kindCareer => 'करियर';

  @override
  String get kindDeath => 'निधन';

  @override
  String get kindOther => 'अन्य';

  @override
  String get noEvents => 'अभी कोई घटना नहीं।';

  @override
  String get migrationMap => 'प्रवास नक्शा';

  @override
  String get mapSource => 'नक्शा स्रोत';

  @override
  String get mapBharatmaps => 'भारतमैप्स (भारत सरकार)';

  @override
  String get mapBhuvan => 'भुवन (ISRO)';

  @override
  String get mapOsm => 'OpenStreetMap';

  @override
  String get mapTilesFailed =>
      'इस स्रोत के नक्शे लोड नहीं हो रहे। दूसरा स्रोत आज़माएँ।';

  @override
  String get allFamilies => 'सभी परिवार';

  @override
  String get tapToPick => 'स्थान सेट करने के लिए नक्शे पर टैप करें';

  @override
  String get clearLocation => 'स्थान हटाएँ';

  @override
  String get noPaths =>
      'अभी कोई स्थान दर्ज नहीं। जन्म स्थान, वर्तमान स्थान या प्रवास घटनाएँ जोड़ें।';

  @override
  String get searchHint => 'नाम, गाँव या स्थान से खोजें';

  @override
  String get noResults => 'कोई परिणाम नहीं';

  @override
  String get onlyMyAncestors => 'केवल मेरे पूर्वज';

  @override
  String get findMatches => 'मिलान खोजें';

  @override
  String get noMatches => 'कोई संभावित डुप्लिकेट नहीं मिला।';

  @override
  String get possibleDuplicate => 'संभावित डुप्लिकेट';

  @override
  String matchScore(int score) {
    return '$score% मिलान';
  }

  @override
  String get mergeInto => 'मर्ज करें (एडमिन)';

  @override
  String get keepWhich => 'कौन सा रिकॉर्ड रखें?';

  @override
  String get dismiss => 'अनदेखा करें';

  @override
  String matchesRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिलान मिले',
      one: '1 मिलान मिला',
      zero: 'कोई नया मिलान नहीं',
    );
    return '$_temp0';
  }

  @override
  String get lookupBySurname => 'उपनाम से खोजें';

  @override
  String get addMapping => 'उपनाम-गोत्र जोड़ें';

  @override
  String get addGotra => 'गोत्र जोड़ें';

  @override
  String get verified => 'सत्यापित';

  @override
  String get unverified => 'असत्यापित';

  @override
  String get village => 'गाँव';

  @override
  String get communityContributed =>
      'प्रविष्टियाँ सदस्य जोड़ते हैं। अपने बड़ों से पुष्टि करें; एडमिन उन्हें सत्यापित चिह्नित करते हैं।';

  @override
  String get markVerified => 'सत्यापित चिह्नित करें';

  @override
  String get newAlbum => 'नया एल्बम';

  @override
  String get albumTitle => 'एल्बम का नाम';

  @override
  String get uploadPhoto => 'फ़ोटो अपलोड करें';

  @override
  String get addVideoLink => 'वीडियो लिंक जोड़ें';

  @override
  String get uploadDocument => 'दस्तावेज़ अपलोड करें (PDF)';

  @override
  String get videoUrl => 'वीडियो URL (YouTube, Drive)';

  @override
  String get caption => 'कैप्शन';

  @override
  String get noMedia => 'अभी यहाँ कुछ नहीं।';

  @override
  String get premiumOnly => 'प्रीमियम योजना की सुविधा';

  @override
  String get freePlanAlbumLimit => 'मुफ़्त योजना में एक एल्बम मिलता है।';

  @override
  String get fileTooLarge => 'फ़ाइल 5 MB से बड़ी है।';

  @override
  String get markAllRead => 'सभी पढ़ा हुआ करें';

  @override
  String get noNotifications => 'कोई सूचना नहीं।';

  @override
  String get newChat => 'नई चैट';

  @override
  String get messageHint => 'संदेश';

  @override
  String get send => 'भेजें';

  @override
  String get noConversations => 'अभी कोई बातचीत नहीं।';

  @override
  String get startChatPremium =>
      'चैट शुरू करने के लिए प्रीमियम योजना चाहिए। जवाब देना सबके लिए मुफ़्त है।';

  @override
  String get newTicket => 'नया टिकट';

  @override
  String get subject => 'विषय';

  @override
  String get message => 'संदेश';

  @override
  String get priority => 'प्राथमिकता';

  @override
  String get status => 'स्थिति';

  @override
  String get statusOpen => 'खुला';

  @override
  String get statusInProgress => 'प्रगति में';

  @override
  String get statusResolved => 'हल हुआ';

  @override
  String get priorityHigh => 'उच्च';

  @override
  String get priorityNormal => 'सामान्य';

  @override
  String get reply => 'जवाब';

  @override
  String get noTickets => 'कोई टिकट नहीं।';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'English';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get plan => 'योजना';

  @override
  String get planFree => 'मुफ़्त';

  @override
  String get planPremium => 'प्रीमियम';

  @override
  String get planInfo =>
      'योजना समाज के एडमिन तय करते हैं। ऐप में कोई भुगतान नहीं है।';

  @override
  String get successor => 'उत्तराधिकारी संपर्क';

  @override
  String get successorInfo =>
      'आपके निधन के बाद यह सदस्य आपका रिकॉर्ड संभाल सकेगा।';

  @override
  String get chooseSuccessor => 'सदस्य चुनें';

  @override
  String get none => 'कोई नहीं';

  @override
  String get exportData => 'मेरा डेटा निर्यात करें (JSON)';

  @override
  String get exportDone => 'निर्यात साझा करने के लिए तैयार';

  @override
  String get digitalAccount => 'डिजिटल खाता';

  @override
  String get pendingMembers => 'लंबित सदस्य';

  @override
  String get approve => 'स्वीकृत';

  @override
  String get reject => 'अस्वीकृत';

  @override
  String get block => 'ब्लॉक';

  @override
  String get allMembers => 'सभी सदस्य';

  @override
  String get makeAdmin => 'एडमिन बनाएँ';

  @override
  String get removeAdmin => 'एडमिन हटाएँ';

  @override
  String get supportAgent => 'सहायता एजेंट';

  @override
  String get noPending => 'कोई लंबित अनुरोध नहीं।';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get ok => 'ठीक';

  @override
  String get close => 'बंद';

  @override
  String get share => 'साझा करें';

  @override
  String get done => 'हो गया';

  @override
  String get unknown => 'अज्ञात';

  @override
  String born(String date) {
    return 'ज. $date';
  }

  @override
  String died(String date) {
    return 'नि. $date';
  }

  @override
  String get premiumBadge => 'प्रीमियम';

  @override
  String get adminBadge => 'एडमिन';

  @override
  String get you => 'आप';

  @override
  String get openLink => 'लिंक खोलें';

  @override
  String get document => 'दस्तावेज़';

  @override
  String get video => 'वीडियो';

  @override
  String get photo => 'फ़ोटो';

  @override
  String generationsHint(int count) {
    return 'दिखाई गई पीढ़ियाँ: $count';
  }

  @override
  String get deletePerson => 'व्यक्ति हटाएँ (एडमिन)';

  @override
  String get linkedToYou => 'आपके खाते से जुड़ा';

  @override
  String get claimedBySomeone => 'एक सदस्य से जुड़ा';

  @override
  String get selectFamily => 'परिवार चुनें';

  @override
  String get chooseFamilyForSpouse => 'जीवनसाथी का परिवार (मायका)';

  @override
  String get recentlyAdded => 'हाल ही में जोड़ा गया';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count व्यक्ति',
      one: '1 व्यक्ति',
      zero: 'कोई व्यक्ति नहीं',
    );
    return '$_temp0';
  }

  @override
  String get yourRecord => 'आपका रिकॉर्ड';

  @override
  String get noProfileYet =>
      'आपने अभी कोई व्यक्ति रिकॉर्ड नहीं जोड़ा। नया बनाएँ या वंशवृक्ष में अपना रिकॉर्ड खोलकर \"यह मैं हूँ\" दबाएँ।';

  @override
  String get relatives => 'रिश्तेदार';

  @override
  String get contact => 'संपर्क';

  @override
  String get identity => 'पहचान';

  @override
  String get places => 'स्थान';

  @override
  String get chooseMember => 'सदस्य चुनें';

  @override
  String get mapAttribution =>
      'नक्शा डेटा चुने गए स्रोत से। सरकारी परतें: NIC भारतमैप्स / ISRO भुवन।';
}
