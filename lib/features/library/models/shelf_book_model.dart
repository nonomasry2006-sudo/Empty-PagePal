import 'package:hive/hive.dart';
import '../../explore/models/book_model.dart';

part 'shelf_book_model.g.dart';

@HiveType(typeId: 1)
enum ShelfStatus {
  @HiveField(0)
  wantToRead,
  @HiveField(1)
  reading,
  @HiveField(2)
  finished
}

@HiveType(typeId: 0)
class ShelfBookModel extends HiveObject {
  @HiveField(0)
  final BookModel book;

  @HiveField(1)
  final ShelfStatus status;

  @HiveField(2)
  final int currentPage;

  @HiveField(3)
  final DateTime addedAt;

  ShelfBookModel({
    required this.book,
    required this.status,
    required this.currentPage,
    required this.addedAt,
  });
}