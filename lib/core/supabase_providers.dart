import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

final supabaseProvider = Provider<SupabaseClient>((_) => Supabase.instance.client);

final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseProvider).auth.onAuthStateChange,
);

/// Current session; re-evaluated on every auth event.
final sessionProvider = Provider<Session?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(supabaseProvider).auth.currentSession;
});

final currentUserIdProvider =
    Provider<String?>((ref) => ref.watch(sessionProvider)?.user.id);

/// Live view of my `profiles` row so approval / plan changes apply instantly.
final myProfileProvider = StreamProvider<Profile?>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(null);
  return ref
      .watch(supabaseProvider)
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', uid)
      .map((rows) => rows.isEmpty ? null : Profile.fromMap(rows.first));
});

final localeProvider = Provider<Locale?>((ref) {
  final p = ref.watch(myProfileProvider).value;
  return p == null ? null : Locale(p.locale);
});
