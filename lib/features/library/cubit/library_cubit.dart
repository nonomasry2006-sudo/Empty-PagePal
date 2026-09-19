import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/library_repository.dart';
import '../models/shelf_book_model.dart';
import 'library_state.dart';
// Note: Ensure this import path matches where BookModel is located
import '../../explore/models/book_model.dart'; 

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository _repository;

  LibraryCubit(this._repository) : super(LibraryInitial());

  void loadLibrary() {
    emit(LibraryLoading());
    try {
      final allBooks = _repository.getAllBooks();
      
      if (allBooks.isEmpty) {
        emit(LibraryEmpty());
        return;
      }

      final wantToRead = allBooks.where((b) => b.status == ShelfStatus.wantToRead).toList();
      final reading = allBooks.where((b) => b.status == ShelfStatus.reading).toList();
      final finished = allBooks.where((b) => b.status == ShelfStatus.finished).toList();

      emit(LibraryLoaded(
        wantToRead: wantToRead,
        reading: reading,
        finished: finished,
      ));
    } catch (e) {
      emit(LibraryError("Failed to load library: ${e.toString()}"));
    }
  }

  Future<void> addBook(ShelfBookModel book) async {
    try {
      await _repository.saveBook(book);
      emit(LibraryUpdated());
      loadLibrary(); // Reload to refresh the categorized shelves
    } catch (e) {
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
      // Create a copy of the book with the new page count
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

  Future<void> updateShelfStatus(ShelfBookModel book, ShelfStatus newStatus) async {
    try {
      // Create a copy of the book with the new shelf status
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

  // ---> MOVED INSIDE THE CLASS AND REFACTORED <---
  Future<void> addDummyBook() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final dummyShelfBook = ShelfBookModel(
      book: BookModel(
        id: id,
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
      ),
      status: ShelfStatus.reading, // Defaults to Reading tab
      currentPage: 42,
      addedAt: DateTime.now(),
    );

    // Reuses your existing perfectly written addBook method
    await addBook(dummyShelfBook); 
  }
}