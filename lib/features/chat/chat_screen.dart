import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n_ext.dart';
import '../../core/supabase_providers.dart';
import '../../core/widgets.dart';
import '../../data/providers.dart';
import '../../models/models.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  bool _sending = false;

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(reposProvider).sendMessage(widget.conversationId, body);
      _input.clear();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final uid = ref.watch(currentUserIdProvider);
    final messages = ref.watch(messagesProvider(widget.conversationId));
    final other = ref.watch(conversationsProvider).value?.where((c) => c.id == widget.conversationId).firstOrNull;
    final tf = DateFormat.jm(Localizations.localeOf(context).toString());
    return Scaffold(
      appBar: AppBar(title: Text(other?.otherName ?? l.chat)),
      body: Column(
        children: [
          Expanded(
            child: AsyncBody<List<Message>>(
              value: messages,
              builder: (list) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final m = list[list.length - 1 - i];
                  final mine = m.senderId == uid;
                  final scheme = Theme.of(context).colorScheme;
                  return Align(
                    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      constraints: const BoxConstraints(maxWidth: 320),
                      decoration: BoxDecoration(
                        color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(m.body),
                          Text(tf.format(m.createdAt.toLocal()), style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: InputDecoration(hintText: l.messageHint, border: const OutlineInputBorder(), isDense: true),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  IconButton.filled(onPressed: _sending ? null : _send, icon: const Icon(Icons.send), tooltip: l.send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
