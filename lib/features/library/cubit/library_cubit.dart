import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/library_repository.dart';
import '../models/shelf_book_model.dart';
import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository _repository;

  LibraryCubit(this._repository) : super(LibraryInitial());

  void loadLibrary() {
    print('CUBIT: loadLibrary called');
    emit(LibraryLoading());
    try {
      final allBooks = _repository.getAllBooks();
      print('CUBIT: getAllBooks returned ${allBooks.length}');

      if (allBooks.isEmpty) {
        print('CUBIT: library is empty');
        emit(LibraryEmpty());
        return;
      }

      final wantToRead =
          allBooks.where((b) => b.status == ShelfStatus.wantToRead).toList();
      final reading =
          allBooks.where((b) => b.status == ShelfStatus.reading).toList();
      final finished =
          allBooks.where((b) => b.status == ShelfStatus.finished).toList();

      print('CUBIT: wantToRead=${wantToRead.length} reading=${reading.length} finished=${finished.length}');

      emit(LibraryLoaded(
        wantToRead: wantToRead,
        reading: reading,
        finished: finished,
      ));
      print('CUBIT: emitted LibraryLoaded');
    } catch (e) {
      print('CUBIT ERROR loadLibrary: $e');
      emit(LibraryError("Failed to load library: ${e.toString()}"));
    }
  }

  Future<void> addBook(ShelfBookModel book) async {
    print('CUBIT: addBook called - ${book.book.title}');
    try {
      await _repository.saveBook(book);
      print('CUBIT: saved to repository');
      emit(LibraryUpdated());
      loadLibrary();
    } catch (e) {
      print('CUBIT ERROR addBook: $e');
      emit(LibraryError("Failed to add book: ${e.toString()}"));
    }
  }

  Future<void> removeBook(String bookId) async {
    try {
      await _repository.deleteBook(bookId);
      emit(LibraryUpdated());
      loadLibrary();
    } catch (e) {
      emit(LibraryError("Failed to delete book: ${e.toString()}"));
    }
  }

  Future<void> updateBookProgress(ShelfBookModel book, int newPage) async {
    try {
      final updatedBook = ShelfBookModel(
        book: book.book,
        status: book.status,
        currentPage: newPage,
        addedAt: book.addedAt,
      );
      await _repository.saveBook(updatedBook);
      emit(LibraryUpdated());
      loadLibrary();
    } catch (e) {
      emit(LibraryError("Failed to update progress: ${e.toString()}"));
    }
  }

  Future<void> updateShelfStatus(
    ShelfBookModel book,
    ShelfStatus newStatus,
  ) async {
    try {
      final updatedBook = ShelfBookModel(
        book: book.book,
        status: newStatus,
        currentPage: book.currentPage,
        addedAt: book.addedAt,
      );
      await _repository.saveBook(updatedBook);
      emit(LibraryUpdated());
      loadLibrary();
    } catch (e) {
      emit(LibraryError("Failed to move book: ${e.toString()}"));
    }
  }
}