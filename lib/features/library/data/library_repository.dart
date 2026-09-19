import '../models/shelf_book_model.dart';
import 'library_local_data_source.dart';

class LibraryRepository {
  final LibraryLocalDataSource _localDataSource;

  LibraryRepository(this._localDataSource);

  List<ShelfBookModel> getAllBooks() {
    final books = _localDataSource.getBooks();
    print('REPO: getAllBooks returned ${books.length}');
    return books;
  }

  Future<void> saveBook(ShelfBookModel book) async {
    print('REPO: saveBook - ${book.book.title}');
    await _localDataSource.addBook(book);
    print('REPO: saved');
  }

  Future<void> deleteBook(String bookId) async {
    await _localDataSource.deleteBook(bookId);
  }
}