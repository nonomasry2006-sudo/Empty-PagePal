import 'package:equatable/equatable.dart';

import '../models/book_model.dart';

abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object?> get props => [];
}

class BookDetailsLoading extends BookDetailsState {
  final BookModel book;

  const BookDetailsLoading(this.book);

  @override
  List<Object?> get props => [book];
}

class BookDetailsLoaded extends BookDetailsState {
  final BookModel book;

  const BookDetailsLoaded(this.book);

  @override
  List<Object?> get props => [book];
}

class BookDetailsError extends BookDetailsState {
  final BookModel book;
  final String message;

  const BookDetailsError(this.book, this.message);

  @override
  List<Object?> get props => [book, message];
}