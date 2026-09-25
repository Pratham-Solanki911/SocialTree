import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/env.dart';
import '../core/supabase_providers.dart';
import '../features/account/account_screen.dart';
import '../features/admin/admin_screen.dart';
import '../features/auth/pending_screen.dart';
import '../features/auth/setup_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/chat/conversations_screen.dart';
import '../features/families/families_screen.dart';
import '../features/families/family_screen.dart';
import '../features/gotra/gotra_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/home_shell.dart';
import '../features/map/migration_map_screen.dart';
import '../features/matches/matches_screen.dart';
import '../features/media/album_screen.dart';
import '../features/media/albums_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/person/person_detail_screen.dart';
import '../features/person/person_form_screen.dart';
import '../features/search/search_screen.dart';
import '../features/support/support_screen.dart';
import '../features/support/ticket_screen.dart';
import '../features/timeline/life_event_form_screen.dart';
import '../features/tree/tree_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/pending', builder: (_, _) => const PendingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/families',
              builder: (_, _) => const FamiliesScreen(),
              routes: [GoRoute(path: ':id', builder: (_, s) => FamilyScreen(familyId: s.pathParameters['id']!))],
            ),
          ]),
          StatefulShellBranch(routes: [GoRoute(path: '/search', builder: (_, _) => const SearchScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/map', builder: (_, _) => const MigrationMapScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/account', builder: (_, _) => const AccountScreen())]),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/persons/new',
        builder: (_, s) => PersonFormScreen(familyId: s.uri.queryParameters['familyId']),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/persons/:id',
        builder: (_, s) => PersonDetailScreen(personId: s.pathParameters['id']!),
        routes: [
          GoRoute(parentNavigatorKey: _rootKey, path: 'edit', builder: (_, s) => PersonFormScreen(personId: s.pathParameters['id'])),
          GoRoute(parentNavigatorKey: _rootKey, path: 'tree', builder: (_, s) => TreeScreen(rootId: s.pathParameters['id']!)),
          GoRoute(parentNavigatorKey: _rootKey, path: 'events/new', builder: (_, s) => LifeEventFormScreen(personId: s.pathParameters['id']!)),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/albums',
        builder: (_, _) => const AlbumsScreen(),
        routes: [GoRoute(parentNavigatorKey: _rootKey, path: ':id', builder: (_, s) => AlbumScreen(albumId: s.pathParameters['id']!))],
      ),
      GoRoute(parentNavigatorKey: _rootKey, path: '/matches', builder: (_, _) => const MatchesScreen()),
      GoRoute(parentNavigatorKey: _rootKey, path: '/gotra', builder: (_, _) => const GotraScreen()),
      GoRoute(parentNavigatorKey: _rootKey, path: '/notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/chat',
        builder: (_, _) => const ConversationsScreen(),
        routes: [GoRoute(parentNavigatorKey: _rootKey, path: ':id', builder: (_, s) => ChatScreen(conversationId: s.pathParameters['id']!))],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/support',
        builder: (_, _) => const SupportScreen(),
        routes: [GoRoute(parentNavigatorKey: _rootKey, path: ':id', builder: (_, s) => TicketScreen(ticketId: s.pathParameters['id']!))],
      ),
      GoRoute(parentNavigatorKey: _rootKey, path: '/admin', builder: (_, _) => const AdminScreen()),
    ],
  );
});

/// Re-runs redirects when auth or my profile changes.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this.ref) {
    // Touching Supabase providers before Supabase.initialize would throw.
    if (Env.isConfigured) {
      ref.listen(authStateProvider, (_, _) => notifyListeners());
      ref.listen(myProfileProvider, (_, _) => notifyListeners());
    }
  }
  final Ref ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    if (!Env.isConfigured) return loc == '/setup' ? null : '/setup';
    if (ref.read(sessionProvider) == null) return loc == '/sign-in' ? null : '/sign-in';
    final profile = ref.read(myProfileProvider).value;
    // Profile still loading or not approved: park on the pending screen.
    if (profile == null || !profile.isApproved) return loc == '/pending' ? null : '/pending';
    if (loc == '/sign-in' || loc == '/pending' || loc == '/setup') return '/home';
    return null;
  }
}
