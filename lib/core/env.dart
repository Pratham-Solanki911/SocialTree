/// Build-time configuration. Pass with `--dart-define`; nothing is hard-coded so
/// the anon key never lands in the repo.
class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  /// Project anon key (legacy `eyJ...` or new `sb_publishable_...`); both are public keys.
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Deep link Supabase redirects to after Google sign-in on Android/iOS.
  /// Must match AndroidManifest.xml and Info.plist.
  static const authRedirect = String.fromEnvironment(
    'AUTH_REDIRECT',
    defaultValue: 'in.samaj.socialtree://login-callback',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
