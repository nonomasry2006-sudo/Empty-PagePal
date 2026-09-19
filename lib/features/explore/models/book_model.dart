import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/api_constants.dart';

part 'book_model.g.dart';

@HiveType(typeId: 2)
class BookModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> authors;

  @HiveField(3)
  final int? firstPublishYear;

  @HiveField(4)
  final int? coverId;

  @HiveField(5)
  final int? pageCount;

  @HiveField(6)
  final List<String> subjects;

  @HiveField(7)
  final String? description;

  const BookModel({
    required this.id,
    required this.title,
    this.authors = const [],
    this.firstPublishYear,
    this.coverId,
    this.pageCount,
    this.subjects = const [],
    this.description,
  });

  String? get coverUrl {
    if (coverId == null) return null;
    return ApiConstants.coverUrl(coverId!);
  }

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? firstPublishYear,
    int? coverId,
    int? pageCount,
    List<String>? subjects,
    String? description,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      firstPublishYear: firstPublishYear ?? this.firstPublishYear,
      coverId: coverId ?? this.coverId,
      pageCount: pageCount ?? this.pageCount,
      subjects: subjects ?? this.subjects,
      description: description ?? this.description,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    String? desc;
    final raw = json['description'];
    if (raw is String) {
      desc = raw;
    } else if (raw is Map && raw['value'] is String) {
      desc = raw['value'] as String;
    }

    return BookModel(
      id: (json['key'] as String? ?? '').replaceFirst('/works/', ''),
      title: json['title'] as String? ?? 'Unknown Title',
      authors: (json['author_name'] as List?)?.cast<String>() ?? const [],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
      pageCount: json['number_of_pages_median'] as int?,
      subjects: (json['subjects'] as List?)?.cast<String>() ?? const [],
      description: desc,
    );
  }

  @override
  List<Object?> get props => [id, title];
}