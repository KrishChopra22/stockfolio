import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockfolio/features/auth/bloc/auth_cubit.dart';
import 'package:stockfolio/features/auth/screens/login_screen.dart';
import 'package:stockfolio/features/home/screens/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkExistsOrNot();
  }

  Future<void> checkExistsOrNot() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = 'null';
    Future.delayed(const Duration(seconds: 5), () async {
      if (prefs.containsKey('currUser_uid')) {
        uid = prefs.getString('currUser_uid')!;
      }
      await context.read<AuthCubit>().checkUserExists(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) async {
          if (state is AuthVerifiedAndRegisteredState) {
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    Dashboard(userModel: state.userModel),
              ),
              (route) => false,
            );
          }
          if (state is AuthNotRegisteredState && context.mounted) {
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen(),
              ),
              (route) => false,
            );
          }
        },
        builder: (BuildContext context, AuthState state) {
          return Center(
            child: Lottie.asset(
              'assets/splash_animation.json',
              frameRate: FrameRate.max,
            ),
          );
        },
      ),
    );
  }
}
