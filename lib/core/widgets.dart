import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n_ext.dart';
import 'supabase_providers.dart';

/// Renders an AsyncValue with shared loading / error UI.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({super.key, required this.value, required this.builder, this.onRetry});
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e, onRetry: onRetry),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 8),
            Text(context.l.errorWithMessage(friendlyError(error)), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton.tonal(onPressed: onRetry, child: Text(context.l.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.text, this.icon = Icons.inbox_outlined, this.action});
  final String text;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final extra = action;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (extra != null) ...[const SizedBox(height: 12), extra],
          ],
        ),
      ),
    );
  }
}

String friendlyError(Object e) {
  if (e is PostgrestException) return e.message;
  if (e is StorageException) return e.message;
  if (e is AuthException) return e.message;
  return e.toString();
}

void showError(BuildContext context, Object e) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(context.l.errorWithMessage(friendlyError(e)))));
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

Future<bool> confirm(BuildContext context, String text) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(ctx.l.ok)),
      ],
    ),
  );
  return ok ?? false;
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
          ?trailing,
        ],
      ),
    );
  }
}

class LabeledValue extends StatelessWidget {
  const LabeledValue(this.label, this.value, {super.key});
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) return const SizedBox.shrink();
    return ListTile(
      dense: true,
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(value!, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

/// Signed URL for a private storage object, cached for its lifetime.
final signedUrlProvider = FutureProvider.family<String, String>((ref, path) async {
  ref.keepAlive();
  const ttl = 3600;
  final url = await ref.read(supabaseProvider).storage.from('media').createSignedUrl(path, ttl);
  final timer = Future.delayed(const Duration(seconds: ttl - 60), () => ref.invalidateSelf());
  ref.onDispose(() => timer.ignore());
  return url;
});

/// Image stored in the private `media` bucket.
class SignedImage extends ConsumerWidget {
  const SignedImage(this.path, {super.key, this.fit = BoxFit.cover, this.width, this.height, this.borderRadius});
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(signedUrlProvider(path));
    final child = url.when(
      data: (u) => Image.network(u, fit: fit, width: width, height: height,
          errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined)),
      loading: () => SizedBox(width: width, height: height, child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))),
      error: (_, _) => SizedBox(width: width, height: height, child: const Icon(Icons.broken_image_outlined)),
    );
    return borderRadius == null ? child : ClipRRect(borderRadius: borderRadius!, child: child);
  }
}

/// Passport-style avatar with initials fallback.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key, required this.path, required this.initials, this.size = 48});
  final String? path;
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (path != null) {
      return SignedImage(path!, width: size, height: size * 4 / 3, borderRadius: BorderRadius.circular(6));
    }
    return Container(
      width: size,
      height: size * 4 / 3,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(initials, style: TextStyle(fontSize: size / 2.6, fontWeight: FontWeight.bold)),
    );
  }
}
