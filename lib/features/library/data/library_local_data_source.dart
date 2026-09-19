import 'package:hive/hive.dart';

import '../models/shelf_book_model.dart';

class LibraryLocalDataSource {
  Box<ShelfBookModel> get _shelfBox => Hive.box<ShelfBookModel>('shelves');

  List<ShelfBookModel> getBooks() {
    final books = _shelfBox.values.toList();
    print('DATASOURCE: getBooks returned ${books.length}');
    return books;
  }

  Future<void> addBook(ShelfBookModel shelfBook) async {
    print('DATASOURCE: addBook - key: ${shelfBook.book.id}');
    await _shelfBox.put(shelfBook.book.id, shelfBook);
    await _shelfBox.flush();
    print('DATASOURCE: box now has ${_shelfBox.length} items');
  }

  Future<void> updateBook(ShelfBookModel shelfBook) async {
    await _shelfBox.put(shelfBook.book.id, shelfBook);
    await _shelfBox.flush();
  }

  Future<void> deleteBook(String bookId) async {
    await _shelfBox.delete(bookId);
    await _shelfBox.flush();
  }
}