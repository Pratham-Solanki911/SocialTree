/// Plain data classes mirroring the Supabase tables. `fromMap` reads a row,
/// `toMap` produces the writable columns for insert/update.
library;

export 'tree_data.dart';

DateTime? parseDate(dynamic v) => DateTime.tryParse(v?.toString() ?? '');
String? dateOnly(DateTime? d) => d?.toIso8601String().substring(0, 10);
double? _num(dynamic v) => (v as num?)?.toDouble();

class Profile {
  Profile({
    required this.id,
    this.fullName,
    this.email,
    this.avatarUrl,
    required this.status,
    required this.isAdmin,
    required this.isSupport,
    this.locale,
    this.successorId,
    this.onboardingDone = false,
  });
  final String id;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final String status; // pending | approved | rejected | blocked
  final bool isAdmin;
  final bool isSupport;
  final String? locale; // en | gu | hi, null until chosen on first login
  final String? successorId;
  final bool onboardingDone;

  bool get isApproved => status == 'approved';
  bool get canSupport => isAdmin || isSupport;
  String get displayName => (fullName ?? email ?? id).trim();

  factory Profile.fromMap(Map<String, dynamic> m) => Profile(
        id: m['id'] as String,
        fullName: m['full_name'] as String?,
        email: m['email'] as String?,
        avatarUrl: m['avatar_url'] as String?,
        status: m['status'] as String? ?? 'pending',
        isAdmin: m['is_admin'] as bool? ?? false,
        isSupport: m['is_support'] as bool? ?? false,
        locale: m['locale'] as String?,
        successorId: m['successor_id'] as String?,
        onboardingDone: m['onboarding_done'] as bool? ?? false,
      );
}

class Family {
  Family({
    required this.id,
    required this.name,
    required this.surname,
    this.nativeVillage,
    this.gotraId,
    this.kuldevi,
    this.kuldevta,
    this.description,
    this.coverPath,
    this.createdBy,
  });
  final String id;
  final String name;
  final String surname;
  final String? nativeVillage;
  final String? gotraId;
  final String? kuldevi;
  final String? kuldevta;
  final String? description;
  final String? coverPath;
  final String? createdBy;

  factory Family.fromMap(Map<String, dynamic> m) => Family(
        id: m['id'] as String,
        name: m['name'] as String,
        surname: m['surname'] as String,
        nativeVillage: m['native_village'] as String?,
        gotraId: m['gotra_id'] as String?,
        kuldevi: m['kuldevi'] as String?,
        kuldevta: m['kuldevta'] as String?,
        description: m['description'] as String?,
        coverPath: m['cover_path'] as String?,
        createdBy: m['created_by'] as String?,
      );
}

class PhoneEntry {
  const PhoneEntry({required this.number, this.label = 'mobile', this.whatsapp = true});
  final String number; // E.164
  final String label;
  final bool whatsapp;

  factory PhoneEntry.fromMap(Map<String, dynamic> m) => PhoneEntry(
        number: m['number'] as String,
        label: m['label'] as String? ?? 'mobile',
        whatsapp: m['whatsapp'] as bool? ?? false,
      );
  Map<String, dynamic> toMap() => {'number': number, 'label': label, 'whatsapp': whatsapp};
}

class Person {
  Person({
    required this.id,
    required this.familyId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.maidenName,
    this.nickname,
    required this.gender,
    this.dob,
    this.dobIsApprox = false,
    this.dod,
    this.isAlive = true,
    this.birthPlace,
    this.birthLat,
    this.birthLng,
    this.currentPlace,
    this.currentLat,
    this.currentLng,
    this.nativeVillage,
    this.gotraId,
    this.kuldevi,
    this.kuldevta,
    this.phones = const [],
    this.email,
    this.occupation,
    this.education,
    this.maritalStatus,
    this.bloodGroup,
    this.biography,
    this.notes,
    this.passportPhotoPath,
    this.claimedBy,
    this.caretakerId,
    this.createdBy,
  });
  final String id;
  final String familyId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? maidenName;
  final String? nickname;
  final String gender; // male | female | other
  final DateTime? dob;
  final bool dobIsApprox;
  final DateTime? dod;
  final bool isAlive;
  final String? birthPlace;
  final double? birthLat;
  final double? birthLng;
  final String? currentPlace;
  final double? currentLat;
  final double? currentLng;
  final String? nativeVillage;
  final String? gotraId;
  final String? kuldevi;
  final String? kuldevta;
  final List<PhoneEntry> phones;
  final String? email;
  final String? occupation;
  final String? education;
  final String? maritalStatus;
  final String? bloodGroup;
  final String? biography;
  final String? notes;
  final String? passportPhotoPath;
  final String? claimedBy;
  final String? caretakerId;
  final String? createdBy;

