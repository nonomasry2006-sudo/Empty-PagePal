import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../data/books_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final BooksRepository repository;
  SearchCubit(this.repository) : super(SearchInitial());

  int _startIndex = 0;
  String _lastQuery = '';
  bool _hasMore = true;

  Future<void> loadDefault() async {
    await search('subject:${ApiConstants.defaultSubject}');
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    _lastQuery = query;
    _startIndex = 0;
    _hasMore = true;
    emit(SearchLoading());

    final (books, failure) = await repository.searchBooks(query);

    if (isClosed) return;

    if (failure != null) {
      emit(SearchError(failure.message));
    } else if (books == null || books.isEmpty) {
      emit(SearchEmpty());
    } else {
      _startIndex = books.length;
      _hasMore = books.length >= ApiConstants.defaultLimit;
      emit(SearchLoaded(books, hasMore: _hasMore));
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is! SearchLoaded) return;
    final current = state as SearchLoaded;
    if (current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final (books, failure) = await repository.searchBooks(
      _lastQuery,
      startIndex: _startIndex,
    );

    if (isClosed) return;

    if (failure != null) {
      emit(SearchError(failure.message));
    } else {
      final combined = [...current.books, ...?books];
      _startIndex = combined.length;
      _hasMore = (books?.length ?? 0) >= ApiConstants.defaultLimit;
      emit(SearchLoaded(combined, hasMore: _hasMore));
    }
  }

  void clear() {
    _startIndex = 0;
    _lastQuery = '';
    _hasMore = true;
    emit(SearchInitial());
  }
}