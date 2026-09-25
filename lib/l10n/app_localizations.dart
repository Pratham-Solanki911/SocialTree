import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SocialTree'**
  String get appTitle;

  /// No description provided for @samajName.
  ///
  /// In en, this message translates to:
  /// **'Shri Machhukathiya Sai Suthar Samaj'**
  String get samajName;

  /// No description provided for @signInTagline.
  ///
  /// In en, this message translates to:
  /// **'Family trees, records and roots of our Samaj'**
  String get signInTagline;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {message}'**
  String signInFailed(String message);

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In en, this message translates to:
  /// **'A Samaj admin will approve your membership. This screen updates automatically.'**
  String get pendingBody;

  /// No description provided for @rejectedBody.
  ///
  /// In en, this message translates to:
  /// **'Your membership request was not approved. Contact a Samaj admin.'**
  String get rejectedBody;

  /// No description provided for @blockedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account has been blocked. Contact a Samaj admin.'**
  String get blockedBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'App not configured'**
  String get setupTitle;

  /// No description provided for @setupBody.
  ///
  /// In en, this message translates to:
  /// **'Build with --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=... See README.md.'**
  String get setupBody;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFamilies.
  ///
  /// In en, this message translates to:
  /// **'Families'**
  String get navFamilies;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @homeFeed.
  ///
  /// In en, this message translates to:
  /// **'Samaj updates'**
  String get homeFeed;

  /// No description provided for @noUpdates.
  ///
  /// In en, this message translates to:
  /// **'No births, marriages or deaths recorded yet.'**
  String get noUpdates;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @createMyProfile.
  ///
  /// In en, this message translates to:
  /// **'Create my profile'**
  String get createMyProfile;

  /// No description provided for @claimProfile.
  ///
  /// In en, this message translates to:
  /// **'This is me'**
  String get claimProfile;

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'Record linked to your account'**
  String get claimed;

  /// No description provided for @addRelative.
  ///
  /// In en, this message translates to:
  /// **'Add relative'**
  String get addRelative;

  /// No description provided for @viewTree.
  ///
  /// In en, this message translates to:
  /// **'View tree'**
  String get viewTree;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @gotraLookup.
  ///
  /// In en, this message translates to:
  /// **'Gotra & Kuldevi'**
  String get gotraLookup;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @familiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Families'**
  String get familiesTitle;

  /// No description provided for @newFamily.
  ///
  /// In en, this message translates to:
  /// **'New family'**
  String get newFamily;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get familyName;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @nativeVillage.
  ///
  /// In en, this message translates to:
  /// **'Native village'**
  String get nativeVillage;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No members} =1{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @noFamilies.
  ///
  /// In en, this message translates to:
  /// **'No families yet. Create the first one.'**
  String get noFamilies;

  /// No description provided for @createFamily.
  ///
  /// In en, this message translates to:
  /// **'Create family'**
  String get createFamily;

  /// No description provided for @familyTree.
  ///
  /// In en, this message translates to:
  /// **'Family tree'**
  String get familyTree;

  /// No description provided for @familyAlbum.
  ///
  /// In en, this message translates to:
  /// **'Family album'**
  String get familyAlbum;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add person'**
  String get addPerson;

  /// No description provided for @personDetails.
  ///
  /// In en, this message translates to:
  /// **'Person details'**
  String get personDetails;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle name (father\'s / husband\'s name)'**
  String get middleName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get lastName;

  /// No description provided for @maidenName.
  ///
  /// In en, this message translates to:
  /// **'Maiden surname'**
  String get maidenName;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @approximate.
  ///
  /// In en, this message translates to:
  /// **'Approximate'**
  String get approximate;

  /// No description provided for @dateOfDeath.
  ///
  /// In en, this message translates to:
  /// **'Date of death'**
  String get dateOfDeath;

  /// No description provided for @deceased.
  ///
  /// In en, this message translates to:
  /// **'Deceased'**
  String get deceased;

  /// No description provided for @alive.
  ///
  /// In en, this message translates to:
  /// **'Living'**
  String get alive;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth place'**
  String get birthPlace;

  /// No description provided for @currentPlace.
  ///
  /// In en, this message translates to:
  /// **'Current place'**
  String get currentPlace;

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get pickOnMap;

  /// No description provided for @locationSet.
  ///
  /// In en, this message translates to:
  /// **'Location set'**
  String get locationSet;

  /// No description provided for @phones.
  ///
  /// In en, this message translates to:
  /// **'Phone numbers'**
  String get phones;

  /// No description provided for @addPhone.
  ///
  /// In en, this message translates to:
  /// **'Add phone'**
  String get addPhone;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get phoneNumber;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryCode;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get phoneLabel;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @openWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp'**
  String get openWhatsApp;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter digits only, 6 to 14'**
  String get invalidPhone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital status'**
  String get maritalStatus;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get bloodGroup;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @passportPhoto.
  ///
  /// In en, this message translates to:
  /// **'Passport photo'**
  String get passportPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @photoCompressedTo.
  ///
  /// In en, this message translates to:
  /// **'Compressed to {size}'**
  String photoCompressedTo(String size);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @gotra.
  ///
  /// In en, this message translates to:
  /// **'Gotra'**
  String get gotra;

  /// No description provided for @kuldevi.
  ///
  /// In en, this message translates to:
  /// **'Kuldevi'**
  String get kuldevi;

  /// No description provided for @kuldevta.
  ///
  /// In en, this message translates to:
  /// **'Kuldevta'**
  String get kuldevta;

  /// No description provided for @fromGotra.
  ///
  /// In en, this message translates to:
  /// **'From gotra: {value}'**
  String fromGotra(String value);

  /// No description provided for @fromFamily.
  ///
  /// In en, this message translates to:
  /// **'From family: {value}'**
  String fromFamily(String value);

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this? This cannot be undone.'**
  String get confirmDelete;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @parents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get parents;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @spouses.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouses;

  /// No description provided for @siblings.
  ///
  /// In en, this message translates to:
  /// **'Siblings'**
  String get siblings;

  /// No description provided for @addParent.
  ///
  /// In en, this message translates to:
  /// **'Add parent'**
  String get addParent;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add child'**
  String get addChild;

  /// No description provided for @addSpouse.
  ///
  /// In en, this message translates to:
  /// **'Add spouse'**
  String get addSpouse;

  /// No description provided for @linkExisting.
  ///
  /// In en, this message translates to:
  /// **'Link an existing person'**
  String get linkExisting;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create a new person'**
  String get createNew;

  /// No description provided for @selectPerson.
  ///
  /// In en, this message translates to:
  /// **'Select person'**
  String get selectPerson;

  /// No description provided for @marriedOn.
  ///
  /// In en, this message translates to:
  /// **'Married on'**
  String get marriedOn;

  /// No description provided for @relationshipAdded.
  ///
  /// In en, this message translates to:
  /// **'Relationship added'**
  String get relationshipAdded;

  /// No description provided for @removeRelationship.
  ///
  /// In en, this message translates to:
  /// **'Remove relationship'**
  String get removeRelationship;

  /// No description provided for @treeGraph.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get treeGraph;

  /// No description provided for @ancestors.
  ///
  /// In en, this message translates to:
  /// **'Ancestors'**
  String get ancestors;

  /// No description provided for @descendants.
  ///
  /// In en, this message translates to:
  /// **'Descendants'**
  String get descendants;

  /// No description provided for @generations.
  ///
  /// In en, this message translates to:
  /// **'Generations'**
  String get generations;

  /// No description provided for @noRelatives.
  ///
  /// In en, this message translates to:
  /// **'No relatives linked yet.'**
  String get noRelatives;

  /// No description provided for @lifeEvents.
  ///
  /// In en, this message translates to:
  /// **'Life events'**
  String get lifeEvents;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get addEvent;

  /// No description provided for @eventKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get eventKind;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitle;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDate;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @kindBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth'**
  String get kindBirth;

  /// No description provided for @kindEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get kindEducation;

  /// No description provided for @kindMigration.
  ///
  /// In en, this message translates to:
  /// **'Migration'**
  String get kindMigration;

  /// No description provided for @kindMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get kindMarriage;

  /// No description provided for @kindCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get kindCareer;

  /// No description provided for @kindDeath.
  ///
  /// In en, this message translates to:
  /// **'Death'**
  String get kindDeath;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kindOther;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get noEvents;

  /// No description provided for @migrationMap.
  ///
  /// In en, this message translates to:
  /// **'Migration map'**
  String get migrationMap;

  /// No description provided for @mapSource.
  ///
  /// In en, this message translates to:
  /// **'Map source'**
  String get mapSource;

  /// No description provided for @mapBharatmaps.
  ///
  /// In en, this message translates to:
  /// **'Bharatmaps (Govt. of India)'**
  String get mapBharatmaps;

  /// No description provided for @mapBhuvan.
  ///
  /// In en, this message translates to:
  /// **'Bhuvan (ISRO)'**
  String get mapBhuvan;

  /// No description provided for @mapOsm.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap'**
  String get mapOsm;

  /// No description provided for @mapTilesFailed.
  ///
  /// In en, this message translates to:
  /// **'Tiles from this source are not loading. Try another map source.'**
  String get mapTilesFailed;

  /// No description provided for @allFamilies.
  ///
  /// In en, this message translates to:
  /// **'All families'**
  String get allFamilies;

  /// No description provided for @tapToPick.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to set the location'**
  String get tapToPick;

  /// No description provided for @clearLocation.
  ///
  /// In en, this message translates to:
  /// **'Clear location'**
  String get clearLocation;

  /// No description provided for @noPaths.
  ///
  /// In en, this message translates to:
  /// **'No places recorded yet. Add birth place, current place or migration events.'**
  String get noPaths;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, village or place'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @onlyMyAncestors.
  ///
  /// In en, this message translates to:
  /// **'Only my ancestors'**
  String get onlyMyAncestors;

  /// No description provided for @findMatches.
  ///
  /// In en, this message translates to:
  /// **'Find matches'**
  String get findMatches;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No possible duplicates found.'**
  String get noMatches;

  /// No description provided for @possibleDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate'**
  String get possibleDuplicate;

  /// No description provided for @matchScore.
  ///
  /// In en, this message translates to:
  /// **'{score}% match'**
  String matchScore(int score);

  /// No description provided for @mergeInto.
  ///
  /// In en, this message translates to:
  /// **'Merge (admin)'**
  String get mergeInto;

  /// No description provided for @keepWhich.
  ///
  /// In en, this message translates to:
  /// **'Which record should be kept?'**
  String get keepWhich;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @matchesRefreshed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No new matches} =1{1 match found} other{{count} matches found}}'**
  String matchesRefreshed(int count);

  /// No description provided for @lookupBySurname.
  ///
  /// In en, this message translates to:
  /// **'Look up by surname'**
  String get lookupBySurname;

  /// No description provided for @addMapping.
  ///
  /// In en, this message translates to:
  /// **'Add surname mapping'**
  String get addMapping;

  /// No description provided for @addGotra.
  ///
  /// In en, this message translates to:
  /// **'Add gotra'**
  String get addGotra;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @unverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get unverified;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @communityContributed.
  ///
  /// In en, this message translates to:
  /// **'Entries are added by members. Confirm with your elders; admins mark them verified.'**
  String get communityContributed;

  /// No description provided for @markVerified.
  ///
  /// In en, this message translates to:
  /// **'Mark verified'**
  String get markVerified;

  /// No description provided for @newAlbum.
  ///
  /// In en, this message translates to:
  /// **'New album'**
  String get newAlbum;

  /// No description provided for @albumTitle.
  ///
  /// In en, this message translates to:
  /// **'Album title'**
  String get albumTitle;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get uploadPhoto;

  /// No description provided for @addVideoLink.
  ///
  /// In en, this message translates to:
  /// **'Add video link'**
  String get addVideoLink;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document (PDF)'**
  String get uploadDocument;

  /// No description provided for @videoUrl.
  ///
  /// In en, this message translates to:
  /// **'Video URL (YouTube, Drive)'**
  String get videoUrl;

  /// No description provided for @caption.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get caption;

  /// No description provided for @noMedia.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get noMedia;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is larger than 5 MB.'**
  String get fileTooLarge;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications.'**
  String get noNotifications;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet.'**
  String get noConversations;

  /// No description provided for @newTicket.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
  String get newTicket;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get statusResolved;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @noTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets.'**
  String get noTickets;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી'**
  String get gujarati;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @successor.
  ///
  /// In en, this message translates to:
  /// **'Legacy contact'**
  String get successor;

  /// No description provided for @successorInfo.
  ///
  /// In en, this message translates to:
  /// **'This member can maintain your record after you have passed away.'**
  String get successorInfo;

  /// No description provided for @chooseSuccessor.
  ///
  /// In en, this message translates to:
  /// **'Choose member'**
  String get chooseSuccessor;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @digitalAccount.
  ///
  /// In en, this message translates to:
  /// **'Digital account'**
  String get digitalAccount;

  /// No description provided for @pendingMembers.
  ///
  /// In en, this message translates to:
  /// **'Pending members'**
  String get pendingMembers;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @allMembers.
  ///
  /// In en, this message translates to:
  /// **'All members'**
  String get allMembers;

  /// No description provided for @makeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make admin'**
  String get makeAdmin;

  /// No description provided for @removeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove admin'**
  String get removeAdmin;

  /// No description provided for @supportAgent.
  ///
  /// In en, this message translates to:
  /// **'Support agent'**
  String get supportAgent;

  /// No description provided for @noPending.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.'**
  String get noPending;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @born.
  ///
  /// In en, this message translates to:
  /// **'b. {date}'**
  String born(String date);

  /// No description provided for @died.
  ///
  /// In en, this message translates to:
  /// **'d. {date}'**
  String died(String date);

  /// No description provided for @adminBadge.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminBadge;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'Open link'**
  String get openLink;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @generationsHint.
  ///
  /// In en, this message translates to:
  /// **'Generations shown: {count}'**
  String generationsHint(int count);

  /// No description provided for @deletePerson.
  ///
  /// In en, this message translates to:
  /// **'Delete person (admin)'**
  String get deletePerson;

  /// No description provided for @linkedToYou.
  ///
  /// In en, this message translates to:
  /// **'Linked to your account'**
  String get linkedToYou;

  /// No description provided for @claimedBySomeone.
  ///
  /// In en, this message translates to:
  /// **'Linked to a member'**
  String get claimedBySomeone;

  /// No description provided for @selectFamily.
  ///
  /// In en, this message translates to:
  /// **'Select family'**
  String get selectFamily;

  /// No description provided for @chooseFamilyForSpouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse\'s family (birth family)'**
  String get chooseFamilyForSpouse;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get recentlyAdded;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No people} =1{1 person} other{{count} people}}'**
  String peopleCount(int count);

  /// No description provided for @yourRecord.
  ///
  /// In en, this message translates to:
  /// **'Your record'**
  String get yourRecord;

  /// No description provided for @noProfileYet.
  ///
  /// In en, this message translates to:
  /// **'You have not linked a person record yet. Create one or open your record in a family tree and tap \"This is me\".'**
  String get noProfileYet;

  /// No description provided for @relatives.
  ///
  /// In en, this message translates to:
  /// **'Relatives'**
  String get relatives;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @chooseMember.
  ///
  /// In en, this message translates to:
  /// **'Choose member'**
  String get chooseMember;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'Map data from the selected source. Government layers: NIC Bharatmaps / ISRO Bhuvan.'**
  String get mapAttribution;

  /// No description provided for @downloadTreePdf.
  ///
  /// In en, this message translates to:
  /// **'Download family tree (PDF)'**
  String get downloadTreePdf;

  /// No description provided for @treePdfInfo.
  ///
  /// In en, this message translates to:
  /// **'Five generations up and down from your record, with siblings and spouses.'**
  String get treePdfInfo;

  /// No description provided for @includePhotos.
  ///
  /// In en, this message translates to:
  /// **'Include passport photos'**
  String get includePhotos;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Preparing PDF...'**
  String get generatingPdf;

  /// No description provided for @pdfReady.
  ///
  /// In en, this message translates to:
  /// **'PDF ready'**
  String get pdfReady;

  /// No description provided for @generationsUp.
  ///
  /// In en, this message translates to:
  /// **'Generations up'**
  String get generationsUp;

  /// No description provided for @generationsDown.
  ///
  /// In en, this message translates to:
  /// **'Generations down'**
  String get generationsDown;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Samaj app'**
  String get welcomeTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @greetingJayShreeKrishna.
  ///
  /// In en, this message translates to:
  /// **'Jay Shree Krishna 🙏'**
  String get greetingJayShreeKrishna;

  /// No description provided for @greetingJayMataji.
  ///
  /// In en, this message translates to:
  /// **'Jay Mataji 🙏'**
  String get greetingJayMataji;

  /// No description provided for @greetingRamRam.
  ///
  /// In en, this message translates to:
  /// **'Ram Ram 🙏'**
  String get greetingRamRam;

  /// No description provided for @greetingJayVishwakarma.
  ///
  /// In en, this message translates to:
  /// **'Jay Vishwakarma 🙏'**
  String get greetingJayVishwakarma;

  /// No description provided for @pdfGeneratedOn.
  ///
  /// In en, this message translates to:
  /// **'Generated on {date} with SocialTree'**
  String pdfGeneratedOn(String date);

  /// No description provided for @treeOf.
  ///
  /// In en, this message translates to:
  /// **'Family tree of {name}'**
  String treeOf(String name);

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String pageOf(int page, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