  String get fullName => [firstName, middleName, lastName].where((s) => s != null && s.isNotEmpty).join(' ');
  String get shortName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  int? get birthYear => dob?.year;

  factory Person.fromMap(Map<String, dynamic> m) => Person(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        firstName: m['first_name'] as String,
        middleName: m['middle_name'] as String?,
        lastName: m['last_name'] as String,
        maidenName: m['maiden_name'] as String?,
        nickname: m['nickname'] as String?,
        gender: m['gender'] as String,
        dob: parseDate(m['dob']),
        dobIsApprox: m['dob_is_approx'] as bool? ?? false,
        dod: parseDate(m['dod']),
        isAlive: m['is_alive'] as bool? ?? true,
        birthPlace: m['birth_place'] as String?,
        birthLat: _num(m['birth_lat']),
        birthLng: _num(m['birth_lng']),
        currentPlace: m['current_place'] as String?,
        currentLat: _num(m['current_lat']),
        currentLng: _num(m['current_lng']),
        nativeVillage: m['native_village'] as String?,
        gotraId: m['gotra_id'] as String?,
        kuldevi: m['kuldevi'] as String?,
        kuldevta: m['kuldevta'] as String?,
        phones: ((m['phones'] as List?) ?? const [])
            .map((e) => PhoneEntry.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        email: m['email'] as String?,
        occupation: m['occupation'] as String?,
        education: m['education'] as String?,
        maritalStatus: m['marital_status'] as String?,
        bloodGroup: m['blood_group'] as String?,
        biography: m['biography'] as String?,
        notes: m['notes'] as String?,
        passportPhotoPath: m['passport_photo_path'] as String?,
        claimedBy: m['claimed_by'] as String?,
        caretakerId: m['caretaker_id'] as String?,
        createdBy: m['created_by'] as String?,
      );
}

class ClaimRequest {
  ClaimRequest({required this.id, required this.personId, required this.requesterId, required this.status, this.message, this.reason, this.decidedBy, this.decidedAt, required this.createdAt});
  final String id;
  final String personId;
  final String requesterId;
  final String status; // pending | approved | rejected | withdrawn
  final String? message;
  final String? reason;
  final String? decidedBy;
  final DateTime? decidedAt;
  final DateTime createdAt;

  factory ClaimRequest.fromMap(Map<String, dynamic> m) => ClaimRequest(
        id: m['id'] as String,
        personId: m['person_id'] as String,
        requesterId: m['requester_id'] as String,
        status: m['status'] as String,
        message: m['message'] as String?,
        reason: m['reason'] as String?,
        decidedBy: m['decided_by'] as String?,
        decidedAt: parseDate(m['decided_at']),
        createdAt: parseDate(m['created_at']) ?? DateTime.now(),
      );
}

/// A candidate from the guided "are you already in the tree?" search.
class SelfCandidate {
  SelfCandidate({required this.person, required this.score, this.parents});
  final Person person;
  final int score;
  final String? parents;
}

class Relationship {
  Relationship({required this.id, required this.kind, required this.personId, required this.relatedId, this.marriedOn, this.endedOn});
  final String id;
  final String kind; // parent | spouse
  final String personId; // parent, or spouse A
  final String relatedId; // child, or spouse B
  final DateTime? marriedOn;
  final DateTime? endedOn;

