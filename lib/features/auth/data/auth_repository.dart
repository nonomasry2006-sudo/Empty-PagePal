import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) {
    return remote.signIn(email: email, password: password);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return remote.signUp(email: email, password: password, name: name);
  }

  @override
  Future<void> signOut() => remote.signOut();
}