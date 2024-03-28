import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/auth/repo/auth_repo.dart';
import 'package:stockfolio/features/user_registeration/repo/user_repo.dart';
import 'package:stockfolio/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  final AuthRepository authRepo = AuthRepository();
  final UserRepository userRepo = UserRepository();
  String? verificationID = '';
  String? phoneNumber = '';

  Future<void> sendOtp(String phoneNo) async {
    emit(AuthLoadingState());
    phoneNumber = phoneNo;
    try {
      await authRepo.sendOtp(
        phoneNo,
        (FirebaseAuthException error) {
          emit(AuthErrorState(error.message.toString()));
        },
        (PhoneAuthCredential phoneAuthCredential) async {
          await signInWithPhone(phoneAuthCredential);
        },
        (String verificationId, int? forceResendingToken) {
          verificationID = verificationId;
          emit(AuthOtpCodeSentState());
        },
        (String verificationId) {
          verificationID = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  Future<void> verifyOtp(String otpCode) async {
    emit(AuthLoadingState());
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID!,
        smsCode: otpCode,
      );
      await signInWithPhone(credential);
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  Future<void> signInWithPhone(AuthCredential authCredential) async {
    emit(AuthLoadingState());
    try {
      final UserCredential userCredential =
          await authRepo.signInWithPhone(authCredential);
      if (userCredential.user != null) {
        emit(AuthOtpCodeVerifiedState(userCredential.user!));
        // if user not exists
        if (!(await checkUserExists(userCredential.user!.uid))) {
          emit(
            AuthVerifiedButNotRegisteredState(
              userCredential.user!,
              phoneNumber!,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  Future<bool> checkUserExists(String uid) async {
    emit(AuthLoadingState());
    try {
      if (await userRepo.checkExistingUser(uid)) {
        final UserModel userModel = await userRepo.fetchUserData(uid);
        emit(AuthVerifiedAndRegisteredState(userModel));
        return true;
      } else {
        emit(AuthNotRegisteredState());
      }
    } on FirebaseException catch (e) {
      emit(AuthErrorState(e.message.toString()));
      print("ERRORRRR - \n${e.message.toString()}\n\n");
    }
    return false;
  }

  Future<void> logOut() async {
    emit(AuthLoadingState());
    try {
      await userRepo.removeUidFromPrefs();
      await authRepo.signOut();
      emit(AuthInitialState());
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print("\nAuthCubit - $change\n");
  }
}