  factory Relationship.fromMap(Map<String, dynamic> m) => Relationship(
        id: m['id'] as String,
        kind: m['kind'] as String,
        personId: m['person_id'] as String,
        relatedId: m['related_id'] as String,
        marriedOn: parseDate(m['married_on']),
        endedOn: parseDate(m['ended_on']),
      );
}

class LifeEvent {
  LifeEvent({required this.id, required this.personId, required this.kind, required this.title, this.description, this.eventDate, this.dateIsApprox = false, this.place, this.lat, this.lng, this.createdAt});
  final String id;
  final String personId;
  final String kind;
  final String title;
  final String? description;
  final DateTime? eventDate;
  final bool dateIsApprox;
  final String? place;
  final double? lat;
  final double? lng;
  final DateTime? createdAt;

  factory LifeEvent.fromMap(Map<String, dynamic> m) => LifeEvent(
        id: m['id'] as String,
        personId: m['person_id'] as String,
        kind: m['kind'] as String,
        title: m['title'] as String,
        description: m['description'] as String?,
        eventDate: parseDate(m['event_date']),
        dateIsApprox: m['date_is_approx'] as bool? ?? false,
        place: m['place'] as String?,
        lat: _num(m['lat']),
        lng: _num(m['lng']),
        createdAt: parseDate(m['created_at']),
      );
}

/// Feed row: an event joined with its person.
class FeedItem {
  FeedItem({required this.event, required this.personName, required this.personId, this.photoPath});
  final LifeEvent event;
  final String personName;
  final String personId;
  final String? photoPath;
}

class Album {
  Album({required this.id, required this.title, this.description, this.familyId, this.personId, this.createdBy});
  final String id;
  final String title;
  final String? description;
  final String? familyId;
  final String? personId;
  final String? createdBy;

  factory Album.fromMap(Map<String, dynamic> m) => Album(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String?,
        familyId: m['family_id'] as String?,
        personId: m['person_id'] as String?,
        createdBy: m['created_by'] as String?,
      );
}

class MediaItem {
  MediaItem({required this.id, required this.kind, this.albumId, this.personId, this.storagePath, this.externalUrl, this.mimeType, this.sizeBytes, this.caption, this.uploadedBy});
  final String id;
  final String kind; // photo | video | document
  final String? albumId;
  final String? personId;
  final String? storagePath;
  final String? externalUrl;
  final String? mimeType;
  final int? sizeBytes;
  final String? caption;
  final String? uploadedBy;

  factory MediaItem.fromMap(Map<String, dynamic> m) => MediaItem(
        id: m['id'] as String,
        kind: m['kind'] as String,
        albumId: m['album_id'] as String?,
        personId: m['person_id'] as String?,
        storagePath: m['storage_path'] as String?,
        externalUrl: m['external_url'] as String?,
        mimeType: m['mime_type'] as String?,
        sizeBytes: m['size_bytes'] as int?,
        caption: m['caption'] as String?,
        uploadedBy: m['uploaded_by'] as String?,
      );
}

class Gotra {
  Gotra({required this.id, required this.name, this.kuldevi, this.kuldevta, this.notes, this.verified = false});
  final String id;
  final String name;
  final String? kuldevi;
  final String? kuldevta;
  final String? notes;
  final bool verified;

  factory Gotra.fromMap(Map<String, dynamic> m) => Gotra(
        id: m['id'] as String,
        name: m['name'] as String,
        kuldevi: m['kuldevi'] as String?,
        kuldevta: m['kuldevta'] as String?,
        notes: m['notes'] as String?,
        verified: m['verified'] as bool? ?? false,
      );
}

class SurnameGotra {
  SurnameGotra({required this.id, required this.surname, this.village, required this.gotraId, this.verified = false, this.gotra, this.createdBy});
  final String id;
  final String surname;
  final String? village;
  final String gotraId;
  final bool verified;
  final Gotra? gotra;
  final String? createdBy;

  factory SurnameGotra.fromMap(Map<String, dynamic> m) => SurnameGotra(
        id: m['id'] as String,
        surname: m['surname'] as String,
        village: m['village'] as String?,
        gotraId: m['gotra_id'] as String,
        verified: m['verified'] as bool? ?? false,
        createdBy: m['created_by'] as String?,
        gotra: m['gotras'] == null ? null : Gotra.fromMap(Map<String, dynamic>.from(m['gotras'] as Map)),
      );
}

class MatchSuggestion {
  MatchSuggestion({required this.id, required this.personId, required this.candidateId, required this.score, required this.reasons, required this.status});
  final String id;
  final String personId;
  final String candidateId;
  final int score;
  final List<String> reasons;
  final String status;

