import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/book_model.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> searchBooks(
    String query, {
    int startIndex = 0,
  });
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final DioClient client;
  BooksRemoteDataSourceImpl(this.client);

  @override
  Future<List<BookModel>> searchBooks(
    String query, {
    int startIndex = 0,
  }) async {
    try {
      final isSubject = query.startsWith('subject:');
      final cleanQuery = isSubject ? query.substring(8) : query;

      final response = await client.get(
        ApiConstants.search,
        query: {
          if (isSubject) 'subject': cleanQuery else 'q': cleanQuery,
          'limit': ApiConstants.defaultLimit,
          'offset': startIndex,
          'fields': ApiConstants.fields,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final docs = data['docs'] as List?;
      if (docs == null || docs.isEmpty) return [];

      return docs
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      throw ServerException('Failed to load books');
    }
  }
}