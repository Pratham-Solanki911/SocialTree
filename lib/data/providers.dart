import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/supabase_providers.dart';
import '../models/models.dart';
import 'repositories.dart';

final reposProvider = Provider<Repos>((ref) => Repos(ref.watch(supabaseProvider)));

final familiesProvider = FutureProvider.autoDispose<List<Family>>((ref) => ref.watch(reposProvider).families());
final familyProvider = FutureProvider.autoDispose.family<Family, String>((ref, id) => ref.watch(reposProvider).family(id));
final familyMembersProvider = FutureProvider.autoDispose.family<List<Person>, String>((ref, id) => ref.watch(reposProvider).familyMembers(id));
final familyMemberCountsProvider = FutureProvider.autoDispose<Map<String, int>>((ref) => ref.watch(reposProvider).familyMemberCounts());

final personProvider = FutureProvider.autoDispose.family<Person, String>((ref, id) => ref.watch(reposProvider).person(id));
final myPersonProvider = FutureProvider.autoDispose<Person?>((ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(reposProvider).myPerson();
});
final recentPersonsProvider = FutureProvider.autoDispose<List<Person>>((ref) => ref.watch(reposProvider).recentPersons());

/// (root person id, hops)
final treeProvider = FutureProvider.autoDispose.family<TreeData, (String, int)>((ref, arg) => ref.watch(reposProvider).tree(arg.$1, arg.$2));
final ancestorIdsProvider = FutureProvider.autoDispose.family<Set<String>, String>((ref, id) => ref.watch(reposProvider).ancestorIds(id));

final eventsProvider = FutureProvider.autoDispose.family<List<LifeEvent>, String>((ref, id) => ref.watch(reposProvider).events(id));
final feedProvider = FutureProvider.autoDispose<List<FeedItem>>((ref) => ref.watch(reposProvider).feed());

final albumsProvider = FutureProvider.autoDispose<List<Album>>((ref) => ref.watch(reposProvider).albums());
final albumProvider = FutureProvider.autoDispose.family<Album, String>((ref, id) => ref.watch(reposProvider).album(id));
final albumMediaProvider = FutureProvider.autoDispose.family<List<MediaItem>, String>((ref, id) => ref.watch(reposProvider).albumMedia(id));
final personMediaProvider = FutureProvider.autoDispose.family<List<MediaItem>, String>((ref, id) => ref.watch(reposProvider).personMedia(id));

final gotrasProvider = FutureProvider.autoDispose<List<Gotra>>((ref) => ref.watch(reposProvider).gotras());
final surnameLookupProvider = FutureProvider.autoDispose.family<List<SurnameGotra>, String>((ref, q) => ref.watch(reposProvider).lookupSurname(q));

final pendingMatchesProvider = FutureProvider.autoDispose<List<MatchSuggestion>>((ref) => ref.watch(reposProvider).pendingMatches());

final notificationsProvider = StreamProvider.autoDispose<List<AppNotification>>((ref) {
  if (ref.watch(currentUserIdProvider) == null) return Stream.value(const []);
  return ref.watch(reposProvider).notifications();
});
final unreadCountProvider = Provider.autoDispose<int>((ref) =>
    ref.watch(notificationsProvider).value?.where((n) => !n.isRead).length ?? 0);

final conversationsProvider = FutureProvider.autoDispose<List<ConversationSummary>>((ref) => ref.watch(reposProvider).conversations());
final messagesProvider = StreamProvider.autoDispose.family<List<Message>, String>((ref, id) => ref.watch(reposProvider).messages(id));

final ticketsProvider = FutureProvider.autoDispose<List<SupportTicket>>((ref) => ref.watch(reposProvider).tickets());
final ticketProvider = FutureProvider.autoDispose.family<SupportTicket, String>((ref, id) => ref.watch(reposProvider).ticket(id));
final ticketMessagesProvider = FutureProvider.autoDispose.family<List<SupportMessage>, String>((ref, id) => ref.watch(reposProvider).ticketMessages(id));

final approvedProfilesProvider = FutureProvider.autoDispose<List<Profile>>((ref) => ref.watch(reposProvider).approvedProfiles());
final allProfilesProvider = FutureProvider.autoDispose<List<Profile>>((ref) => ref.watch(reposProvider).allProfiles());

final migrationPathsProvider = FutureProvider.autoDispose.family<List<MigrationHop>, String?>((ref, familyId) => ref.watch(reposProvider).migrationPaths(familyId));
