import '../models/shelf_book_model.dart';

abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<ShelfBookModel> wantToRead;
  final List<ShelfBookModel> reading;
  final List<ShelfBookModel> finished;

  LibraryLoaded({
    required this.wantToRead,
    required this.reading,
    required this.finished,
  });
}

class LibraryEmpty extends LibraryState {}

class LibraryError extends LibraryState {
  final String message;
  LibraryError(this.message);
}

class LibraryUpdated extends LibraryState {}