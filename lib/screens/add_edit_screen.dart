import 'package:flutter/material.dart';
import 'package:notes_app/components/color_selector.dart';
import 'package:notes_app/components/keyboard_dismissible.dart';
import 'package:notes_app/components/loading_indicator.dart';
import 'package:notes_app/components/localized_wrapper.dart';
import 'package:notes_app/l10n/app_localizations.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/services/database_helper.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool _isLoading = false;
  bool _hasChanges = false;
  Color _selectedColor = Colors.indigo;

  @override
  void initState() {
    super.initState();
    _initializeNote();
  }

  /// Initialize note data if editing
  void _initializeNote() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }

    // Listen for changes in text fields
    _titleController.addListener(_onFieldChanged);
    _contentController.addListener(_onFieldChanged);
  }

  /// Handle field changes
  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Save the note
  Future<void> _saveNote() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = await _databaseHelper.getSessionEmail();
      if (email == null) {
        if (mounted) {
          _showErrorSnackbar(l10n.sessionExpired);
        }
        return;
      }

      final note = Note(
        id: widget.note?.id,
        userId: email,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        color: _selectedColor.toARGB32().toString(),
        dateTime: DateTime.now(),
      );

      final success = widget.note == null
          ? await _databaseHelper.insertNote(note)
          : await _databaseHelper.updateNote(note);

      if (success && mounted) {
        Navigator.pop(context, true);
      } else if (mounted) {
        _showErrorSnackbar(l10n.errorSavingNote);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar(l10n.errorSavingNote);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.note != null;

    return PopScope<dynamic>(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        
        // Show the discard changes dialog
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.discardChanges),
            content: Text(l10n.discardChangesConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  l10n.discard,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ) ?? false;
        
        if (shouldPop && mounted) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      child: LocalizedWrapper(
        child: KeyboardDismissible(
          child: Scaffold(
            appBar: _buildAppBar(isEditing, l10n),
            body: _buildBody(context, l10n),
          ),
        ),
      ),
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar(bool isEditing, AppLocalizations l10n) {
    return AppBar(
      title: Text(isEditing ? l10n.editNote : l10n.addNote),
      actions: [
        IconButton(
          icon: _isLoading
              ? const LoadingIndicator(size: 20)
              : const Icon(Icons.save_outlined),
          onPressed: _isLoading ? null : _saveNote,
        ),
      ],
    );
  }

  /// Build the form body
  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTitleField(context, l10n),
            const SizedBox(height: 16),
            _buildContentField(context, l10n),
            const SizedBox(height: 16),
            ColorSelector(
              selectedColor: _selectedColor,
              onColorSelected: _handleColorSelected,
              title: l10n.noteColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Build the title input field
  Widget _buildTitleField(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(127),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _titleController,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: l10n.title,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.pleaseEnterTitle;
            }
            return null;
          },
        ),
      ),
    );
  }

  /// Build the content input field
  Widget _buildContentField(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(127),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _contentController,
          maxLines: null,
          minLines: 8,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: l10n.content,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.pleaseEnterContent;
            }
            return null;
          },
        ),
      ),
    );
  }

  /// Handle color selection
  void _handleColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
      _hasChanges = true;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
