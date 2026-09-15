import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthSuccess());
  }

  Future<void> signup(String name, String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthSuccess());
  }
}
