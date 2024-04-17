import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/dashboard/screens/dashboard.dart';
import 'package:stockfolio/features/user_registration/bloc/user_cubit.dart';
import 'package:stockfolio/models/user_model.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({required this.phoneNumber, super.key});

  final String phoneNumber;

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  // for selecting image
  Future<void> selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  'Please enter your details...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async => selectImage(),
                  child: image == null
                      ? CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade400,
                          radius: 50,
                          child: const Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 50,
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      // name field
                      CustomTextField(
                        hintText: 'eg: John Smith',
                        labelText: 'Full Name',
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      CustomTextField(
                        hintText: 'eg: abc@example.com',
                        labelText: 'Email Address',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),

                      // bio
                      CustomTextField(
                        hintText: '\nEnter your bio here...',
                        labelText: 'About me',
                        icon: Icons.edit,
                        inputType: TextInputType.name,
                        maxLines: 3,
                        controller: bioController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<UserCubit, UserState>(
                  listener: (BuildContext context, UserState state) async {
                    if (state is UserErrorState) {
                      showSnackBar(context, state.error);
                    }
                    if (state is UserDataSavedState) {
                      await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Dashboard(
                            userModel: state.userModel,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  builder: (BuildContext context, UserState state) {
                    if (state is UserLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () async {
                          final UserModel userModel = UserModel(
                            uid: '',
                            name: nameController.text.trim(),
                            phoneNumber: widget.phoneNumber,
                            email: emailController.text.trim(),
                            bio: bioController.text.trim(),
                            profilePic: '',
                          );
                          await context
                              .read<UserCubit>()
                              .saveUserDataToFirebase(userModel, image!);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
