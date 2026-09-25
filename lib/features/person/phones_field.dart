import 'package:flutter/material.dart';

import '../../core/l10n_ext.dart';
import '../../core/phone.dart';
import '../../models/models.dart';

/// Editable list of E.164 phone numbers with WhatsApp flag.
class PhonesField extends StatefulWidget {
  const PhonesField({super.key, required this.initial, required this.onChanged});
  final List<PhoneEntry> initial;
  final ValueChanged<List<PhoneEntry>> onChanged;

  @override
  State<PhonesField> createState() => _PhonesFieldState();
}

class _PhonesFieldState extends State<PhonesField> {
  late List<PhoneEntry> _phones = [...widget.initial];

  Future<void> _edit([int? index]) async {
    final result = await showDialog<PhoneEntry>(
      context: context,
      builder: (_) => _PhoneDialog(existing: index == null ? null : _phones[index]),
    );
    if (result == null) return;
    setState(() {
      if (index == null) {
        _phones = [..._phones, result];
      } else {
        _phones = [..._phones]..[index] = result;
      }
    });
    widget.onChanged(_phones);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(l.phones, style: Theme.of(context).textTheme.labelLarge)),
            TextButton.icon(onPressed: () => _edit(), icon: const Icon(Icons.add), label: Text(l.addPhone)),
          ],
        ),
        for (var i = 0; i < _phones.length; i++)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(_phones[i].whatsapp ? Icons.chat : Icons.phone_outlined, color: _phones[i].whatsapp ? Colors.green : null),
            title: Text(_phones[i].number),
            subtitle: Text(_phones[i].label),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(i)),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() => _phones = [..._phones]..removeAt(i));
                    widget.onChanged(_phones);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PhoneDialog extends StatefulWidget {
  const _PhoneDialog({this.existing});
  final PhoneEntry? existing;

  @override
  State<_PhoneDialog> createState() => _PhoneDialogState();
}

class _PhoneDialogState extends State<_PhoneDialog> {
  late String _code;
  late final TextEditingController _local;
  late final TextEditingController _label;
  late final TextEditingController _customCode;
  late bool _whatsapp;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final (code, local) = e == null ? ('+91', '') : splitE164(e.number);
    final known = countryCodes.any((c) => c.$1 == code);
    _code = known ? code : 'custom';
    _customCode = TextEditingController(text: known ? '' : code);
    _local = TextEditingController(text: local);
    _label = TextEditingController(text: e?.label ?? 'mobile');
    _whatsapp = e?.whatsapp ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return AlertDialog(
      title: Text(l.addPhone),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _code,
            decoration: InputDecoration(labelText: l.countryCode),
            items: [
              for (final (code, name) in countryCodes) DropdownMenuItem(value: code, child: Text('$code  $name')),
              DropdownMenuItem(value: 'custom', child: Text(l.other)),
            ],
            onChanged: (v) => setState(() => _code = v ?? '+91'),
          ),
          if (_code == 'custom')
            TextField(controller: _customCode, decoration: const InputDecoration(labelText: '+', hintText: '+380'), keyboardType: TextInputType.phone),
          TextField(
            controller: _local,
            decoration: InputDecoration(labelText: l.phoneNumber, errorText: _error),
            keyboardType: TextInputType.phone,
            autofocus: true,
          ),
          TextField(controller: _label, decoration: InputDecoration(labelText: l.phoneLabel)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.whatsapp),
            value: _whatsapp,
            onChanged: (v) => setState(() => _whatsapp = v),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            final code = _code == 'custom' ? _customCode.text.trim() : _code;
            final e164 = toE164(code, _local.text);
            if (e164 == null) {
              setState(() => _error = l.invalidPhone);
              return;
            }
            Navigator.pop(context, PhoneEntry(number: e164, label: _label.text.trim().isEmpty ? 'mobile' : _label.text.trim(), whatsapp: _whatsapp));
          },
          child: Text(l.save),
        ),
      ],
    );
  }
}
