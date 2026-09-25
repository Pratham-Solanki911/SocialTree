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
  String get signInTagline => 'Family trees, records and roots of our Samaj';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String signInFailed(String message) {
    return 'Sign-in failed: $message';
  }

  @override
  String get pendingTitle => 'Awaiting approval';

  @override
  String get pendingBody =>
      'A Samaj admin will approve your membership. This screen updates automatically.';

  @override
  String get rejectedBody =>
      'Your membership request was not approved. Contact a Samaj admin.';

  @override
  String get blockedBody =>
      'Your account has been blocked. Contact a Samaj admin.';

  @override
  String get signOut => 'Sign out';

  @override
  String get setupTitle => 'App not configured';

  @override
  String get setupBody =>
      'Build with --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=... See README.md.';

  @override
  String get navHome => 'Home';

  @override
  String get navFamilies => 'Families';

  @override
  String get navSearch => 'Search';

  @override
  String get navMap => 'Map';

  @override
  String get navAccount => 'Account';

  @override
  String get homeFeed => 'Samaj updates';

  @override
  String get noUpdates => 'No births, marriages or deaths recorded yet.';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get myProfile => 'My profile';

  @override
  String get createMyProfile => 'Create my profile';

  @override
  String get claimProfile => 'This is me';

  @override
  String get claimed => 'Record linked to your account';

  @override
  String get addRelative => 'Add relative';

  @override
  String get viewTree => 'View tree';

  @override
  String get matches => 'Matches';

  @override
  String get gotraLookup => 'Gotra & Kuldevi';

  @override
  String get albums => 'Albums';

  @override
  String get chat => 'Chat';

  @override
  String get support => 'Support';

  @override
  String get notifications => 'Notifications';

  @override
  String get admin => 'Admin';

  @override
  String get familiesTitle => 'Families';

  @override
  String get newFamily => 'New family';

  @override
  String get familyName => 'Family name';

  @override
  String get surname => 'Surname';

  @override
  String get nativeVillage => 'Native village';

  @override
  String get description => 'Description';

  @override
  String get members => 'Members';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'No members',
    );
    return '$_temp0';
  }

  @override
  String get noFamilies => 'No families yet. Create the first one.';

  @override
  String get createFamily => 'Create family';

  @override
  String get familyTree => 'Family tree';

  @override
  String get familyAlbum => 'Family album';

  @override
  String get addPerson => 'Add person';

  @override
  String get personDetails => 'Person details';

  @override
  String get firstName => 'First name';

  @override
  String get middleName => 'Middle name (father\'s / husband\'s name)';

  @override
  String get lastName => 'Surname';

  @override
  String get maidenName => 'Maiden surname';

  @override
  String get nickname => 'Nickname';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get approximate => 'Approximate';

  @override
  String get dateOfDeath => 'Date of death';

  @override
  String get deceased => 'Deceased';

  @override
  String get alive => 'Living';

  @override
  String get birthPlace => 'Birth place';

  @override
  String get currentPlace => 'Current place';

  @override
  String get pickOnMap => 'Pick on map';

  @override
  String get locationSet => 'Location set';

  @override
  String get phones => 'Phone numbers';

  @override
  String get addPhone => 'Add phone';

  @override
  String get phoneNumber => 'Number';

  @override
  String get countryCode => 'Country';

  @override
  String get phoneLabel => 'Label';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get openWhatsApp => 'Open WhatsApp';

  @override
  String get call => 'Call';

  @override
  String get invalidPhone => 'Enter digits only, 6 to 14';

  @override
  String get email => 'Email';

  @override
  String get occupation => 'Occupation';

  @override
  String get education => 'Education';

  @override
  String get maritalStatus => 'Marital status';

  @override
  String get bloodGroup => 'Blood group';

  @override
  String get biography => 'Biography';

  @override
  String get notes => 'Notes';

  @override
  String get passportPhoto => 'Passport photo';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String photoCompressedTo(String size) {
    return 'Compressed to $size';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get gotra => 'Gotra';

  @override
  String get kuldevi => 'Kuldevi';

  @override
  String get kuldevta => 'Kuldevta';

  @override
  String fromGotra(String value) {
    return 'From gotra: $value';
  }

  @override
  String fromFamily(String value) {
    return 'From family: $value';
  }

  @override
  String get family => 'Family';

  @override
  String get requiredField => 'Required';

  @override
  String get saved => 'Saved';

  @override
  String errorWithMessage(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String get confirmDelete => 'Delete this? This cannot be undone.';

  @override
  String get about => 'About';

  @override
  String get timeline => 'Timeline';

  @override
  String get media => 'Media';

  @override
  String get parents => 'Parents';

  @override
  String get children => 'Children';

  @override
  String get spouses => 'Spouse';

  @override
  String get siblings => 'Siblings';

  @override
  String get addParent => 'Add parent';

  @override
  String get addChild => 'Add child';

  @override
  String get addSpouse => 'Add spouse';

  @override
  String get linkExisting => 'Link an existing person';

  @override
  String get createNew => 'Create a new person';

  @override
  String get selectPerson => 'Select person';

  @override
  String get marriedOn => 'Married on';

  @override
  String get relationshipAdded => 'Relationship added';

  @override
  String get removeRelationship => 'Remove relationship';

  @override
  String get treeGraph => 'Graph';

  @override
  String get ancestors => 'Ancestors';

  @override
  String get descendants => 'Descendants';

  @override
  String get generations => 'Generations';

  @override
  String get noRelatives => 'No relatives linked yet.';

  @override
  String get lifeEvents => 'Life events';

  @override
  String get addEvent => 'Add event';

  @override
  String get eventKind => 'Type';

  @override
  String get eventTitle => 'Title';

  @override
  String get eventDate => 'Date';

  @override
  String get place => 'Place';

  @override
  String get kindBirth => 'Birth';

  @override
  String get kindEducation => 'Education';

  @override
  String get kindMigration => 'Migration';

  @override
  String get kindMarriage => 'Marriage';

  @override
  String get kindCareer => 'Career';

  @override
  String get kindDeath => 'Death';

  @override
  String get kindOther => 'Other';

  @override
  String get noEvents => 'No events yet.';

  @override
  String get migrationMap => 'Migration map';

  @override
  String get mapSource => 'Map source';

  @override
  String get mapBharatmaps => 'Bharatmaps (Govt. of India)';

  @override
  String get mapBhuvan => 'Bhuvan (ISRO)';

  @override
  String get mapOsm => 'OpenStreetMap';

  @override
  String get mapTilesFailed =>
      'Tiles from this source are not loading. Try another map source.';

  @override
  String get allFamilies => 'All families';

  @override
  String get tapToPick => 'Tap the map to set the location';

  @override
  String get clearLocation => 'Clear location';

  @override
  String get noPaths =>
      'No places recorded yet. Add birth place, current place or migration events.';

  @override
  String get searchHint => 'Search by name, village or place';

  @override
  String get noResults => 'No results';

  @override
  String get onlyMyAncestors => 'Only my ancestors';

  @override
  String get findMatches => 'Find matches';

  @override
  String get noMatches => 'No possible duplicates found.';

  @override
  String get possibleDuplicate => 'Possible duplicate';

  @override
  String matchScore(int score) {
    return '$score% match';
  }

  @override
  String get mergeInto => 'Merge (admin)';

  @override
  String get keepWhich => 'Which record should be kept?';

  @override
  String get dismiss => 'Dismiss';

  @override
  String matchesRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches found',
      one: '1 match found',
      zero: 'No new matches',
    );
    return '$_temp0';
  }

  @override
  String get lookupBySurname => 'Look up by surname';

  @override
  String get addMapping => 'Add surname mapping';

  @override
  String get addGotra => 'Add gotra';

  @override
  String get verified => 'Verified';

  @override
  String get unverified => 'Unverified';

  @override
  String get village => 'Village';

  @override
  String get communityContributed =>
      'Entries are added by members. Confirm with your elders; admins mark them verified.';

  @override
  String get markVerified => 'Mark verified';

  @override
  String get newAlbum => 'New album';

  @override
  String get albumTitle => 'Album title';

  @override
  String get uploadPhoto => 'Upload photo';

  @override
  String get addVideoLink => 'Add video link';

  @override
  String get uploadDocument => 'Upload document (PDF)';

  @override
  String get videoUrl => 'Video URL (YouTube, Drive)';

  @override
  String get caption => 'Caption';

  @override
  String get noMedia => 'Nothing here yet.';

  @override
  String get premiumOnly => 'Premium plan feature';

  @override
  String get freePlanAlbumLimit => 'The free plan includes one album.';

  @override
  String get fileTooLarge => 'File is larger than 5 MB.';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications.';

  @override
  String get newChat => 'New chat';

  @override
  String get messageHint => 'Message';

  @override
  String get send => 'Send';

  @override
  String get noConversations => 'No conversations yet.';

  @override
  String get startChatPremium =>
      'Starting a chat needs the premium plan. Replying is free for everyone.';

  @override
  String get newTicket => 'New ticket';

  @override
  String get subject => 'Subject';

  @override
  String get message => 'Message';

  @override
  String get priority => 'Priority';

  @override
  String get status => 'Status';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get reply => 'Reply';

  @override
  String get noTickets => 'No tickets.';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get plan => 'Plan';

  @override
  String get planFree => 'Free';

  @override
  String get planPremium => 'Premium';

  @override
  String get planInfo =>
      'Plans are assigned by Samaj admins. There are no payments in the app.';

  @override
  String get successor => 'Legacy contact';

  @override
  String get successorInfo =>
      'This member can maintain your record after you have passed away.';

  @override
  String get chooseSuccessor => 'Choose member';

  @override
  String get none => 'None';

  @override
  String get exportData => 'Export my data (JSON)';

  @override
  String get exportDone => 'Export ready to share';

  @override
  String get digitalAccount => 'Digital account';

  @override
  String get pendingMembers => 'Pending members';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get block => 'Block';

  @override
  String get allMembers => 'All members';

  @override
  String get makeAdmin => 'Make admin';

  @override
  String get removeAdmin => 'Remove admin';

  @override
  String get supportAgent => 'Support agent';

  @override
  String get noPending => 'No pending requests.';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get share => 'Share';

  @override
  String get done => 'Done';

  @override
  String get unknown => 'Unknown';

  @override
  String born(String date) {
    return 'b. $date';
  }

  @override
  String died(String date) {
    return 'd. $date';
  }

  @override
  String get premiumBadge => 'Premium';

  @override
  String get adminBadge => 'Admin';

  @override
  String get you => 'You';

  @override
  String get openLink => 'Open link';

  @override
  String get document => 'Document';

  @override
  String get video => 'Video';

  @override
  String get photo => 'Photo';

  @override
  String generationsHint(int count) {
    return 'Generations shown: $count';
  }

  @override
  String get deletePerson => 'Delete person (admin)';

  @override
  String get linkedToYou => 'Linked to your account';

  @override
  String get claimedBySomeone => 'Linked to a member';

  @override
  String get selectFamily => 'Select family';

  @override
  String get chooseFamilyForSpouse => 'Spouse\'s family (birth family)';

  @override
  String get recentlyAdded => 'Recently added';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
      zero: 'No people',
    );
    return '$_temp0';
  }

  @override
  String get yourRecord => 'Your record';

  @override
  String get noProfileYet =>
      'You have not linked a person record yet. Create one or open your record in a family tree and tap \"This is me\".';

  @override
  String get relatives => 'Relatives';

  @override
  String get contact => 'Contact';

  @override
  String get identity => 'Identity';

  @override
  String get places => 'Places';

  @override
  String get chooseMember => 'Choose member';

  @override
  String get mapAttribution =>
      'Map data from the selected source. Government layers: NIC Bharatmaps / ISRO Bhuvan.';
}
