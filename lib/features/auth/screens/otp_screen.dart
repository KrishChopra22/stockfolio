import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:stockfolio/features/auth/bloc/auth_cubit.dart';
import 'package:stockfolio/features/dashboard/screens/dashboard.dart';
import 'package:stockfolio/features/user_registration/screens/user_registration_screen.dart';
import 'package:stockfolio/utils/Colors.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue,
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 80),
                    child: Column(
                      children: <Widget>[
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: GestureDetector(
                        //     onTap: () => Navigator.of(context).pop(),
                        //     child: const Icon(Icons.arrow_back),
                        //   ),
                        // ),
                        const SizedBox(height: 260),
                        const Text(
                          'Verification',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Enter the OTP sent to your phone number',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          defaultPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.blue,
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (String value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener:
                              (BuildContext context, AuthState state) async {
                            if (state is AuthOtpCodeVerifiedState) {
                              showSnackBar(
                                context,
                                'Otp has been verified',
                              );
                            }
                            if (state is AuthVerifiedAndRegisteredState) {
                              await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Dashboard(userModel: state.userModel),
                                ),
                                (route) => false,
                              );
                            }
                            if (state is AuthVerifiedButNotRegisteredState &&
                                context.mounted) {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserRegistrationScreen(
                                    phoneNumber: state.phoneNumber,
                                  ),
                                ),
                              );
                            }
                            if (state is AuthErrorState && context.mounted) {
                              showSnackBar(
                                context,
                                state.error,
                              );
                            }
                          },
                          builder: (BuildContext context, AuthState state) {
                            if (state is AuthLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: CustomButton(
                                text: 'Verify',
                                onPressed: () async {
                                  if (otpCode != null) {
                                    await context
                                        .read<AuthCubit>()
                                        .verifyOtp(otpCode!);
                                  } else {
                                    showSnackBar(
                                      context,
                                      'Please enter a 6-Digit Code',
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Didn't receive any code?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Resend New Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
