import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/user_registeration/repo/user_repo.dart';
import 'package:stockfolio/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState());

  final UserRepository userRepo = UserRepository();

  Future<void> saveUserDataToFirebase(
    UserModel userModel,
    File fileImage,
  ) async {
    emit(UserLoadingState());
    try {
      final UserModel currUserModel = await userRepo.saveUserDataToFirebase(
        userModel: userModel,
        profilePic: fileImage,
      );
      emit(UserDataSavedState(currUserModel));
    } on FirebaseException catch (e) {
      emit(UserErrorState(e.message.toString()));
    }
  }

  Future<void> fetchUserData(
    String uid,
  ) async {
    emit(UserLoadingState());
    try {
      final UserModel userModel = await userRepo.fetchUserData(uid);
      emit(UserDataFetchedState(userModel));
    } on FirebaseException catch (e) {
      emit(UserErrorState(e.message.toString()));
    }
  }

  @override
  void onChange(Change<UserState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print('\nUserCubit - $change \n');
    }
  }
}
