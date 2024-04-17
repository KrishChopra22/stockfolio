import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/auth/bloc/auth_cubit.dart';
import 'package:stockfolio/features/auth/screens/otp_screen.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';

import '../../../utils/Colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = CountryParser.parseCountryCode('IN');

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 80),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 300),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Add your phone number. We'll send you a verification code",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (_) {
                      setState(() {});
                      if (phoneController.text.length == 10) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                    onTapOutside: (PointerDownEvent event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    maxLength: 10,
                    cursorColor: Colors.black54,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter phone number',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        width: 90,
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 450,
                              ),
                              onSelect: (Country value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                            );
                          },
                          child: Text(
                            ' ''${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}''',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: phoneController.text.length == 10
                          ? Icon(
                              Icons.done,
                              color: Colors.greenAccent.shade700,
                              size: 30,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (BuildContext context, AuthState state) async {
                      if (state is AuthOtpCodeSentState) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const OtpScreen(),
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
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text: 'Login',
                          onPressed: () async {
                            if (phoneController.text.length < 10) {
                              showSnackBar(
                                context,
                                'Please enter a 10-Digit mobile number',
                              );
                            } else {
                              await context.read<AuthCubit>().sendOtp(
                                '''+${selectedCountry.phoneCode}${phoneController.text.trim()}''',
                              );
                            }
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
      ),
    );
  }
}
