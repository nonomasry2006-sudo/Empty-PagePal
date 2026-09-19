import '../models/shelf_book_model.dart';
import 'library_local_data_source.dart';

class LibraryRepository {
  final LibraryLocalDataSource _localDataSource;

  LibraryRepository(this._localDataSource);

  List<ShelfBookModel> getAllBooks() {
    return _localDataSource.getBooks();
  }

  Future<void> saveBook(ShelfBookModel book) async {
    await _localDataSource.addBook(book);
  }

  Future<void> deleteBook(String bookId) async {
    await _localDataSource.deleteBook(bookId);
  }
}