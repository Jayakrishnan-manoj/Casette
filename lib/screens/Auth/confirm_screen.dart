import 'package:casette/providers/auth_provider.dart';
import 'package:casette/screens/Presentation/home_screen.dart';
import 'package:casette/widgets/reusables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import 'new_user_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key, required this.verificationId});
  final verificationId;

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String? otpNumber;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: kAppBarColor,
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: kAppBarColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        "assets/login-image.png",
                        height: 200,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Confirm OTP",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          color: kAppBarColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Enter the OTP sent to your phone",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          color: kAppBarColor,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Pinput(
                        length: 6,
                        showCursor: true,
                        onCompleted: (value) {
                          setState(() {
                            otpNumber = value;
                          });
                        },
                        defaultPinTheme: PinTheme(
                          textStyle: const TextStyle(
                            color: kAppBarColor,
                            fontSize: 20,
                          ),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kAppBarColor, width: 1.2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (otpNumber != null) {
                              verifyOTP(context, otpNumber!);
                            } else {
                              showSnackBar(context, "Enter valid OTP");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAppBarColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Text(
                            "Confirm OTP",
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Didn't receive code?",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black38,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () {},
                              text: " Resend code",
                              style: const TextStyle(
                                color: kAppBarColor,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void verifyOTP(BuildContext context, String userOTP) {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    auth.verifyOTP(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOTP,
      onSuccess: () {
        auth.checkExistingUser().then((value) async {
          if (value == true) {
            auth.getUserFromFirestore().then(
                  (value) => auth.saveUserDataLocally().then(
                        (value) => auth.saveSignIn().then(
                              (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (route) => false),
                            ),
                      ),
                );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const NewUserScreen(),
                ),
                (route) => false);
          }
        });
      },
    );
  }
}
