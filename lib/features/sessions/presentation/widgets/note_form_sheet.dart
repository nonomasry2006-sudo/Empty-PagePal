import 'package:flutter/material.dart';

class NoteFormSheet extends StatefulWidget {
  final String bookTitle;
  final String? initialText;
  final void Function(String text) onSave;

  const NoteFormSheet({
    super.key,
    required this.bookTitle,
    this.initialText,
    required this.onSave,
  });

  @override
  State<NoteFormSheet> createState() => _NoteFormSheetState();
}

class _NoteFormSheetState extends State<NoteFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(_textCtrl.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF14281D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  widget.initialText == null ? 'Add Note' : 'Edit Note',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.bookTitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),

                // Text field
                TextFormField(
                  controller: _textCtrl,
                  autofocus: true,
                  maxLines: 5,
                  minLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts...',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 3) {
                      return 'Note must be at least 3 characters';
                    }
                    if (v.trim().length > 1000) {
                      return 'Note is too long (max 1000 characters)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}