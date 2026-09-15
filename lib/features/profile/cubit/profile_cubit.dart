import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(milliseconds: 400));
    emit(ProfileLoaded(
      name: 'Jana Khaled',
      email: 'janakhaled0865@gmail.com',
    ));
  }
}