  factory MatchSuggestion.fromMap(Map<String, dynamic> m) => MatchSuggestion(
        id: m['id'] as String,
        personId: m['person_id'] as String,
        candidateId: m['candidate_id'] as String,
        score: m['score'] as int,
        reasons: ((m['reasons'] as List?) ?? const []).cast<String>(),
        status: m['status'] as String,
      );
}

class AppNotification {
  AppNotification({required this.id, required this.kind, required this.title, this.body, required this.data, this.readAt, required this.createdAt});
  final String id;
  final String kind;
  final String title;
  final String? body;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime createdAt;
  bool get isRead => readAt != null;

  factory AppNotification.fromMap(Map<String, dynamic> m) => AppNotification(
        id: m['id'] as String,
        kind: m['kind'] as String,
        title: m['title'] as String,
        body: m['body'] as String?,
        data: Map<String, dynamic>.from((m['data'] as Map?) ?? const {}),
        readAt: parseDate(m['read_at']),
        createdAt: parseDate(m['created_at']) ?? DateTime.now(),
      );
}

class ConversationSummary {
  ConversationSummary({required this.id, required this.otherUserId, required this.otherName, this.lastMessage, this.lastAt});
  final String id;
  final String otherUserId;
  final String otherName;
  final String? lastMessage;
  final DateTime? lastAt;
}

class Message {
  Message({required this.id, required this.conversationId, required this.senderId, required this.body, required this.createdAt});
  final String id;
  final String conversationId;
  final String senderId;
  final String body;
  final DateTime createdAt;

  factory Message.fromMap(Map<String, dynamic> m) => Message(
        id: m['id'] as String,
        conversationId: m['conversation_id'] as String,
        senderId: m['sender_id'] as String,
        body: m['body'] as String,
        createdAt: parseDate(m['created_at']) ?? DateTime.now(),
      );
}

class SupportTicket {
  SupportTicket({required this.id, required this.userId, required this.subject, required this.body, required this.priority, required this.status, required this.createdAt, this.userName});
  final String id;
  final String userId;
  final String subject;
  final String body;
  final String priority;
  final String status;
  final DateTime createdAt;
  final String? userName;

  factory SupportTicket.fromMap(Map<String, dynamic> m) => SupportTicket(
        id: m['id'] as String,
        userId: m['user_id'] as String,
        subject: m['subject'] as String,
        body: m['body'] as String,
        priority: m['priority'] as String,
        status: m['status'] as String,
        createdAt: parseDate(m['created_at']) ?? DateTime.now(),
        userName: (m['profiles'] as Map?)?['full_name'] as String?,
      );
}

class SupportMessage {
  SupportMessage({required this.id, required this.ticketId, required this.senderId, required this.body, required this.createdAt});
  final String id;
  final String ticketId;
  final String senderId;
  final String body;
  final DateTime createdAt;

  factory SupportMessage.fromMap(Map<String, dynamic> m) => SupportMessage(
        id: m['id'] as String,
        ticketId: m['ticket_id'] as String,
        senderId: m['sender_id'] as String,
        body: m['body'] as String,
        createdAt: parseDate(m['created_at']) ?? DateTime.now(),
      );
}

/// One hop of a person's movement for the migration map.
class MigrationHop {
  MigrationHop({required this.personId, required this.fullName, required this.seq, this.place, required this.lat, required this.lng, this.onDate});
  final String personId;
  final String fullName;
  final int seq;
  final String? place;
  final double lat;
  final double lng;
  final DateTime? onDate;

  factory MigrationHop.fromMap(Map<String, dynamic> m) => MigrationHop(
        personId: m['person_id'] as String,
        fullName: m['full_name'] as String,
        seq: m['seq'] as int,
        place: m['place'] as String?,
        lat: (m['lat'] as num).toDouble(),
        lng: (m['lng'] as num).toDouble(),
        onDate: parseDate(m['on_date']),
      );
}
