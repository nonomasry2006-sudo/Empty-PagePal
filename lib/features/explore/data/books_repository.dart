import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../models/book_model.dart';
import 'books_remote_data_source.dart';

abstract class BooksRepository {
  Future<(List<BookModel>?, Failure?)> searchBooks(
    String query, {
    int startIndex = 0,
  });
}

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remote;
  BooksRepositoryImpl(this.remote);

  @override
  Future<(List<BookModel>?, Failure?)> searchBooks(
    String query, {
    int startIndex = 0,
  }) async {
    try {
      final books = await remote.searchBooks(query, startIndex: startIndex);
      return (books, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    }
  }
}