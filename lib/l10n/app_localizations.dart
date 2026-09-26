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
  /// **'Our families, our tree, our roots'**
  String get signInTagline;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Open with my Google account'**
  String get signInWithGoogle;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open: {message}'**
  String signInFailed(String message);

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait a little'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In en, this message translates to:
  /// **'A Samaj admin will let you in. This screen will change by itself.'**
  String get pendingBody;

  /// No description provided for @rejectedBody.
  ///
  /// In en, this message translates to:
  /// **'You were not let in. Please talk to a Samaj admin.'**
  String get rejectedBody;

  /// No description provided for @blockedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is stopped. Please talk to a Samaj admin.'**
  String get blockedBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Log out of the app'**
  String get signOut;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'App is not set up'**
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
  /// **'Find a person'**
  String get navSearch;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get navAccount;

  /// No description provided for @homeFeed.
  ///
  /// In en, this message translates to:
  /// **'News from the Samaj'**
  String get homeFeed;

  /// No description provided for @noUpdates.
  ///
  /// In en, this message translates to:
  /// **'No births, weddings or deaths have been written yet.'**
  String get noUpdates;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get quickActions;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My record'**
  String get myProfile;

  /// No description provided for @createMyProfile.
  ///
  /// In en, this message translates to:
  /// **'Add myself to the tree'**
  String get createMyProfile;

  /// No description provided for @addRelative.
  ///
  /// In en, this message translates to:
  /// **'Add a relative'**
  String get addRelative;

  /// No description provided for @viewTree.
  ///
  /// In en, this message translates to:
  /// **'See the family tree'**
  String get viewTree;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Same person written twice?'**
  String get matches;

  /// No description provided for @gotraLookup.
  ///
  /// In en, this message translates to:
  /// **'Gotra and Kuldevi'**
  String get gotraLookup;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Photo albums'**
  String get albums;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chat;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Ask for help'**
  String get support;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Messages for you'**
  String get notifications;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Samaj admin'**
  String get admin;

  /// No description provided for @familiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Families'**
  String get familiesTitle;

  /// No description provided for @newFamily.
  ///
  /// In en, this message translates to:
  /// **'Add a family'**
  String get newFamily;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Family name (for example: Solanki parivar, Morbi)'**
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
  /// **'A few words about it'**
  String get description;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'People in this family'**
  String get members;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nobody yet} =1{1 person} other{{count} people}}'**
  String memberCount(int count);

  /// No description provided for @noFamilies.
  ///
  /// In en, this message translates to:
  /// **'No family has been added yet. Add the first one.'**
  String get noFamilies;

  /// No description provided for @createFamily.
  ///
  /// In en, this message translates to:
  /// **'Add this family'**
  String get createFamily;

  /// No description provided for @familyTree.
  ///
  /// In en, this message translates to:
  /// **'Family tree'**
  String get familyTree;

  /// No description provided for @familyAlbum.
  ///
  /// In en, this message translates to:
  /// **'Family photos'**
  String get familyAlbum;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add a person'**
  String get addPerson;

  /// No description provided for @personDetails.
  ///
  /// In en, this message translates to:
  /// **'About this person'**
  String get personDetails;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s or husband\'s name'**
  String get middleName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get lastName;

  /// No description provided for @maidenName.
  ///
  /// In en, this message translates to:
  /// **'Surname before marriage'**
  String get maidenName;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Name used at home'**
  String get nickname;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Man or woman'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Woman'**
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
  /// **'Not sure, roughly'**
  String get approximate;

  /// No description provided for @dateOfDeath.
  ///
  /// In en, this message translates to:
  /// **'Date of passing'**
  String get dateOfDeath;

  /// No description provided for @deceased.
  ///
  /// In en, this message translates to:
  /// **'Has passed away'**
  String get deceased;

  /// No description provided for @alive.
  ///
  /// In en, this message translates to:
  /// **'Living'**
  String get alive;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Born in (place)'**
  String get birthPlace;

  /// No description provided for @currentPlace.
  ///
  /// In en, this message translates to:
  /// **'Lives in (place)'**
  String get currentPlace;

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Mark it on the map'**
  String get pickOnMap;

  /// No description provided for @locationSet.
  ///
  /// In en, this message translates to:
  /// **'Marked on the map'**
  String get locationSet;

  /// No description provided for @phones.
  ///
  /// In en, this message translates to:
  /// **'Mobile numbers'**
  String get phones;

  /// No description provided for @addPhone.
  ///
  /// In en, this message translates to:
  /// **'Add a mobile number'**
  String get addPhone;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get phoneNumber;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Which country'**
  String get countryCode;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Whose or which number (home, work, UK...)'**
  String get phoneLabel;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is on this number'**
  String get whatsapp;

  /// No description provided for @openWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Message on WhatsApp'**
  String get openWhatsApp;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Phone them'**
  String get call;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Type only the digits, 6 to 14 of them'**
  String get invalidPhone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get occupation;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Studies'**
  String get education;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Married or single'**
  String get maritalStatus;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get bloodGroup;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Life story'**
  String get biography;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Other notes'**
  String get notes;

  /// No description provided for @passportPhoto.
  ///
  /// In en, this message translates to:
  /// **'Passport photo'**
  String get passportPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo now'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick a photo from the phone'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove this photo'**
  String get removePhoto;

  /// No description provided for @photoCompressedTo.
  ///
  /// In en, this message translates to:
  /// **'Photo made smaller: {size}'**
  String photoCompressedTo(String size);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @savePerson.
  ///
  /// In en, this message translates to:
  /// **'Save this person'**
  String get savePerson;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Change details'**
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
  /// **'As per gotra: {value}'**
  String fromGotra(String value);

  /// No description provided for @fromFamily.
  ///
  /// In en, this message translates to:
  /// **'As per family: {value}'**
  String fromFamily(String value);

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Please fill this in'**
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
  /// **'Remove this? It cannot be brought back.'**
  String get confirmDelete;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get about;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Life events'**
  String get timeline;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Photos and files'**
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
  /// **'Husband / wife'**
  String get spouses;

  /// No description provided for @siblings.
  ///
  /// In en, this message translates to:
  /// **'Brothers and sisters'**
  String get siblings;

  /// No description provided for @addParent.
  ///
  /// In en, this message translates to:
  /// **'Add mother or father'**
  String get addParent;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add a son or daughter'**
  String get addChild;

  /// No description provided for @addSpouse.
  ///
  /// In en, this message translates to:
  /// **'Add husband or wife'**
  String get addSpouse;

  /// No description provided for @linkExisting.
  ///
  /// In en, this message translates to:
  /// **'They are already in the tree, pick them'**
  String get linkExisting;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Add them as a new person'**
  String get createNew;

  /// No description provided for @selectPerson.
  ///
  /// In en, this message translates to:
  /// **'Pick the person'**
  String get selectPerson;

  /// No description provided for @marriedOn.
  ///
  /// In en, this message translates to:
  /// **'Wedding date'**
  String get marriedOn;

  /// No description provided for @relationshipAdded.
  ///
  /// In en, this message translates to:
  /// **'Relation added'**
  String get relationshipAdded;

  /// No description provided for @removeRelationship.
  ///
  /// In en, this message translates to:
  /// **'Remove this relation'**
  String get removeRelationship;

  /// No description provided for @treeGraph.
  ///
  /// In en, this message translates to:
  /// **'Whole tree'**
  String get treeGraph;

  /// No description provided for @ancestors.
  ///
  /// In en, this message translates to:
  /// **'Elders before'**
  String get ancestors;

  /// No description provided for @descendants.
  ///
  /// In en, this message translates to:
  /// **'Children after'**
  String get descendants;

  /// No description provided for @generations.
  ///
  /// In en, this message translates to:
  /// **'Generations'**
  String get generations;

  /// No description provided for @noRelatives.
  ///
  /// In en, this message translates to:
  /// **'No relatives have been joined yet.'**
  String get noRelatives;

  /// No description provided for @lifeEvents.
  ///
  /// In en, this message translates to:
  /// **'Life events'**
  String get lifeEvents;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Write a life event'**
  String get addEvent;

  /// No description provided for @eventKind.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get eventKind;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'In short'**
  String get eventTitle;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get eventDate;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get place;

  /// No description provided for @kindBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth'**
  String get kindBirth;

  /// No description provided for @kindEducation.
  ///
  /// In en, this message translates to:
  /// **'Studies'**
  String get kindEducation;

  /// No description provided for @kindMigration.
  ///
  /// In en, this message translates to:
  /// **'Moved to a new place'**
  String get kindMigration;

  /// No description provided for @kindMarriage.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get kindMarriage;

  /// No description provided for @kindCareer.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get kindCareer;

  /// No description provided for @kindDeath.
  ///
  /// In en, this message translates to:
  /// **'Passing away'**
  String get kindDeath;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get kindOther;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'Nothing written yet.'**
  String get noEvents;

  /// No description provided for @migrationMap.
  ///
  /// In en, this message translates to:
  /// **'Where our people moved'**
  String get migrationMap;

  /// No description provided for @mapSource.
  ///
  /// In en, this message translates to:
  /// **'Map type'**
  String get mapSource;

  /// No description provided for @mapBharatmaps.
  ///
  /// In en, this message translates to:
  /// **'Bharatmaps (Government of India)'**
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
  /// **'This map is not opening. Try another map type.'**
  String get mapTilesFailed;

  /// No description provided for @allFamilies.
  ///
  /// In en, this message translates to:
  /// **'All families'**
  String get allFamilies;

  /// No description provided for @tapToPick.
  ///
  /// In en, this message translates to:
  /// **'Touch the map where the place is'**
  String get tapToPick;

  /// No description provided for @clearLocation.
  ///
  /// In en, this message translates to:
  /// **'Remove the mark'**
  String get clearLocation;

  /// No description provided for @noPaths.
  ///
  /// In en, this message translates to:
  /// **'No places written yet. Add where people were born and live now.'**
  String get noPaths;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Type a name, village or place'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'Nobody found'**
  String get noResults;

  /// No description provided for @onlyMyAncestors.
  ///
  /// In en, this message translates to:
  /// **'Only my elders'**
  String get onlyMyAncestors;

  /// No description provided for @findMatches.
  ///
  /// In en, this message translates to:
  /// **'Check for a double entry'**
  String get findMatches;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No double entries found.'**
  String get noMatches;

  /// No description provided for @possibleDuplicate.
  ///
  /// In en, this message translates to:
  /// **'These two may be the same person'**
  String get possibleDuplicate;

  /// No description provided for @matchScore.
  ///
  /// In en, this message translates to:
  /// **'{score}% alike'**
  String matchScore(int score);

  /// No description provided for @mergeInto.
  ///
  /// In en, this message translates to:
  /// **'Make them one (admin)'**
  String get mergeInto;

  /// No description provided for @keepWhich.
  ///
  /// In en, this message translates to:
  /// **'Which one should we keep?'**
  String get keepWhich;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'They are different people'**
  String get dismiss;

  /// No description provided for @matchesRefreshed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No double entries} =1{1 possible double entry} other{{count} possible double entries}}'**
  String matchesRefreshed(int count);

  /// No description provided for @lookupBySurname.
  ///
  /// In en, this message translates to:
  /// **'Type a surname'**
  String get lookupBySurname;

  /// No description provided for @addMapping.
  ///
  /// In en, this message translates to:
  /// **'Add surname and its gotra'**
  String get addMapping;

  /// No description provided for @addGotra.
  ///
  /// In en, this message translates to:
  /// **'Add a gotra'**
  String get addGotra;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Checked by the Samaj'**
  String get verified;

  /// No description provided for @unverified.
  ///
  /// In en, this message translates to:
  /// **'Not yet checked'**
  String get unverified;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @communityContributed.
  ///
  /// In en, this message translates to:
  /// **'Members write these. Ask your elders too; the Samaj marks the ones it has checked.'**
  String get communityContributed;

  /// No description provided for @markVerified.
  ///
  /// In en, this message translates to:
  /// **'Mark as checked'**
  String get markVerified;

  /// No description provided for @newAlbum.
  ///
  /// In en, this message translates to:
  /// **'Make a new album'**
  String get newAlbum;

  /// No description provided for @albumTitle.
  ///
  /// In en, this message translates to:
  /// **'Album name'**
  String get albumTitle;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get uploadPhoto;

  /// No description provided for @addVideoLink.
  ///
  /// In en, this message translates to:
  /// **'Add a video link (YouTube)'**
  String get addVideoLink;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Add a PDF file'**
  String get uploadDocument;

  /// No description provided for @videoUrl.
  ///
  /// In en, this message translates to:
  /// **'Paste the video link here'**
  String get videoUrl;

  /// No description provided for @caption.
  ///
  /// In en, this message translates to:
  /// **'What is this photo of'**
  String get caption;

  /// No description provided for @noMedia.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get noMedia;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is too big (more than 5 MB).'**
  String get fileTooLarge;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'I have read them all'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No messages for you.'**
  String get noNotifications;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'Message someone'**
  String get newChat;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Write your message'**
  String get messageHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'You have not messaged anyone yet.'**
  String get noConversations;

  /// No description provided for @newTicket.
  ///
  /// In en, this message translates to:
  /// **'Ask for help'**
  String get newTicket;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'What is it about'**
  String get subject;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get message;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'How urgent'**
  String get priority;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Where it stands'**
  String get status;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Not yet looked at'**
  String get statusOpen;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'Being looked at'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In en, this message translates to:
  /// **'Sorted out'**
  String get statusResolved;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityHigh;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get reply;

  /// No description provided for @noTickets.
  ///
  /// In en, this message translates to:
  /// **'You have not asked for help yet.'**
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
  /// **'Who keeps my record after me'**
  String get successor;

  /// No description provided for @successorInfo.
  ///
  /// In en, this message translates to:
  /// **'Choose a family member. After you, they can update your record.'**
  String get successorInfo;

  /// No description provided for @chooseSuccessor.
  ///
  /// In en, this message translates to:
  /// **'Choose a member'**
  String get chooseSuccessor;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get none;

  /// No description provided for @digitalAccount.
  ///
  /// In en, this message translates to:
  /// **'My record in the Samaj'**
  String get digitalAccount;

  /// No description provided for @pendingMembers.
  ///
  /// In en, this message translates to:
  /// **'People waiting to join'**
  String get pendingMembers;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Let them in'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Do not let in'**
  String get reject;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Stop this account'**
  String get block;

  /// No description provided for @allMembers.
  ///
  /// In en, this message translates to:
  /// **'All members'**
  String get allMembers;

  /// No description provided for @makeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make Samaj admin'**
  String get makeAdmin;

  /// No description provided for @removeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove as admin'**
  String get removeAdmin;

  /// No description provided for @supportAgent.
  ///
  /// In en, this message translates to:
  /// **'Answers help requests'**
  String get supportAgent;

  /// No description provided for @noPending.
  ///
  /// In en, this message translates to:
  /// **'Nobody is waiting.'**
  String get noPending;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
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
  /// **'Send to someone'**
  String get share;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Not known'**
  String get unknown;

  /// No description provided for @born.
  ///
  /// In en, this message translates to:
  /// **'born {date}'**
  String born(String date);

  /// No description provided for @died.
  ///
  /// In en, this message translates to:
  /// **'passed away {date}'**
  String died(String date);

  /// No description provided for @adminBadge.
  ///
  /// In en, this message translates to:
  /// **'Samaj admin'**
  String get adminBadge;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLink;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'PDF file'**
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
  /// **'Show {count} generations'**
  String generationsHint(int count);

  /// No description provided for @deletePerson.
  ///
  /// In en, this message translates to:
  /// **'Remove this person (admin)'**
  String get deletePerson;

  /// No description provided for @linkedToYou.
  ///
  /// In en, this message translates to:
  /// **'This is you'**
  String get linkedToYou;

  /// No description provided for @linkedToMember.
  ///
  /// In en, this message translates to:
  /// **'This person uses the app'**
  String get linkedToMember;

  /// No description provided for @selectFamily.
  ///
  /// In en, this message translates to:
  /// **'Which family'**
  String get selectFamily;

  /// No description provided for @chooseFamilyForSpouse.
  ///
  /// In en, this message translates to:
  /// **'Their family before marriage'**
  String get chooseFamilyForSpouse;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Added recently'**
  String get recentlyAdded;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nobody} =1{1 person} other{{count} people}}'**
  String peopleCount(int count);

  /// No description provided for @yourRecord.
  ///
  /// In en, this message translates to:
  /// **'Your record'**
  String get yourRecord;

  /// No description provided for @noProfileYet.
  ///
  /// In en, this message translates to:
  /// **'You are not joined to any record yet. Look for yourself in the tree, or add yourself.'**
  String get noProfileYet;

  /// No description provided for @relatives.
  ///
  /// In en, this message translates to:
  /// **'Relatives'**
  String get relatives;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'How to reach them'**
  String get contact;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get identity;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @chooseMember.
  ///
  /// In en, this message translates to:
  /// **'Choose a member'**
  String get chooseMember;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'Map: the chosen source. Government layers: NIC Bharatmaps / ISRO Bhuvan.'**
  String get mapAttribution;

  /// No description provided for @downloadTreePdf.
  ///
  /// In en, this message translates to:
  /// **'Download the family tree (PDF)'**
  String get downloadTreePdf;

  /// No description provided for @treePdfInfo.
  ///
  /// In en, this message translates to:
  /// **'Five generations above and below, with brothers, sisters, husbands and wives.'**
  String get treePdfInfo;

  /// No description provided for @includePhotos.
  ///
  /// In en, this message translates to:
  /// **'Put the passport photos in too'**
  String get includePhotos;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Making the PDF...'**
  String get generatingPdf;

  /// No description provided for @pdfReady.
  ///
  /// In en, this message translates to:
  /// **'The PDF is ready'**
  String get pdfReady;

  /// No description provided for @generationsUp.
  ///
  /// In en, this message translates to:
  /// **'Generations above'**
  String get generationsUp;

  /// No description provided for @generationsDown.
  ///
  /// In en, this message translates to:
  /// **'Generations below'**
  String get generationsDown;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our Samaj app'**
  String get welcomeTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Which language would you like?'**
  String get chooseLanguage;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Go ahead'**
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
  /// **'Made on {date} with SocialTree'**
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

  /// No description provided for @findMeTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you already in the tree?'**
  String get findMeTitle;

  /// No description provided for @findMeIntro.
  ///
  /// In en, this message translates to:
  /// **'A relative may have written you in already. Let us check.'**
  String get findMeIntro;

  /// No description provided for @yourFirstName.
  ///
  /// In en, this message translates to:
  /// **'Your first name'**
  String get yourFirstName;

  /// No description provided for @yourLastName.
  ///
  /// In en, this message translates to:
  /// **'Your surname'**
  String get yourLastName;

  /// No description provided for @yourVillage.
  ///
  /// In en, this message translates to:
  /// **'Your native village (if you like)'**
  String get yourVillage;

  /// No description provided for @yourBirthYear.
  ///
  /// In en, this message translates to:
  /// **'Year you were born (if you like)'**
  String get yourBirthYear;

  /// No description provided for @yourMobile.
  ///
  /// In en, this message translates to:
  /// **'Your mobile number (if you like)'**
  String get yourMobile;

  /// No description provided for @searchForMe.
  ///
  /// In en, this message translates to:
  /// **'Look for me'**
  String get searchForMe;

  /// No description provided for @areYouThisPerson.
  ///
  /// In en, this message translates to:
  /// **'Are you this person?'**
  String get areYouThisPerson;

  /// No description provided for @yesThisIsMe.
  ///
  /// In en, this message translates to:
  /// **'Yes, this is me'**
  String get yesThisIsMe;

  /// No description provided for @noNotMe.
  ///
  /// In en, this message translates to:
  /// **'No, this is not me'**
  String get noNotMe;

  /// No description provided for @notInListAddMe.
  ///
  /// In en, this message translates to:
  /// **'I am not in the list, add me'**
  String get notInListAddMe;

  /// No description provided for @doThisLater.
  ///
  /// In en, this message translates to:
  /// **'I will do this later'**
  String get doThisLater;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'We have asked your family to confirm. You will get a message here.'**
  String get requestSent;

  /// No description provided for @linkedNow.
  ///
  /// In en, this message translates to:
  /// **'Done. This record is now yours.'**
  String get linkedNow;

  /// No description provided for @parentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Parents: {names}'**
  String parentsLabel(String names);

  /// No description provided for @noCandidates.
  ///
  /// In en, this message translates to:
  /// **'We could not find you. You can add yourself.'**
  String get noCandidates;

  /// No description provided for @waitingForFamily.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your family to confirm that this is you'**
  String get waitingForFamily;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel my request'**
  String get cancelRequest;

  /// No description provided for @unlinkMe.
  ///
  /// In en, this message translates to:
  /// **'This is not my record any more'**
  String get unlinkMe;

  /// No description provided for @inMemoryOf.
  ///
  /// In en, this message translates to:
  /// **'In loving memory'**
  String get inMemoryOf;

  /// No description provided for @passedAwayOn.
  ///
  /// In en, this message translates to:
  /// **'Passed away on {date}'**
  String passedAwayOn(String date);

  /// No description provided for @lookedAfterBy.
  ///
  /// In en, this message translates to:
  /// **'This record is looked after by {name}'**
  String lookedAfterBy(String name);

  /// No description provided for @chooseCaretaker.
  ///
  /// In en, this message translates to:
  /// **'Choose who looks after this record'**
  String get chooseCaretaker;

  /// No description provided for @claimsTitle.
  ///
  /// In en, this message translates to:
  /// **'\"This is me\" requests'**
  String get claimsTitle;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Waiting for an answer'**
  String get pendingRequests;

  /// No description provided for @pastRequests.
  ///
  /// In en, this message translates to:
  /// **'Answered earlier'**
  String get pastRequests;

  /// No description provided for @confirmYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, it is them'**
  String get confirmYes;

  /// No description provided for @confirmNo.
  ///
  /// In en, this message translates to:
  /// **'No, it is not them'**
  String get confirmNo;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests.'**
  String get noRequests;

  /// No description provided for @requestFrom.
  ///
  /// In en, this message translates to:
  /// **'{name} says: this is me'**
  String requestFrom(String name);

  /// No description provided for @mergeIntoMine.
  ///
  /// In en, this message translates to:
  /// **'This is also me. Join it with my record'**
  String get mergeIntoMine;

  /// No description provided for @yourRecordLinked.
  ///
  /// In en, this message translates to:
  /// **'Your record: {name}'**
  String yourRecordLinked(String name);

  /// No description provided for @findMyselfAgain.
  ///
  /// In en, this message translates to:
  /// **'Look for my record in the tree'**
  String get findMyselfAgain;

  /// No description provided for @requestDecided.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get requestDecided;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed'**
  String get statusRejected;

  /// No description provided for @statusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusWithdrawn;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusPending;

  /// No description provided for @firstNameGu.
  ///
  /// In en, this message translates to:
  /// **'First name in Gujarati'**
  String get firstNameGu;

  /// No description provided for @firstNameEn.
  ///
  /// In en, this message translates to:
  /// **'First name in English'**
  String get firstNameEn;

  /// No description provided for @middleNameGu.
  ///
  /// In en, this message translates to:
  /// **'Father\'s or husband\'s name in Gujarati'**
  String get middleNameGu;

  /// No description provided for @middleNameEn.
  ///
  /// In en, this message translates to:
  /// **'Father\'s or husband\'s name in English'**
  String get middleNameEn;

  /// No description provided for @lastNameGu.
  ///
  /// In en, this message translates to:
  /// **'Surname in Gujarati'**
  String get lastNameGu;

  /// No description provided for @lastNameEn.
  ///
  /// In en, this message translates to:
  /// **'Surname in English'**
  String get lastNameEn;

  /// No description provided for @maidenNameGu.
  ///
  /// In en, this message translates to:
  /// **'Surname before marriage in Gujarati'**
  String get maidenNameGu;

  /// No description provided for @maidenNameEn.
  ///
  /// In en, this message translates to:
  /// **'Surname before marriage in English'**
  String get maidenNameEn;

  /// No description provided for @familyNameGu.
  ///
  /// In en, this message translates to:
  /// **'Family name in Gujarati'**
  String get familyNameGu;

  /// No description provided for @familyNameEn.
  ///
  /// In en, this message translates to:
  /// **'Family name in English'**
  String get familyNameEn;

  /// No description provided for @surnameGu.
  ///
  /// In en, this message translates to:
  /// **'Surname in Gujarati'**
  String get surnameGu;

  /// No description provided for @surnameEn.
  ///
  /// In en, this message translates to:
  /// **'Surname in English'**
  String get surnameEn;

  /// No description provided for @suggestedSpelling.
  ///
  /// In en, this message translates to:
  /// **'Filled in for you, please check'**
  String get suggestedSpelling;

  /// No description provided for @sonOf.
  ///
  /// In en, this message translates to:
  /// **'son of {name}'**
  String sonOf(String name);

  /// No description provided for @daughterOf.
  ///
  /// In en, this message translates to:
  /// **'daughter of {name}'**
  String daughterOf(String name);

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchByName;

  /// No description provided for @findInTree.
  ///
  /// In en, this message translates to:
  /// **'Find someone in this tree'**
  String get findInTree;

  /// No description provided for @filterMembers.
  ///
  /// In en, this message translates to:
  /// **'Search in this family'**
  String get filterMembers;

  /// No description provided for @fitToScreen.
  ///
  /// In en, this message translates to:
  /// **'See the whole tree'**
  String get fitToScreen;

  /// No description provided for @treeHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a person to see their family around them. Hold to open their page.'**
  String get treeHint;

  /// No description provided for @showAround.
  ///
  /// In en, this message translates to:
  /// **'Show family around {name}'**
  String showAround(String name);

  /// No description provided for @openPage.
  ///
  /// In en, this message translates to:
  /// **'Open their page'**
  String get openPage;

  /// No description provided for @otherFamilies.
  ///
  /// In en, this message translates to:
  /// **'Other families'**
  String get otherFamilies;

  /// No description provided for @largeText.
  ///
  /// In en, this message translates to:
  /// **'Bigger letters'**
  String get largeText;

  /// No description provided for @checkAllMatches.
  ///
  /// In en, this message translates to:
  /// **'Check the whole Samaj for double entries'**
  String get checkAllMatches;

  /// No description provided for @notifNewMember.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to join the Samaj'**
  String notifNewMember(String name);

  /// No description provided for @notifWelcome.
  ///
  /// In en, this message translates to:
  /// **'You are in. You can now build your family tree.'**
  String get notifWelcome;

  /// No description provided for @notifClaimRequest.
  ///
  /// In en, this message translates to:
  /// **'{name} says: this is me'**
  String notifClaimRequest(String name);

  /// No description provided for @notifClaimApproved.
  ///
  /// In en, this message translates to:
  /// **'The family confirmed that you are {name}'**
  String notifClaimApproved(String name);

  /// No description provided for @notifClaimRejected.
  ///
  /// In en, this message translates to:
  /// **'The family could not confirm that you are {name}'**
  String notifClaimRejected(String name);

  /// No description provided for @notifChat.
  ///
  /// In en, this message translates to:
  /// **'{name} sent you a message'**
  String notifChat(String name);

  /// No description provided for @notifMatch.
  ///
  /// In en, this message translates to:
  /// **'Two records may be the same person. Please have a look.'**
  String get notifMatch;

  /// No description provided for @notifSupportStatus.
  ///
  /// In en, this message translates to:
  /// **'Your help request: {status}'**
  String notifSupportStatus(String status);

  /// No description provided for @notifSupportReply.
  ///
  /// In en, this message translates to:
  /// **'Someone replied to your help request'**
  String get notifSupportReply;

  /// No description provided for @errAskAdminDeceased.
  ///
  /// In en, this message translates to:
  /// **'Only a Samaj admin can mark a member who uses the app as passed away. Please ask an admin.'**
  String get errAskAdminDeceased;

  /// No description provided for @errAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This record is already someone else\'s.'**
  String get errAlreadyLinked;

  /// No description provided for @errPassedAway.
  ///
  /// In en, this message translates to:
  /// **'This record is of someone who has passed away, so it cannot be yours.'**
  String get errPassedAway;

  /// No description provided for @errRequestWaiting.
  ///
  /// In en, this message translates to:
  /// **'You already have a request waiting for an answer.'**
  String get errRequestWaiting;

  /// No description provided for @errUnlinkFirst.
  ///
  /// In en, this message translates to:
  /// **'You are already joined to a record. Unlink it first from My account.'**
  String get errUnlinkFirst;

  /// No description provided for @errCycle.
  ///
  /// In en, this message translates to:
  /// **'That would make someone their own ancestor. Please check the relation.'**
  String get errCycle;

  /// No description provided for @errTwoParents.
  ///
  /// In en, this message translates to:
  /// **'A person can have only two parents here.'**
  String get errTwoParents;

  /// No description provided for @errNotApproved.
  ///
  /// In en, this message translates to:
  /// **'You have not been let in yet.'**
  String get errNotApproved;

  /// No description provided for @errAdminsOnly.
  ///
  /// In en, this message translates to:
  /// **'Only a Samaj admin can do this.'**
  String get errAdminsOnly;

  /// No description provided for @errBothMine.
  ///
  /// In en, this message translates to:
  /// **'Both records must be yours to join them.'**
  String get errBothMine;
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
