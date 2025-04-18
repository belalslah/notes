import 'package:flutter/material.dart';
import 'package:notes_app/components/empty_state.dart';
import 'package:notes_app/components/loading_indicator.dart';
import 'package:notes_app/components/localized_wrapper.dart';
import 'package:notes_app/components/note_card.dart';
import 'package:notes_app/l10n/app_localizations.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/screens/add_edit_screen.dart';
import 'package:notes_app/screens/auth/login_screen.dart';
import 'package:notes_app/services/database_helper.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/services/language_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  /// Load notes from the database
  Future<void> _loadNotes() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final email = await _databaseHelper.getSessionEmail();
      if (email == null) {
        _logout();
        return;
      }

      final notes = await _databaseHelper.getNotes(email);
      if (mounted) {
        setState(() => _notes = notes);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar(AppLocalizations.of(context)!.errorLoadingNotes);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  /// Log out the current user
  Future<void> _logout() async {
    await _databaseHelper.clearSession();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  /// Navigate to add note screen
  Future<void> _addNote() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
    );

    if (result == true && mounted) {
      _loadNotes();
    }
  }

  /// Navigate to edit note screen
  Future<void> _editNote(Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => AddEditNoteScreen(note: note)),
    );

    if (result == true && mounted) {
      _loadNotes();
    }
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteDialog(Note note) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.deleteNoteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _databaseHelper.deleteNote(note.id!);
        _loadNotes();
      } catch (e) {
        if (mounted) {
          _showErrorSnackbar(l10n.errorDeletingNote);
        }
      }
    }
  }

  /// Format date for display
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);
    final l10n = AppLocalizations.of(context)!;

    return LocalizedWrapper(
      child: Scaffold(
        appBar: _buildAppBar(context, themeService, languageService, l10n),
        body: _buildBody(l10n),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNote,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Build the app bar with actions
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeService themeService,
    LanguageService languageService,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Text(l10n.myNotes),
      actions: [
        IconButton(
          icon: Icon(
            themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => themeService.toggleTheme(),
        ),
        IconButton(
          icon: Text(
            languageService.isArabic ? 'EN' : 'عربي',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => languageService.toggleLanguage(),
        ),
        IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
      ],
    );
  }

  /// Build the main body content based on state
  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (_notes.isEmpty) {
      return EmptyState(
        icon: Icons.note_outlined,
        title: l10n.noNotes,
        message: l10n.createFirstNote,
      );
    }

    return _buildNotesGrid(l10n);
  }

  /// Build the grid of notes
  Widget _buildNotesGrid(AppLocalizations l10n) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return NoteCard(
          note: note,
          onTap: () => _editNote(note),
          onDelete: () => _showDeleteDialog(note),
          formatDate: _formatDate,
        );
      },
    );
  }
}
