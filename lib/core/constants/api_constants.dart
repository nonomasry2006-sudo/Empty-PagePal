class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://openlibrary.org';

  static const String search = '/search.json';

  static const int defaultLimit = 20;

  static const String defaultSubject = 'fiction';

  static const String fields =
      'key,title,author_name,first_publish_year,cover_i,number_of_pages_median,subjects';

  static String coverUrl(int coverId, {String size = 'M'}) {
    return 'https://covers.openlibrary.org/b/id/$coverId-$size.jpg';
  }

  static String workDetails(String workId) => '/works/$workId.json';
}