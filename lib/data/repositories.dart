import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Thin wrappers over the Supabase client. Security lives in the database
/// (RLS + security-definer functions); these only shape queries.
class Repos {
  Repos(this.db);
  final SupabaseClient db;

  String get uid => db.auth.currentUser!.id;
  StorageFileApi get bucket => db.storage.from('media');

  // ---------------------------------------------------------------- profiles
  Future<void> updateMyProfile(Map<String, dynamic> patch) =>
      db.from('profiles').update(patch).eq('id', uid);

  Future<List<Profile>> approvedProfiles() async {
    final rows = await db.from('profiles').select().eq('status', 'approved').order('full_name');
    return rows.map(Profile.fromMap).toList();
  }

  Future<List<Profile>> allProfiles() async {
    final rows = await db.from('profiles').select().order('created_at', ascending: false);
    return rows.map(Profile.fromMap).toList();
  }

  Future<void> adminPatchProfile(String id, Map<String, dynamic> patch) =>
      db.from('profiles').update(patch).eq('id', id);

  /// Persons (with `gen`, `gotra_name`, `family_name`) and edges for the PDF.
  Future<Map<String, dynamic>> treePdfData(String root, {int up = 5, int down = 5}) async =>
      Map<String, dynamic>.from(await db.rpc('get_tree_pdf_data', params: {'root': root, 'up': up, 'down': down}) as Map);

  // ---------------------------------------------------------------- families
  Future<List<Family>> families() async {
    final rows = await db.from('families').select().order('name');
    return rows.map(Family.fromMap).toList();
  }

  Future<Family> family(String id) async =>
      Family.fromMap(await db.from('families').select().eq('id', id).single());

  Future<Family> createFamily(Map<String, dynamic> m) async =>
      Family.fromMap(await db.from('families').insert(m).select().single());

  Future<void> updateFamily(String id, Map<String, dynamic> m) =>
      db.from('families').update(m).eq('id', id);

  Future<List<Person>> familyMembers(String familyId) async {
    final rows = await db.from('persons').select().eq('family_id', familyId).order('last_name').order('first_name');
    return rows.map(Person.fromMap).toList();
  }

  Future<Map<String, int>> familyMemberCounts() async {
    final rows = await db.from('persons').select('family_id');
    final out = <String, int>{};
    for (final r in rows) {
      out.update(r['family_id'] as String, (v) => v + 1, ifAbsent: () => 1);
    }
    return out;
  }

  // ----------------------------------------------------------------- persons
  Future<Person> person(String id) async =>
      Person.fromMap(await db.from('persons').select().eq('id', id).single());

  Future<Person?> myPerson() async {
    final row = await db.from('persons').select().eq('claimed_by', uid).maybeSingle();
    return row == null ? null : Person.fromMap(row);
  }

  Future<Person> createPerson(Map<String, dynamic> m) async =>
      Person.fromMap(await db.from('persons').insert(m).select().single());

  Future<void> updatePerson(String id, Map<String, dynamic> m) =>
      db.from('persons').update(m).eq('id', id);

  Future<void> deletePerson(String id) => db.from('persons').delete().eq('id', id);

  // ---------------------------------------------------------- identity
  Future<List<SelfCandidate>> findMyself({required String firstName, required String lastName, String? village, int? birthYear, String? phone}) async {
    final rows = await db.rpc('find_myself', params: {'first_name': firstName, 'last_name': lastName, 'village': village, 'birth_year': birthYear, 'phone': phone}) as List;
    if (rows.isEmpty) return const [];
    final persons = {for (final p in await personsByIds(rows.map((r) => (r as Map)['person_id'] as String))) p.id: p};
    return [
      for (final r in rows.cast<Map>())
        if (persons[r['person_id']] != null)
          SelfCandidate(person: persons[r['person_id']]!, score: (r['score'] as num).toInt(), parents: r['parents'] as String?),
    ];
  }

  /// Returns 'approved' or 'pending'.
  Future<String> requestClaim(String personId, {String? message}) async =>
      await db.rpc('request_claim', params: {'p': personId, 'message': message}) as String;

