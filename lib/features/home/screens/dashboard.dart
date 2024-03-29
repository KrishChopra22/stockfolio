import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/auth/bloc/auth_cubit.dart';
import 'package:stockfolio/features/auth/screens/login_screen.dart';
import 'package:stockfolio/features/home/screens/game_screen.dart';
import 'package:stockfolio/models/user_model.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.userModel, super.key});

  final UserModel userModel;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('StockFolio'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.userModel.uid!),
            Text(widget.userModel.name!),
            Text(widget.userModel.email!),
            Text(widget.userModel.phoneNumber!),
            Text(widget.userModel.bio!),
            Image.network(widget.userModel.profilePic!),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Play Game',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const GameScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocListener<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) async {
          if (state is AuthInitialState) {
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen(),
              ),
              (route) => false,
            );
          }
          if (state is AuthErrorState) {
            showSnackBar(
              context,
              state.error,
            );
          }
        },
        child: CustomButton(
          text: 'LogOut',
          onPressed: () async {
            await context.read<AuthCubit>().logOut();
          },
        ),
      ),
    );
  }
}
