import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/book_model.dart';
import 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  final DioClient client;
  final BookModel initialBook;

  BookDetailsCubit({
    required this.client,
    required this.initialBook,
  }) : super(BookDetailsLoaded(initialBook));

  Future<void> fetchFullDetails() async {
    emit(BookDetailsLoading(initialBook));

    try {
      final response = await client.get(
        ApiConstants.workDetails(initialBook.id),
      );

      final data = response.data as Map<String, dynamic>;
      final enriched = initialBook.copyWith(
        description: _extractDescription(data) ?? initialBook.description,
      );

      if (isClosed) return;
      emit(BookDetailsLoaded(enriched));
    } on ServerException catch (e) {
      if (isClosed) return;
      emit(BookDetailsError(initialBook, e.message));
    } catch (_) {
      if (isClosed) return;
      emit(BookDetailsLoaded(initialBook));
    }
  }

  String? _extractDescription(Map<String, dynamic> data) {
    final desc = data['description'];
    if (desc is String) return desc;
    if (desc is Map && desc['value'] is String) return desc['value'] as String;

    final subjects = data['subjects'];
    if (subjects is List && subjects.isNotEmpty) {
      return 'A book about ${subjects.take(3).join(', ')}.';
    }
    return null;
  }
}