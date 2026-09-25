import 'package:flutter/material.dart';

import '../../core/l10n_ext.dart';
import '../../core/transliterate.dart';

/// Two labelled fields for one name: Gujarati and English. When one is typed
/// and the other is empty, the other is filled with a suggestion to check.
class BilingualNameFields extends StatefulWidget {
  const BilingualNameFields({super.key, required this.gu, required this.en, required this.labelGu, required this.labelEn, this.required = false});
  final TextEditingController gu;
  final TextEditingController en;
  final String labelGu;
  final String labelEn;
  final bool required;

  @override
  State<BilingualNameFields> createState() => _BilingualNameFieldsState();
}

class _BilingualNameFieldsState extends State<BilingualNameFields> {
  bool _guSuggested = false;
  bool _enSuggested = false;

  void _suggestEn() {
    if (widget.en.text.trim().isEmpty && widget.gu.text.trim().isNotEmpty) {
      widget.en.text = gujaratiToLatin(widget.gu.text.trim());
      setState(() => _enSuggested = true);
    }
  }

  void _suggestGu() {
    if (widget.gu.text.trim().isEmpty && widget.en.text.trim().isNotEmpty) {
      widget.gu.text = latinToGujarati(widget.en.text.trim());
      setState(() => _guSuggested = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    // Required means: at least one script filled.
    String? validator(String? _) =>
        widget.required && widget.gu.text.trim().isEmpty && widget.en.text.trim().isEmpty ? l.requiredField : null;
    return Column(
      children: [
        Focus(
          onFocusChange: (has) {
            if (!has) _suggestEn();
          },
          child: TextFormField(
            controller: widget.gu,
            decoration: InputDecoration(labelText: widget.labelGu, helperText: _guSuggested ? l.suggestedSpelling : null),
            validator: validator,
            onChanged: (_) => setState(() => _guSuggested = false),
          ),
        ),
        Focus(
          onFocusChange: (has) {
            if (!has) _suggestGu();
          },
          child: TextFormField(
            controller: widget.en,
            decoration: InputDecoration(labelText: widget.labelEn, helperText: _enSuggested ? l.suggestedSpelling : null),
            validator: validator,
            onChanged: (_) => setState(() => _enSuggested = false),
          ),
        ),
      ],
    );
  }
}
