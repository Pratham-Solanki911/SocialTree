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
  String get signInTagline => 'हमारे परिवार, हमारा वंशवृक्ष, हमारी जड़ें';

  @override
  String get signInWithGoogle => 'मेरे Google खाते से खोलें';

  @override
  String signInFailed(String message) {
    return 'खोल नहीं सके: $message';
  }

  @override
  String get pendingTitle => 'थोड़ा इंतज़ार करें';

  @override
  String get pendingBody =>
      'समाज के संचालक आपको अंदर लेंगे। यह स्क्रीन अपने आप बदल जाएगी।';

  @override
  String get rejectedBody =>
      'आपको अंदर नहीं लिया गया। समाज के संचालक से बात करें।';

  @override
  String get blockedBody =>
      'आपका खाता रोक दिया गया है। समाज के संचालक से बात करें।';

  @override
  String get signOut => 'ऐप से बाहर निकलें';

  @override
  String get setupTitle => 'ऐप तैयार नहीं है';

  @override
  String get setupBody =>
      '--dart-define=SUPABASE_URL=... और --dart-define=SUPABASE_ANON_KEY=... के साथ बिल्ड करें। README.md देखें।';

  @override
  String get navHome => 'घर';

  @override
  String get navFamilies => 'परिवार';

  @override
  String get navSearch => 'व्यक्ति खोजें';

  @override
  String get navMap => 'नक्शा';

  @override
  String get navAccount => 'मेरा खाता';

  @override
  String get homeFeed => 'समाज के समाचार';

  @override
  String get noUpdates => 'अभी तक कोई जन्म, विवाह या निधन लिखा नहीं गया है।';

  @override
  String get quickActions => 'आप क्या करना चाहते हैं?';

  @override
  String get myProfile => 'मेरा रिकॉर्ड';

  @override
  String get createMyProfile => 'मुझे वृक्ष में जोड़ें';

  @override
  String get addRelative => 'रिश्तेदार जोड़ें';

  @override
  String get viewTree => 'वंशवृक्ष देखें';

  @override
  String get matches => 'एक ही व्यक्ति दो बार लिखा है?';

  @override
  String get gotraLookup => 'गोत्र और कुलदेवी';

  @override
  String get albums => 'फ़ोटो';

  @override
  String get chat => 'संदेश';

  @override
  String get support => 'मदद माँगें';

  @override
  String get notifications => 'आपके लिए संदेश';

  @override
  String get admin => 'समाज संचालन';

  @override
  String get familiesTitle => 'परिवार';

  @override
  String get newFamily => 'परिवार जोड़ें';

  @override
  String get familyName => 'परिवार का नाम (जैसे: सोलंकी परिवार, मोरबी)';

  @override
  String get surname => 'उपनाम (सरनेम)';

  @override
  String get nativeVillage => 'मूल गाँव';

  @override
  String get description => 'कुछ शब्द';

  @override
  String get members => 'इस परिवार के लोग';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count व्यक्ति',
      one: '1 व्यक्ति',
      zero: 'अभी कोई नहीं',
    );
    return '$_temp0';
  }

  @override
  String get noFamilies => 'अभी कोई परिवार नहीं जोड़ा गया। पहला जोड़ें।';

  @override
  String get createFamily => 'यह परिवार जोड़ें';

  @override
  String get familyTree => 'वंशवृक्ष';

  @override
  String get familyAlbum => 'परिवार के फ़ोटो';

  @override
  String get addPerson => 'व्यक्ति जोड़ें';

  @override
  String get personDetails => 'इस व्यक्ति के बारे में';

  @override
  String get firstName => 'नाम';

  @override
  String get middleName => 'पिता या पति का नाम';

  @override
  String get lastName => 'उपनाम (सरनेम)';

  @override
  String get maidenName => 'शादी से पहले का उपनाम';

  @override
  String get nickname => 'घर का नाम';

  @override
  String get gender => 'स्त्री या पुरुष';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'स्त्री';

  @override
  String get other => 'अन्य';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get approximate => 'पक्का नहीं, लगभग';

  @override
  String get dateOfDeath => 'निधन की तिथि';

  @override
  String get deceased => 'निधन हो गया है';

  @override
  String get alive => 'जीवित हैं';

  @override
  String get birthPlace => 'जन्म स्थान';

  @override
  String get currentPlace => 'अभी कहाँ रहते हैं';

  @override
  String get pickOnMap => 'नक्शे पर दिखाएँ';

  @override
  String get locationSet => 'नक्शे पर दिखाया';

  @override
  String get phones => 'मोबाइल नंबर';

  @override
  String get addPhone => 'मोबाइल नंबर जोड़ें';

  @override
  String get phoneNumber => 'नंबर';

  @override
  String get countryCode => 'कौन सा देश';

  @override
  String get phoneLabel => 'कौन सा नंबर है (घर, दुकान, UK...)';

  @override
  String get whatsapp => 'इस नंबर पर WhatsApp है';

  @override
  String get openWhatsApp => 'WhatsApp पर संदेश भेजें';

  @override
  String get call => 'फ़ोन करें';

  @override
  String get invalidPhone => 'सिर्फ़ अंक लिखें, 6 से 14';

  @override
  String get email => 'ईमेल';

  @override
  String get occupation => 'काम-धंधा';

  @override
  String get education => 'पढ़ाई';

  @override
  String get maritalStatus => 'विवाहित या अविवाहित';

  @override
  String get bloodGroup => 'ब्लड ग्रुप';

  @override
  String get biography => 'जीवन की कहानी';

  @override
  String get notes => 'अन्य बातें';

  @override
  String get passportPhoto => 'पासपोर्ट फ़ोटो';

  @override
  String get takePhoto => 'अभी फ़ोटो लें';

  @override
  String get chooseFromGallery => 'फ़ोन से फ़ोटो चुनें';

  @override
  String get removePhoto => 'यह फ़ोटो हटाएँ';

  @override
  String photoCompressedTo(String size) {
    return 'फ़ोटो छोटा किया: $size';
  }

  @override
  String get save => 'सहेजें';

  @override
  String get savePerson => 'इस व्यक्ति को सहेजें';

  @override
  String get cancel => 'वापस जाएँ';

  @override
  String get delete => 'हटाएँ';

  @override
  String get edit => 'विवरण बदलें';

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
  String get requiredField => 'इसे भरना ज़रूरी है';

  @override
  String get saved => 'सहेज लिया';

  @override
  String errorWithMessage(String message) {
    return 'कुछ गड़बड़ हुई: $message';
  }

  @override
  String get confirmDelete => 'इसे हटाएँ? फिर वापस नहीं आएगा।';

  @override
  String get about => 'विवरण';

  @override
  String get timeline => 'जीवन की घटनाएँ';

  @override
  String get media => 'फ़ोटो और फ़ाइलें';

  @override
  String get parents => 'माता-पिता';

  @override
  String get children => 'संतान';

  @override
  String get spouses => 'पति / पत्नी';

  @override
  String get siblings => 'भाई-बहन';

  @override
  String get addParent => 'माता या पिता जोड़ें';

  @override
  String get addChild => 'बेटा या बेटी जोड़ें';

  @override
  String get addSpouse => 'पति या पत्नी जोड़ें';

  @override
  String get linkExisting => 'वे वृक्ष में पहले से हैं, चुनें';

  @override
  String get createNew => 'नए व्यक्ति के रूप में जोड़ें';

  @override
  String get selectPerson => 'व्यक्ति चुनें';

  @override
  String get marriedOn => 'शादी की तारीख';

  @override
  String get relationshipAdded => 'रिश्ता जोड़ा गया';

  @override
  String get removeRelationship => 'यह रिश्ता हटाएँ';

  @override
  String get treeGraph => 'पूरा वृक्ष';

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
  String get addEvent => 'जीवन की घटना लिखें';

  @override
  String get eventKind => 'क्या हुआ';

  @override
  String get eventTitle => 'संक्षेप में';

  @override
  String get eventDate => 'कब';

  @override
  String get place => 'कहाँ';

  @override
  String get kindBirth => 'जन्म';

  @override
  String get kindEducation => 'पढ़ाई';

  @override
  String get kindMigration => 'नई जगह रहने गए';

  @override
  String get kindMarriage => 'शादी';

  @override
  String get kindCareer => 'काम-धंधा';

  @override
  String get kindDeath => 'निधन';

  @override
  String get kindOther => 'कुछ और';

  @override
  String get noEvents => 'अभी कुछ नहीं लिखा गया।';

  @override
  String get migrationMap => 'हमारे लोग कहाँ गए';

  @override
  String get mapSource => 'नक्शे का प्रकार';

  @override
  String get mapBharatmaps => 'भारतमैप्स (भारत सरकार)';

  @override
  String get mapBhuvan => 'भुवन (ISRO)';

  @override
  String get mapOsm => 'OpenStreetMap';

  @override
  String get mapTilesFailed => 'यह नक्शा नहीं खुल रहा। दूसरा नक्शा आज़माएँ।';

  @override
  String get allFamilies => 'सभी परिवार';

  @override
  String get tapToPick => 'जहाँ जगह है वहाँ नक्शे पर उँगली रखें';

  @override
  String get clearLocation => 'निशान हटाएँ';

  @override
  String get noPaths =>
      'अभी कोई जगह नहीं लिखी। लोग कहाँ जन्मे और अभी कहाँ रहते हैं, यह जोड़ें।';

  @override
  String get searchHint => 'नाम, गाँव या जगह लिखें';

  @override
  String get noResults => 'कोई नहीं मिला';

  @override
  String get onlyMyAncestors => 'सिर्फ़ मेरे पूर्वज';

  @override
  String get findMatches => 'दोहरी प्रविष्टि जाँचें';

  @override
  String get noMatches => 'कोई दोहरी प्रविष्टि नहीं मिली।';

  @override
  String get possibleDuplicate => 'ये दोनों एक ही व्यक्ति हो सकते हैं';

  @override
  String matchScore(int score) {
    return '$score% मिलता';
  }

  @override
  String get mergeInto => 'दोनों को एक करें (संचालक)';

  @override
  String get keepWhich => 'कौन सा रखें?';

  @override
  String get dismiss => 'वे अलग लोग हैं';

  @override
  String matchesRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दोहरी प्रविष्टियाँ मिलीं',
      one: '1 दोहरी प्रविष्टि मिली',
      zero: 'कोई दोहरी प्रविष्टि नहीं',
    );
    return '$_temp0';
  }

  @override
  String get lookupBySurname => 'उपनाम लिखें';

  @override
  String get addMapping => 'उपनाम और उसका गोत्र जोड़ें';

  @override
  String get addGotra => 'गोत्र जोड़ें';

  @override
  String get verified => 'समाज ने पुष्टि की';

  @override
  String get unverified => 'अभी पुष्टि बाकी';

  @override
  String get village => 'गाँव';

  @override
  String get communityContributed =>
      'इन्हें सदस्य लिखते हैं। बड़ों से भी पूछें; समाज जाँची हुई को निशान देता है।';

  @override
  String get markVerified => 'पुष्टि हुई, निशान दें';

  @override
  String get newAlbum => 'नया एल्बम बनाएँ';

  @override
  String get albumTitle => 'एल्बम का नाम';

  @override
  String get uploadPhoto => 'फ़ोटो जोड़ें';

  @override
  String get addVideoLink => 'वीडियो का लिंक जोड़ें (YouTube)';

  @override
  String get uploadDocument => 'PDF फ़ाइल जोड़ें';

  @override
  String get videoUrl => 'वीडियो का लिंक यहाँ लिखें';

  @override
  String get caption => 'यह फ़ोटो किसका है';

  @override
  String get noMedia => 'अभी यहाँ कुछ नहीं।';

  @override
  String get fileTooLarge => 'यह फ़ाइल बहुत बड़ी है (5 MB से ज़्यादा)।';

  @override
  String get markAllRead => 'सब पढ़ लिए';

  @override
  String get noNotifications => 'आपके लिए कोई संदेश नहीं।';

  @override
  String get newChat => 'किसी को संदेश भेजें';

  @override
  String get messageHint => 'अपना संदेश लिखें';

  @override
  String get send => 'भेजें';

  @override
  String get noConversations => 'आपने अभी किसी को संदेश नहीं भेजा।';

  @override
  String get newTicket => 'मदद माँगें';

  @override
  String get subject => 'किस बारे में';

  @override
  String get message => 'और बताएँ';

  @override
  String get priority => 'कितना ज़रूरी';

  @override
  String get status => 'कहाँ पहुँचा';

  @override
  String get statusOpen => 'अभी देखा नहीं';

  @override
  String get statusInProgress => 'देखा जा रहा है';

  @override
  String get statusResolved => 'सुलझ गया';

  @override
  String get priorityHigh => 'ज़रूरी';

  @override
  String get priorityNormal => 'सामान्य';

  @override
  String get reply => 'जवाब लिखें';

  @override
  String get noTickets => 'आपने अभी मदद नहीं माँगी।';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'English';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get successor => 'मेरे बाद मेरा रिकॉर्ड कौन संभालेगा';

  @override
  String get successorInfo =>
      'एक सदस्य चुनें। आपके बाद वे आपका रिकॉर्ड सुधार सकेंगे।';

  @override
  String get chooseSuccessor => 'सदस्य चुनें';

  @override
  String get none => 'कोई नहीं';

  @override
  String get digitalAccount => 'समाज में मेरा रिकॉर्ड';

  @override
  String get pendingMembers => 'जुड़ने का इंतज़ार कर रहे लोग';

  @override
  String get approve => 'अंदर लें';

  @override
  String get reject => 'अंदर न लें';

  @override
  String get block => 'यह खाता रोकें';

  @override
  String get allMembers => 'सभी सदस्य';

  @override
  String get makeAdmin => 'समाज संचालक बनाएँ';

  @override
  String get removeAdmin => 'संचालक पद से हटाएँ';

  @override
  String get supportAgent => 'मदद के सवालों के जवाब देते हैं';

  @override
  String get noPending => 'कोई इंतज़ार में नहीं।';

  @override
  String get loading => 'थोड़ा रुकें...';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get close => 'बंद करें';

  @override
  String get share => 'किसी को भेजें';

  @override
  String get done => 'हो गया';

  @override
  String get unknown => 'पता नहीं';

  @override
  String born(String date) {
    return 'जन्म $date';
  }

  @override
  String died(String date) {
    return 'निधन $date';
  }

  @override
  String get adminBadge => 'समाज संचालक';

  @override
  String get you => 'आप';

  @override
  String get openLink => 'खोलें';

  @override
  String get document => 'PDF फ़ाइल';

  @override
  String get video => 'वीडियो';

  @override
  String get photo => 'फ़ोटो';

  @override
  String generationsHint(int count) {
    return '$count पीढ़ियाँ दिखाएँ';
  }

  @override
  String get deletePerson => 'इस व्यक्ति को हटाएँ (संचालक)';

  @override
  String get linkedToYou => 'यह आप हैं';

  @override
  String get linkedToMember => 'यह व्यक्ति ऐप चलाते हैं';

  @override
  String get selectFamily => 'कौन सा परिवार';

  @override
  String get chooseFamilyForSpouse => 'शादी से पहले उनका परिवार';

  @override
  String get recentlyAdded => 'हाल में जोड़े गए';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count व्यक्ति',
      one: '1 व्यक्ति',
      zero: 'कोई नहीं',
    );
    return '$_temp0';
  }

  @override
  String get yourRecord => 'आपका रिकॉर्ड';

  @override
  String get noProfileYet =>
      'आप अभी किसी रिकॉर्ड से नहीं जुड़े हैं। वृक्ष में खुद को खोजें, या खुद को जोड़ें।';

  @override
  String get relatives => 'रिश्तेदार';

  @override
  String get contact => 'संपर्क';

  @override
  String get identity => 'नाम';

  @override
  String get places => 'जगहें';

  @override
  String get chooseMember => 'सदस्य चुनें';

  @override
  String get mapAttribution =>
      'नक्शा: चुना गया स्रोत। सरकारी परतें: NIC भारतमैप्स / ISRO भुवन।';

  @override
  String get downloadTreePdf => 'वंशवृक्ष डाउनलोड करें (PDF)';

  @override
  String get treePdfInfo =>
      'ऊपर-नीचे पाँच पीढ़ियाँ, भाई-बहन और पति-पत्नी सहित।';

  @override
  String get includePhotos => 'पासपोर्ट फ़ोटो भी डालें';

  @override
  String get generatingPdf => 'PDF बन रही है...';

  @override
  String get pdfReady => 'PDF तैयार है';

  @override
  String get generationsUp => 'ऊपर की पीढ़ियाँ';

  @override
  String get generationsDown => 'नीचे की पीढ़ियाँ';

  @override
  String get welcomeTitle => 'हमारे समाज के ऐप में आपका स्वागत है';

  @override
  String get chooseLanguage => 'आप कौन सी भाषा चाहेंगे?';

  @override
  String get continueLabel => 'आगे बढ़ें';

  @override
  String get greetingJayShreeKrishna => 'जय श्री कृष्ण 🙏';

  @override
  String get greetingJayMataji => 'जय माताजी 🙏';

  @override
  String get greetingRamRam => 'राम राम 🙏';

  @override
  String get greetingJayVishwakarma => 'जय विश्वकर्मा 🙏';

  @override
  String pdfGeneratedOn(String date) {
    return '$date को SocialTree से बनाया';
  }

  @override
  String treeOf(String name) {
    return '$name का वंशवृक्ष';
  }

  @override
  String pageOf(int page, int total) {
    return 'पृष्ठ $page / $total';
  }

  @override
  String get findMeTitle => 'क्या आप वृक्ष में पहले से हैं?';

  @override
  String get findMeIntro =>
      'हो सकता है किसी रिश्तेदार ने आपको पहले ही लिख दिया हो। आइए देखें।';

  @override
  String get yourFirstName => 'आपका नाम';

  @override
  String get yourLastName => 'आपका उपनाम';

  @override
  String get yourVillage => 'आपका मूल गाँव (चाहें तो)';

  @override
  String get yourBirthYear => 'जन्म का साल (चाहें तो)';

  @override
  String get yourMobile => 'आपका मोबाइल नंबर (चाहें तो)';

  @override
  String get searchForMe => 'मुझे खोजें';

  @override
  String get areYouThisPerson => 'क्या यह आप ही हैं?';

  @override
  String get yesThisIsMe => 'हाँ, यह मैं ही हूँ';

  @override
  String get noNotMe => 'नहीं, यह मैं नहीं हूँ';

  @override
  String get notInListAddMe => 'मैं सूची में नहीं हूँ, मुझे जोड़ें';

  @override
  String get doThisLater => 'मैं यह बाद में करूँगा';

  @override
  String get requestSent =>
      'हमने आपके परिवार से पुष्टि करने को कहा है। आपको यहाँ संदेश मिलेगा।';

  @override
  String get linkedNow => 'हो गया। अब यह रिकॉर्ड आपका है।';

  @override
  String parentsLabel(String names) {
    return 'माता-पिता: $names';
  }

  @override
  String get noCandidates => 'हम आपको नहीं ढूँढ पाए। आप खुद को जोड़ सकते हैं।';

  @override
  String get waitingForFamily =>
      'आपके परिवार की पुष्टि का इंतज़ार है कि यह आप ही हैं';

  @override
  String get cancelRequest => 'मेरा अनुरोध रद्द करें';

  @override
  String get unlinkMe => 'अब यह मेरा रिकॉर्ड नहीं है';

  @override
  String get inMemoryOf => 'श्रद्धांजलि';

  @override
  String passedAwayOn(String date) {
    return 'निधन: $date';
  }

  @override
  String lookedAfterBy(String name) {
    return 'इस रिकॉर्ड को $name संभालते हैं';
  }

  @override
  String get chooseCaretaker => 'चुनें कि इस रिकॉर्ड को कौन संभालेगा';

  @override
  String get claimsTitle => '\"यह मैं हूँ\" अनुरोध';

  @override
  String get pendingRequests => 'जवाब के इंतज़ार में';

  @override
  String get pastRequests => 'पहले जवाब दिए गए';

  @override
  String get confirmYes => 'हाँ, यह वही हैं';

  @override
  String get confirmNo => 'नहीं, यह वे नहीं हैं';

  @override
  String get noRequests => 'कोई अनुरोध नहीं।';

  @override
  String requestFrom(String name) {
    return '$name कहते हैं: यह मैं हूँ';
  }

  @override
  String get mergeIntoMine => 'यह भी मैं ही हूँ। मेरे रिकॉर्ड से जोड़ें';

  @override
  String yourRecordLinked(String name) {
    return 'आपका रिकॉर्ड: $name';
  }

  @override
  String get findMyselfAgain => 'वृक्ष में मेरा रिकॉर्ड खोजें';

  @override
  String get requestDecided => 'जवाब दिया';

  @override
  String get statusApproved => 'पुष्टि हुई';

  @override
  String get statusRejected => 'पुष्टि नहीं हुई';

  @override
  String get statusWithdrawn => 'रद्द हुआ';

  @override
  String get statusPending => 'इंतज़ार में';
}
