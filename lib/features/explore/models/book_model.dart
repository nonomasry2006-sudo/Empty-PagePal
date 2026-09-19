import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId: 2) 
class BookModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String author;
  
  @HiveField(3)
  final String? coverUrl;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
  });
}