  Future<void> decideClaim(String requestId, bool approve, {String? reason}) =>
      db.rpc('decide_claim', params: {'request': requestId, 'approve': approve, 'reason': reason});
  Future<void> withdrawClaim(String requestId) => db.rpc('withdraw_claim', params: {'request': requestId});
  Future<void> releaseClaim() => db.rpc('release_claim');
  Future<void> transferClaim(String personId, String profileId) => db.rpc('transfer_claim', params: {'p': personId, 'who': profileId});
  Future<void> mergeMyRecords(String keep, String drop) => db.rpc('merge_my_records', params: {'keep_id': keep, 'drop_id': drop});
  Future<void> setCaretaker(String personId, String? profileId) => db.rpc('set_caretaker', params: {'p': personId, 'who': profileId});

  Future<List<ClaimRequest>> claimRequests() async {
    final rows = await db.from('claim_requests').select().order('created_at', ascending: false);
    return rows.map(ClaimRequest.fromMap).toList();
  }

  Future<List<Person>> myCreatedUnlinked() async {
    final rows = await db.from('persons').select().eq('created_by', uid).isFilter('claimed_by', null).eq('is_alive', true);
    return rows.map(Person.fromMap).toList();
  }

  Future<List<Person>> search(String q) async {
    if (q.trim().isEmpty) return const [];
    final rows = await db.rpc('search_persons', params: {'q': q, 'lim': 80}) as List;
    return rows.map((e) => Person.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<Person>> recentPersons({int limit = 20}) async {
    final rows = await db.from('persons').select().order('created_at', ascending: false).limit(limit);
    return rows.map(Person.fromMap).toList();
  }

  Future<List<Person>> personsByIds(Iterable<String> ids) async {
    if (ids.isEmpty) return const [];
    final rows = await db.from('persons').select().inFilter('id', ids.toList());
    return rows.map(Person.fromMap).toList();
  }

  /// Stores the compressed passport JPEG and records its path on the person.
  Future<String> uploadPassport(String personId, Uint8List jpeg, {String? oldPath}) async {
    // New path per upload: signed URLs and CDN caches never serve the old photo.
    final path = 'passport/$personId-${DateTime.now().millisecondsSinceEpoch}.jpg';
    await bucket.uploadBinary(path, jpeg, fileOptions: const FileOptions(contentType: 'image/jpeg'));
    await updatePerson(personId, {'passport_photo_path': path});
    if (oldPath != null && oldPath != path) {
      try {
        await bucket.remove([oldPath]);
      } catch (_) {/* old file may already be gone */}
    }
    return path;
  }

  Future<void> removePassport(String personId, String path) async {
    await bucket.remove([path]);
    await updatePerson(personId, {'passport_photo_path': null});
  }

  // -------------------------------------------------------------------- tree
  Future<TreeData> tree(String root, int hops) async {
    final json = await db.rpc('get_tree', params: {'root': root, 'max_hops': hops});
    return TreeData.fromJson(Map<String, dynamic>.from(json as Map));
  }

  Future<Set<String>> ancestorIds(String root) async {
    final rows = await db.rpc('get_ancestors', params: {'root': root, 'max_depth': 20}) as List;
    return rows.map((e) => (e as Map)['person_id'] as String).toSet();
  }

  Future<void> addRelationship({required String kind, required String personId, required String relatedId, DateTime? marriedOn}) =>
      db.from('relationships').insert({
        'kind': kind,
        'person_id': personId,
        'related_id': relatedId,
        if (marriedOn != null) 'married_on': dateOnly(marriedOn),
      });

  Future<void> removeRelationship(String id) => db.from('relationships').delete().eq('id', id);

  Future<List<MigrationHop>> migrationPaths(String? familyId) async {
    final rows = await db.rpc('migration_paths', params: {'family': familyId}) as List;
    return rows.map((e) => MigrationHop.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  // ------------------------------------------------------------------ events
  Future<List<LifeEvent>> events(String personId) async {
    final rows = await db.from('life_events').select().eq('person_id', personId).order('event_date', ascending: true, nullsFirst: false);
    return rows.map(LifeEvent.fromMap).toList();
  }

  Future<void> addEvent(Map<String, dynamic> m) => db.from('life_events').insert(m);
  Future<void> deleteEvent(String id) => db.from('life_events').delete().eq('id', id);

  Future<List<FeedItem>> feed({int limit = 50}) async {
    final rows = await db
        .from('life_events')
        .select('*, persons(id, first_name, last_name, passport_photo_path)')
        .inFilter('kind', ['birth', 'marriage', 'death'])
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map((r) {
      final p = Map<String, dynamic>.from(r['persons'] as Map);
      return FeedItem(
        event: LifeEvent.fromMap(r),
        personId: p['id'] as String,
        personName: '${p['first_name']} ${p['last_name']}',
        photoPath: p['passport_photo_path'] as String?,
      );
    }).toList();
  }

  // ------------------------------------------------------------------- media
  Future<List<Album>> albums() async {
    final rows = await db.from('albums').select().order('created_at', ascending: false);
    return rows.map(Album.fromMap).toList();
  }

  Future<Album> album(String id) async => Album.fromMap(await db.from('albums').select().eq('id', id).single());

  Future<Album> createAlbum(Map<String, dynamic> m) async =>
      Album.fromMap(await db.from('albums').insert(m).select().single());

  Future<List<MediaItem>> albumMedia(String albumId) async {
    final rows = await db.from('media').select().eq('album_id', albumId).order('created_at', ascending: false);
    return rows.map(MediaItem.fromMap).toList();
  }

  Future<List<MediaItem>> personMedia(String personId) async {
    final rows = await db.from('media').select().eq('person_id', personId).order('created_at', ascending: false);
    return rows.map(MediaItem.fromMap).toList();
  }

  Future<void> uploadPhoto({String? albumId, String? personId, required Uint8List jpeg, String? caption}) async {
    final folder = albumId != null ? 'albums/$albumId' : 'persons/$personId';
    final path = '$folder/${DateTime.now().microsecondsSinceEpoch}.jpg';
    await bucket.uploadBinary(path, jpeg, fileOptions: const FileOptions(contentType: 'image/jpeg'));
    await db.from('media').insert({
      'kind': 'photo',
      'album_id': albumId,
      'person_id': personId,
      'storage_path': path,
      'mime_type': 'image/jpeg',
      'size_bytes': jpeg.length,
      'caption': caption,
    });
  }

  Future<void> uploadDocument({String? albumId, String? personId, required Uint8List bytes, required String filename, required String mimeType, String? caption}) async {
    final folder = albumId != null ? 'albums/$albumId' : 'persons/$personId';
    final safe = filename.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final path = '$folder/${DateTime.now().microsecondsSinceEpoch}_$safe';
    await bucket.uploadBinary(path, bytes, fileOptions: FileOptions(contentType: mimeType));
    await db.from('media').insert({
      'kind': 'document',
      'album_id': albumId,
      'person_id': personId,
      'storage_path': path,
      'mime_type': mimeType,
      'size_bytes': bytes.length,
      'caption': caption ?? filename,
    });
  }

  Future<void> addVideoLink({String? albumId, String? personId, required String url, String? caption}) =>
      db.from('media').insert({
        'kind': 'video',
        'album_id': albumId,
        'person_id': personId,
        'external_url': url,
        'caption': caption,
      });

  Future<void> deleteMedia(MediaItem m) async {
    if (m.storagePath != null) await bucket.remove([m.storagePath!]);
    await db.from('media').delete().eq('id', m.id);
  }

  Future<String> signedUrl(String path) => bucket.createSignedUrl(path, 3600);

  // ------------------------------------------------------------------- gotra
  Future<List<Gotra>> gotras() async {
    final rows = await db.from('gotras').select().order('name');
    return rows.map(Gotra.fromMap).toList();
  }

  Future<List<SurnameGotra>> lookupSurname(String surname) async {
    final rows = await db.from('surname_gotras').select('*, gotras(*)').ilike('surname', '%${surname.trim()}%').order('surname');
    return rows.map(SurnameGotra.fromMap).toList();
  }

  Future<void> saveGotra(String? id, Map<String, dynamic> m) =>
      id == null ? db.from('gotras').insert(m) : db.from('gotras').update(m).eq('id', id);

  Future<void> addSurnameMapping(Map<String, dynamic> m) => db.from('surname_gotras').insert(m);
  Future<void> patchSurnameMapping(String id, Map<String, dynamic> m) => db.from('surname_gotras').update(m).eq('id', id);
  Future<void> deleteSurnameMapping(String id) => db.from('surname_gotras').delete().eq('id', id);

  // ----------------------------------------------------------------- matches
  Future<int> refreshAllMatches() async => (await db.rpc('refresh_all_matches') as num).toInt();

  Future<int> refreshMatches(String personId) async =>
      (await db.rpc('refresh_matches', params: {'p': personId}) as num).toInt();

  Future<List<MatchSuggestion>> pendingMatches() async {
    final rows = await db.from('match_suggestions').select().eq('status', 'pending').order('score', ascending: false);
    return rows.map(MatchSuggestion.fromMap).toList();
  }

  Future<void> dismissMatch(String id) => db.from('match_suggestions').update({
        'status': 'dismissed',
        'decided_by': uid,
        'decided_at': DateTime.now().toIso8601String(),
      }).eq('id', id);

  Future<void> mergePersons(String keep, String drop) =>
      db.rpc('merge_persons', params: {'keep_id': keep, 'drop_id': drop});

  // ----------------------------------------------------------- notifications
  Stream<List<AppNotification>> notifications() => db
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', uid)
      .order('created_at', ascending: false)
      .limit(200)
      .map((rows) => rows.map(AppNotification.fromMap).toList());

  Future<void> markRead(String id) =>
      db.from('notifications').update({'read_at': DateTime.now().toIso8601String()}).eq('id', id);

  Future<void> markAllRead() => db
      .from('notifications')
      .update({'read_at': DateTime.now().toIso8601String()})
      .eq('user_id', uid)
      .isFilter('read_at', null);

  // -------------------------------------------------------------------- chat
  Future<List<ConversationSummary>> conversations() async {
    final rows = await db
        .from('conversations')
        .select('id, conversation_participants(user_id, profiles(full_name, email)), messages(body, created_at)')
        .order('created_at', referencedTable: 'messages', ascending: false)
        .limit(1, referencedTable: 'messages');
    final out = <ConversationSummary>[];
    for (final r in rows) {
      final parts = (r['conversation_participants'] as List).cast<Map>();
      final other = parts.where((p) => p['user_id'] != uid).firstOrNull ?? parts.first;
      final prof = (other['profiles'] as Map?) ?? const {};
      final msgs = (r['messages'] as List).cast<Map>();
      out.add(ConversationSummary(
        id: r['id'] as String,
        otherUserId: other['user_id'] as String,
        otherName: (prof['full_name'] ?? prof['email'] ?? '?') as String,
        lastMessage: msgs.isEmpty ? null : msgs.first['body'] as String,
        lastAt: msgs.isEmpty ? null : parseDate(msgs.first['created_at']),
      ));
    }
    out.sort((a, b) => (b.lastAt ?? DateTime(0)).compareTo(a.lastAt ?? DateTime(0)));
    return out;
  }

  Future<String> openDirectChat(String otherUserId) async =>
      await db.rpc('get_or_create_direct_conversation', params: {'other': otherUserId}) as String;

  Stream<List<Message>> messages(String conversationId) => db
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('conversation_id', conversationId)
      .order('created_at')
      .map((rows) => rows.map(Message.fromMap).toList());

  Future<void> sendMessage(String conversationId, String body) =>
      db.from('messages').insert({'conversation_id': conversationId, 'body': body});

  // ----------------------------------------------------------------- support
  Future<List<SupportTicket>> tickets() async {
    final rows = await db
        .from('support_tickets')
        .select('*, profiles(full_name)')
        .order('priority', ascending: false)
        .order('created_at', ascending: false);
    return rows.map(SupportTicket.fromMap).toList();
  }

  Future<SupportTicket> ticket(String id) async =>
      SupportTicket.fromMap(await db.from('support_tickets').select('*, profiles(full_name)').eq('id', id).single());

  Future<void> createTicket(String subject, String body) =>
      db.from('support_tickets').insert({'subject': subject, 'body': body});

  Future<void> setTicketStatus(String id, String status) =>
      db.from('support_tickets').update({'status': status}).eq('id', id);

  Future<List<SupportMessage>> ticketMessages(String ticketId) async {
    final rows = await db.from('support_messages').select().eq('ticket_id', ticketId).order('created_at');
    return rows.map(SupportMessage.fromMap).toList();
  }

  Future<void> replyTicket(String ticketId, String body) =>
      db.from('support_messages').insert({'ticket_id': ticketId, 'body': body});
}
