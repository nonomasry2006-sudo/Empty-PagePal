import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 3)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String bookId;

  @HiveField(2)
  final String bookTitle;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.text,
    required this.createdAt,
  });

  NoteModel copyWith({
    String? id,
    String? bookId,
    String? bookTitle,
    String? text,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}