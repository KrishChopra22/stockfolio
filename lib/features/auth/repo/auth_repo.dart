import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendOtp(
    String phoneNumber,
    PhoneVerificationFailed phoneVerificationFailed,
    PhoneVerificationCompleted phoneVerificationCompleted,
    PhoneCodeSent phoneCodeSent,
    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  Future<UserCredential> verifyOtpAndLogin(
    String verificationId,
    String smsCode,
  ) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final UserCredential userCredential = await signInWithPhone(authCredential);
    return userCredential;
  }

  Future<UserCredential> signInWithPhone(AuthCredential credential) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    final User? user = _firebaseAuth.currentUser;
    return user;
  }
}
