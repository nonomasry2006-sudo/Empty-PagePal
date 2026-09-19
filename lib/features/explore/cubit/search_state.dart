import 'package:equatable/equatable.dart';

import '../models/book_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

class SearchLoaded extends SearchState {
  final List<BookModel> books;
  final bool hasMore;
  final bool isLoadingMore;

  const SearchLoaded(
    this.books, {
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  SearchLoaded copyWith({
    List<BookModel>? books,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      books ?? this.books,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [books, hasMore, isLoadingMore];
}