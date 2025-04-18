import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Helper class for managing SQLite database operations
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  // Add a variable to store temporary session
  static String? _temporarySessionEmail;

  // Table names
  static const String _usersTable = 'users';
  static const String _notesTable = 'notes';
  static const String _sessionsTable = 'sessions';

  // Singleton pattern
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  /// Get the database instance, creating it if necessary
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  /// Create database tables
  Future<void> _createTables(Database db, int version) async {
    await db.transaction((txn) async {
      // Users table
      await txn.execute('''
        CREATE TABLE $_usersTable(
          email TEXT PRIMARY KEY,
          password TEXT NOT NULL
        )
      ''');

      // Notes table
      await txn.execute('''
        CREATE TABLE $_notesTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id TEXT NOT NULL,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          color TEXT NOT NULL,
          date_time TEXT NOT NULL,
          FOREIGN KEY(user_id) REFERENCES $_usersTable(email)
        )
      ''');

      // Sessions table
      await txn.execute('''
        CREATE TABLE $_sessionsTable(
          email TEXT PRIMARY KEY,
          FOREIGN KEY(email) REFERENCES $_usersTable(email)
        )
      ''');
    });
  }

  /// Hash a password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Register a new user
  Future<bool> registerUser(String email, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);

      await db.insert(
        _usersTable,
        {'email': email, 'password': hashedPassword},
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } catch (e) {
      debugPrint('Error registering user: $e');
      return false;
    }
  }

  /// Login a user
  Future<bool> loginUser(String email, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);

      final result = await db.query(
        _usersTable,
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Error logging in user: $e');
      return false;
    }
  }

  /// Save user session
  Future<void> saveSession(String email) async {
    try {
      final db = await database;
      await db.insert(
        _sessionsTable,
        {'email': email},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }

  /// Load saved session
  Future<bool> loadSession() async {
    // Check for temporary session first
    if (_temporarySessionEmail != null) {
      return true;
    }
    
    try {
      final db = await database;
      final result = await db.query(_sessionsTable);
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Error loading session: $e');
      return false;
    }
  }

  /// Set temporary session (in-memory only)
  Future<void> setTemporarySession(String email) async {
    _temporarySessionEmail = email;
  }

  /// Get user's email from session
  Future<String?> getSessionEmail() async {
    // First check temporary session
    if (_temporarySessionEmail != null) {
      return _temporarySessionEmail;
    }
    
    try {
      final db = await database;
      final result = await db.query(_sessionsTable);
      if (result.isEmpty) return null;
      return result.first['email'] as String;
    } catch (e) {
      debugPrint('Error getting session email: $e');
      return null;
    }
  }

  /// Clear user session
  Future<void> clearSession() async {
    // Clear temporary session
    _temporarySessionEmail = null;
    
    try {
      final db = await database;
      await db.delete(_sessionsTable);
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }

  /// Insert a new note
  Future<bool> insertNote(Note note) async {
    try {
      final db = await database;
      await db.insert(_notesTable, note.toMap());
      return true;
    } catch (e) {
      debugPrint('Error inserting note: $e');
      return false;
    }
  }

  /// Update an existing note
  Future<bool> updateNote(Note note) async {
    try {
      final db = await database;
      final rowsAffected = await db.update(
        _notesTable,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error updating note: $e');
      return false;
    }
  }

  /// Delete a note
  Future<bool> deleteNote(int id) async {
    try {
      final db = await database;
      final rowsAffected = await db.delete(
        _notesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      return false;
    }
  }

  /// Get all notes for a user
  Future<List<Note>> getNotes(String userId) async {
    try {
      final db = await database;
      final maps = await db.query(
        _notesTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date_time DESC',
      );
      return maps.map((map) => Note.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error getting notes: $e');
      return [];
    }
  }
}
