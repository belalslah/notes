/// Represents a note in the application
class Note {
  final int? id;
  final String userId;
  final String title;
  final String content;
  final String color;
  final DateTime dateTime;

  const Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  /// Create a Note from a map (usually from database)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as String,
      dateTime: DateTime.parse(map['date_time'] as String),
    );
  }

  /// Convert the Note to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'color': color,
      'date_time': dateTime.toIso8601String(),
    };
  }

  /// Create a copy of this Note with the given fields replaced with new values
  Note copyWith({
    int? id,
    String? userId,
    String? title,
    String? content,
    String? color,
    DateTime? dateTime,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          content == other.content &&
          color == other.color &&
          dateTime == other.dateTime;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      content.hashCode ^
      color.hashCode ^
      dateTime.hashCode;

  @override
  String toString() {
    return 'Note{id: $id, userId: $userId, title: $title, content: $content, color: $color, dateTime: $dateTime}';
  }
}
