// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Notes App';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get name => 'Name';

  @override
  String get invalidEmailPassword => 'Invalid email or password';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get myNotes => 'My Notes';

  @override
  String get noNotes => 'No notes yet';

  @override
  String get createFirstNote => 'Tap the + button to create your first note';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get noteColor => 'Note Color';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get pleaseEnterContent => 'Please enter content';

  @override
  String get delete => 'Delete';

  @override
  String get deleteNote => 'Delete Note';

  @override
  String get deleteNoteConfirm => 'Are you sure you want to delete this note?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get accountCreated => 'Account created successfully';

  @override
  String get discardChanges => 'Discard Changes';

  @override
  String get discardChangesConfirm => 'Are you sure you want to discard your changes?';

  @override
  String get discard => 'Discard';

  @override
  String get sessionExpired => 'Session expired. Please login again';

  @override
  String get errorSavingNote => 'Error saving note';

  @override
  String get errorLoadingNotes => 'Error loading notes';

  @override
  String get errorDeletingNote => 'Error deleting note';
}
