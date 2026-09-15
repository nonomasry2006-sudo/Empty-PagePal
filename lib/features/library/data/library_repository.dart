class LibraryRepository {
  Future<List<String>> fetchShelves() async {
    return ['Reading', 'Want to Read', 'Finished'];
  }
}
