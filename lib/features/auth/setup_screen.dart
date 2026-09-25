import 'package:flutter/material.dart';

import '../../core/l10n_ext.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings_suggest_outlined, size: 56),
              const SizedBox(height: 16),
              Text(context.l.setupTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(context.l.setupBody, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
