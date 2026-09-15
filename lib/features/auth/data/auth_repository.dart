abstract class AuthRepository {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String name, String email, String password);
}

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<void> signIn(String email, String password) async {
    // TODO: integrate Firebase Auth.
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    // TODO: integrate Firebase Auth.
  }
}
