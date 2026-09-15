class ProfileRepository {
  Future<Map<String, dynamic>> fetchProfile() async {
    return {
      'name': 'Jana Khaled',
      'email': 'janakhaled0865@gmail.com',
      'phone': '+201023456789',
      'bio': 'Passionate reader and software engineering student.',
    };
  }
}
