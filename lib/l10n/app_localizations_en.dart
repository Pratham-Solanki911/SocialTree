// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SocialTree';

  @override
  String get samajName => 'Shri Machhukathiya Sai Suthar Samaj';

  @override
  String get signInTagline => 'Our families, our tree, our roots';

  @override
  String get signInWithGoogle => 'Open with my Google account';

  @override
  String signInFailed(String message) {
    return 'Could not open: $message';
  }

  @override
  String get pendingTitle => 'Please wait a little';

  @override
  String get pendingBody =>
      'A Samaj admin will let you in. This screen will change by itself.';

  @override
  String get rejectedBody =>
      'You were not let in. Please talk to a Samaj admin.';

  @override
  String get blockedBody =>
      'Your account is stopped. Please talk to a Samaj admin.';

  @override
  String get signOut => 'Log out of the app';

  @override
  String get setupTitle => 'App is not set up';

  @override
  String get setupBody =>
      'Build with --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=... See README.md.';

  @override
  String get navHome => 'Home';

  @override
  String get navFamilies => 'Families';

  @override
  String get navSearch => 'Find a person';

  @override
  String get navMap => 'Map';

  @override
  String get navAccount => 'My account';

  @override
  String get homeFeed => 'News from the Samaj';

  @override
  String get noUpdates =>
      'No births, weddings or deaths have been written yet.';

  @override
  String get quickActions => 'What would you like to do?';

  @override
  String get myProfile => 'My record';

  @override
  String get createMyProfile => 'Add myself to the tree';

  @override
  String get addRelative => 'Add a relative';

  @override
  String get viewTree => 'See the family tree';

  @override
  String get matches => 'Same person written twice?';

  @override
  String get gotraLookup => 'Gotra and Kuldevi';

  @override
  String get albums => 'Photo albums';

  @override
  String get chat => 'Messages';

  @override
  String get support => 'Ask for help';

  @override
  String get notifications => 'Messages for you';

  @override
  String get admin => 'Samaj admin';

  @override
  String get familiesTitle => 'Families';

  @override
  String get newFamily => 'Add a family';

  @override
  String get familyName => 'Family name (for example: Solanki parivar, Morbi)';

  @override
  String get surname => 'Surname';

  @override
  String get nativeVillage => 'Native village';

  @override
  String get description => 'A few words about it';

  @override
  String get members => 'People in this family';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
      zero: 'Nobody yet',
    );
    return '$_temp0';
  }

  @override
  String get noFamilies => 'No family has been added yet. Add the first one.';

  @override
  String get createFamily => 'Add this family';

  @override
  String get familyTree => 'Family tree';

  @override
  String get familyAlbum => 'Family photos';

  @override
  String get addPerson => 'Add a person';

  @override
  String get personDetails => 'About this person';

  @override
  String get firstName => 'First name';

  @override
  String get middleName => 'Father\'s or husband\'s name';

  @override
  String get lastName => 'Surname';

  @override
  String get maidenName => 'Surname before marriage';

  @override
  String get nickname => 'Name used at home';

  @override
  String get gender => 'Man or woman';

  @override
  String get male => 'Man';

  @override
  String get female => 'Woman';

  @override
  String get other => 'Other';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get approximate => 'Not sure, roughly';

  @override
  String get dateOfDeath => 'Date of passing';

  @override
  String get deceased => 'Has passed away';

  @override
  String get alive => 'Living';

  @override
  String get birthPlace => 'Born in (place)';

  @override
  String get currentPlace => 'Lives in (place)';

  @override
  String get pickOnMap => 'Mark it on the map';

  @override
  String get locationSet => 'Marked on the map';

  @override
  String get phones => 'Mobile numbers';

  @override
  String get addPhone => 'Add a mobile number';

  @override
  String get phoneNumber => 'Number';

  @override
  String get countryCode => 'Which country';

  @override
  String get phoneLabel => 'Whose or which number (home, work, UK...)';

  @override
  String get whatsapp => 'WhatsApp is on this number';

  @override
  String get openWhatsApp => 'Message on WhatsApp';

  @override
  String get call => 'Phone them';

  @override
  String get invalidPhone => 'Type only the digits, 6 to 14 of them';

  @override
  String get email => 'Email';

  @override
  String get occupation => 'Work';

  @override
  String get education => 'Studies';

  @override
  String get maritalStatus => 'Married or single';

  @override
  String get bloodGroup => 'Blood group';

  @override
  String get biography => 'Life story';

  @override
  String get notes => 'Other notes';

  @override
  String get passportPhoto => 'Passport photo';

  @override
  String get takePhoto => 'Take a photo now';

  @override
  String get chooseFromGallery => 'Pick a photo from the phone';

  @override
  String get removePhoto => 'Remove this photo';

  @override
  String photoCompressedTo(String size) {
    return 'Photo made smaller: $size';
  }

  @override
  String get save => 'Save';

  @override
  String get savePerson => 'Save this person';

  @override
  String get cancel => 'Go back';

  @override
  String get delete => 'Remove';

  @override
  String get edit => 'Change details';

  @override
  String get gotra => 'Gotra';

  @override
  String get kuldevi => 'Kuldevi';

  @override
  String get kuldevta => 'Kuldevta';

  @override
  String fromGotra(String value) {
    return 'As per gotra: $value';
  }

  @override
  String fromFamily(String value) {
    return 'As per family: $value';
  }

  @override
  String get family => 'Family';

  @override
  String get requiredField => 'Please fill this in';

  @override
  String get saved => 'Saved';

  @override
  String errorWithMessage(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String get confirmDelete => 'Remove this? It cannot be brought back.';

  @override
  String get about => 'Details';

  @override
  String get timeline => 'Life events';

  @override
  String get media => 'Photos and files';

  @override
  String get parents => 'Parents';

  @override
  String get children => 'Children';

  @override
  String get spouses => 'Husband / wife';

  @override
  String get siblings => 'Brothers and sisters';

  @override
  String get addParent => 'Add mother or father';

  @override
  String get addChild => 'Add a son or daughter';

  @override
  String get addSpouse => 'Add husband or wife';

  @override
  String get linkExisting => 'They are already in the tree, pick them';

  @override
  String get createNew => 'Add them as a new person';

  @override
  String get selectPerson => 'Pick the person';

  @override
  String get marriedOn => 'Wedding date';

  @override
  String get relationshipAdded => 'Relation added';

  @override
  String get removeRelationship => 'Remove this relation';

  @override
  String get treeGraph => 'Whole tree';

  @override
  String get ancestors => 'Elders before';

  @override
  String get descendants => 'Children after';

  @override
  String get generations => 'Generations';

  @override
  String get noRelatives => 'No relatives have been joined yet.';

  @override
  String get lifeEvents => 'Life events';

  @override
  String get addEvent => 'Write a life event';

  @override
  String get eventKind => 'What happened';

  @override
  String get eventTitle => 'In short';

  @override
  String get eventDate => 'When';

  @override
  String get place => 'Where';

  @override
  String get kindBirth => 'Birth';

  @override
  String get kindEducation => 'Studies';

  @override
  String get kindMigration => 'Moved to a new place';

  @override
  String get kindMarriage => 'Wedding';

  @override
  String get kindCareer => 'Work';

  @override
  String get kindDeath => 'Passing away';

  @override
  String get kindOther => 'Something else';

  @override
  String get noEvents => 'Nothing written yet.';

  @override
  String get migrationMap => 'Where our people moved';

  @override
  String get mapSource => 'Map type';

  @override
  String get mapBharatmaps => 'Bharatmaps (Government of India)';

  @override
  String get mapBhuvan => 'Bhuvan (ISRO)';

  @override
  String get mapOsm => 'OpenStreetMap';

  @override
  String get mapTilesFailed => 'This map is not opening. Try another map type.';

  @override
  String get allFamilies => 'All families';

  @override
  String get tapToPick => 'Touch the map where the place is';

  @override
  String get clearLocation => 'Remove the mark';

  @override
  String get noPaths =>
      'No places written yet. Add where people were born and live now.';

  @override
  String get searchHint => 'Type a name, village or place';

  @override
  String get noResults => 'Nobody found';

  @override
  String get onlyMyAncestors => 'Only my elders';

  @override
  String get findMatches => 'Check for a double entry';

  @override
  String get noMatches => 'No double entries found.';

  @override
  String get possibleDuplicate => 'These two may be the same person';

  @override
  String matchScore(int score) {
    return '$score% alike';
  }

  @override
  String get mergeInto => 'Make them one (admin)';

  @override
  String get keepWhich => 'Which one should we keep?';

  @override
  String get dismiss => 'They are different people';

  @override
  String matchesRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count possible double entries',
      one: '1 possible double entry',
      zero: 'No double entries',
    );
    return '$_temp0';
  }

  @override
  String get lookupBySurname => 'Type a surname';

  @override
  String get addMapping => 'Add surname and its gotra';

  @override
  String get addGotra => 'Add a gotra';

  @override
  String get verified => 'Checked by the Samaj';

  @override
  String get unverified => 'Not yet checked';

  @override
  String get village => 'Village';

  @override
  String get communityContributed =>
      'Members write these. Ask your elders too; the Samaj marks the ones it has checked.';

  @override
  String get markVerified => 'Mark as checked';

  @override
  String get newAlbum => 'Make a new album';

  @override
  String get albumTitle => 'Album name';

  @override
  String get uploadPhoto => 'Add a photo';

  @override
  String get addVideoLink => 'Add a video link (YouTube)';

  @override
  String get uploadDocument => 'Add a PDF file';

  @override
  String get videoUrl => 'Paste the video link here';

  @override
  String get caption => 'What is this photo of';

  @override
  String get noMedia => 'Nothing here yet.';

  @override
  String get fileTooLarge => 'This file is too big (more than 5 MB).';

  @override
  String get markAllRead => 'I have read them all';

  @override
  String get noNotifications => 'No messages for you.';

  @override
  String get newChat => 'Message someone';

  @override
  String get messageHint => 'Write your message';

  @override
  String get send => 'Send';

  @override
  String get noConversations => 'You have not messaged anyone yet.';

  @override
  String get newTicket => 'Ask for help';

  @override
  String get subject => 'What is it about';

  @override
  String get message => 'Tell us more';

  @override
  String get priority => 'How urgent';

  @override
  String get status => 'Where it stands';

  @override
  String get statusOpen => 'Not yet looked at';

  @override
  String get statusInProgress => 'Being looked at';

  @override
  String get statusResolved => 'Sorted out';

  @override
  String get priorityHigh => 'Urgent';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get reply => 'Write a reply';

  @override
  String get noTickets => 'You have not asked for help yet.';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get successor => 'Who keeps my record after me';

  @override
  String get successorInfo =>
      'Choose a family member. After you, they can update your record.';

  @override
  String get chooseSuccessor => 'Choose a member';

  @override
  String get none => 'Nobody';

  @override
  String get digitalAccount => 'My record in the Samaj';

  @override
  String get pendingMembers => 'People waiting to join';

  @override
  String get approve => 'Let them in';

  @override
  String get reject => 'Do not let in';

  @override
  String get block => 'Stop this account';

  @override
  String get allMembers => 'All members';

  @override
  String get makeAdmin => 'Make Samaj admin';

  @override
  String get removeAdmin => 'Remove as admin';

  @override
  String get supportAgent => 'Answers help requests';

  @override
  String get noPending => 'Nobody is waiting.';

  @override
  String get loading => 'Please wait...';

  @override
  String get retry => 'Try again';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get share => 'Send to someone';

  @override
  String get done => 'Done';

  @override
  String get unknown => 'Not known';

  @override
  String born(String date) {
    return 'born $date';
  }

  @override
  String died(String date) {
    return 'passed away $date';
  }

  @override
  String get adminBadge => 'Samaj admin';

  @override
  String get you => 'You';

  @override
  String get openLink => 'Open';

  @override
  String get document => 'PDF file';

  @override
  String get video => 'Video';

  @override
  String get photo => 'Photo';

  @override
  String generationsHint(int count) {
    return 'Show $count generations';
  }

  @override
  String get deletePerson => 'Remove this person (admin)';

  @override
  String get linkedToYou => 'This is you';

  @override
  String get linkedToMember => 'This person uses the app';

  @override
  String get selectFamily => 'Which family';

  @override
  String get chooseFamilyForSpouse => 'Their family before marriage';

  @override
  String get recentlyAdded => 'Added recently';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
      zero: 'Nobody',
    );
    return '$_temp0';
  }

  @override
  String get yourRecord => 'Your record';

  @override
  String get noProfileYet =>
      'You are not joined to any record yet. Look for yourself in the tree, or add yourself.';

  @override
  String get relatives => 'Relatives';

  @override
  String get contact => 'How to reach them';

  @override
  String get identity => 'Name';

  @override
  String get places => 'Places';

  @override
  String get chooseMember => 'Choose a member';

  @override
  String get mapAttribution =>
      'Map: the chosen source. Government layers: NIC Bharatmaps / ISRO Bhuvan.';

  @override
  String get downloadTreePdf => 'Download the family tree (PDF)';

  @override
  String get treePdfInfo =>
      'Five generations above and below, with brothers, sisters, husbands and wives.';

  @override
  String get includePhotos => 'Put the passport photos in too';

  @override
  String get generatingPdf => 'Making the PDF...';

  @override
  String get pdfReady => 'The PDF is ready';

  @override
  String get generationsUp => 'Generations above';

  @override
  String get generationsDown => 'Generations below';

  @override
  String get welcomeTitle => 'Welcome to our Samaj app';

  @override
  String get chooseLanguage => 'Which language would you like?';

  @override
  String get continueLabel => 'Go ahead';

  @override
  String get greetingJayShreeKrishna => 'Jay Shree Krishna 🙏';

  @override
  String get greetingJayMataji => 'Jay Mataji 🙏';

  @override
  String get greetingRamRam => 'Ram Ram 🙏';

  @override
  String get greetingJayVishwakarma => 'Jay Vishwakarma 🙏';

  @override
  String pdfGeneratedOn(String date) {
    return 'Made on $date with SocialTree';
  }

  @override
  String treeOf(String name) {
    return 'Family tree of $name';
  }

  @override
  String pageOf(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String get findMeTitle => 'Are you already in the tree?';

  @override
  String get findMeIntro =>
      'A relative may have written you in already. Let us check.';

  @override
  String get yourFirstName => 'Your first name';

  @override
  String get yourLastName => 'Your surname';

  @override
  String get yourVillage => 'Your native village (if you like)';

  @override
  String get yourBirthYear => 'Year you were born (if you like)';

  @override
  String get yourMobile => 'Your mobile number (if you like)';

  @override
  String get searchForMe => 'Look for me';

  @override
  String get areYouThisPerson => 'Are you this person?';

  @override
  String get yesThisIsMe => 'Yes, this is me';

  @override
  String get noNotMe => 'No, this is not me';

  @override
  String get notInListAddMe => 'I am not in the list, add me';

  @override
  String get doThisLater => 'I will do this later';

  @override
  String get requestSent =>
      'We have asked your family to confirm. You will get a message here.';

  @override
  String get linkedNow => 'Done. This record is now yours.';

  @override
  String parentsLabel(String names) {
    return 'Parents: $names';
  }

  @override
  String get noCandidates => 'We could not find you. You can add yourself.';

  @override
  String get waitingForFamily =>
      'Waiting for your family to confirm that this is you';

  @override
  String get cancelRequest => 'Cancel my request';

  @override
  String get unlinkMe => 'This is not my record any more';

  @override
  String get inMemoryOf => 'In loving memory';

  @override
  String passedAwayOn(String date) {
    return 'Passed away on $date';
  }

  @override
  String lookedAfterBy(String name) {
    return 'This record is looked after by $name';
  }

  @override
  String get chooseCaretaker => 'Choose who looks after this record';

  @override
  String get claimsTitle => '\"This is me\" requests';

  @override
  String get pendingRequests => 'Waiting for an answer';

  @override
  String get pastRequests => 'Answered earlier';

  @override
  String get confirmYes => 'Yes, it is them';

  @override
  String get confirmNo => 'No, it is not them';

  @override
  String get noRequests => 'No requests.';

  @override
  String requestFrom(String name) {
    return '$name says: this is me';
  }

  @override
  String get mergeIntoMine => 'This is also me. Join it with my record';

  @override
  String yourRecordLinked(String name) {
    return 'Your record: $name';
  }

  @override
  String get findMyselfAgain => 'Look for my record in the tree';

  @override
  String get requestDecided => 'Answered';

  @override
  String get statusApproved => 'Confirmed';

  @override
  String get statusRejected => 'Not confirmed';

  @override
  String get statusWithdrawn => 'Cancelled';

  @override
  String get statusPending => 'Waiting';

  @override
  String get firstNameGu => 'First name in Gujarati';

  @override
  String get firstNameEn => 'First name in English';

  @override
  String get middleNameGu => 'Father\'s or husband\'s name in Gujarati';

  @override
  String get middleNameEn => 'Father\'s or husband\'s name in English';

  @override
  String get lastNameGu => 'Surname in Gujarati';

  @override
  String get lastNameEn => 'Surname in English';

  @override
  String get maidenNameGu => 'Surname before marriage in Gujarati';

  @override
  String get maidenNameEn => 'Surname before marriage in English';

  @override
  String get familyNameGu => 'Family name in Gujarati';

  @override
  String get familyNameEn => 'Family name in English';

  @override
  String get surnameGu => 'Surname in Gujarati';

  @override
  String get surnameEn => 'Surname in English';

  @override
  String get suggestedSpelling => 'Filled in for you, please check';

  @override
  String sonOf(String name) {
    return 'son of $name';
  }

  @override
  String daughterOf(String name) {
    return 'daughter of $name';
  }

  @override
  String get searchByName => 'Search by name';

  @override
  String get findInTree => 'Find someone in this tree';

  @override
  String get filterMembers => 'Search in this family';

  @override
  String get fitToScreen => 'See the whole tree';

  @override
  String get treeHint =>
      'Tap a person to see their family around them. Hold to open their page.';

  @override
  String showAround(String name) {
    return 'Show family around $name';
  }

  @override
  String get openPage => 'Open their page';

  @override
  String get otherFamilies => 'Other families';

  @override
  String get largeText => 'Bigger letters';

  @override
  String get checkAllMatches => 'Check the whole Samaj for double entries';

  @override
  String notifNewMember(String name) {
    return '$name wants to join the Samaj';
  }

  @override
  String get notifWelcome => 'You are in. You can now build your family tree.';

  @override
  String notifClaimRequest(String name) {
    return '$name says: this is me';
  }

  @override
  String notifClaimApproved(String name) {
    return 'The family confirmed that you are $name';
  }

  @override
  String notifClaimRejected(String name) {
    return 'The family could not confirm that you are $name';
  }

  @override
  String notifChat(String name) {
    return '$name sent you a message';
  }

  @override
  String get notifMatch =>
      'Two records may be the same person. Please have a look.';

  @override
  String notifSupportStatus(String status) {
    return 'Your help request: $status';
  }

  @override
  String get notifSupportReply => 'Someone replied to your help request';

  @override
  String get errAskAdminDeceased =>
      'Only a Samaj admin can mark a member who uses the app as passed away. Please ask an admin.';

  @override
  String get errAlreadyLinked => 'This record is already someone else\'s.';

  @override
  String get errPassedAway =>
      'This record is of someone who has passed away, so it cannot be yours.';

  @override
  String get errRequestWaiting =>
      'You already have a request waiting for an answer.';

  @override
  String get errUnlinkFirst =>
      'You are already joined to a record. Unlink it first from My account.';

  @override
  String get errCycle =>
      'That would make someone their own ancestor. Please check the relation.';

  @override
  String get errTwoParents => 'A person can have only two parents here.';

  @override
  String get errNotApproved => 'You have not been let in yet.';

  @override
  String get errAdminsOnly => 'Only a Samaj admin can do this.';

  @override
  String get errBothMine => 'Both records must be yours to join them.';
}
