import 'package:hive/hive.dart';
import '../models/shelf_book_model.dart';

class LibraryLocalDataSource {
  final Box<ShelfBookModel> _shelfBox = Hive.box<ShelfBookModel>('shelves');

  List<ShelfBookModel> getBooks() {
    return _shelfBox.values.toList();
  }

  Future<void> addBook(ShelfBookModel shelfBook) async {
    // Using book.id as the key prevents duplicate entries for the same book
    await _shelfBox.put(shelfBook.book.id, shelfBook);
  }

  Future<void> updateBook(ShelfBookModel shelfBook) async {
    await _shelfBox.put(shelfBook.book.id, shelfBook);
  }

  Future<void> deleteBook(String bookId) async {
    await _shelfBox.delete(bookId);
  }
}