class BooksRepository {
  Future<List<Map<String, String>>> fetchBooks() async {
    return [
      {'title': 'The Midnight Library', 'author': 'Matt Haig'},
      {'title': 'Atomic Habits', 'author': 'James Clear'},
    ];
  }
}
