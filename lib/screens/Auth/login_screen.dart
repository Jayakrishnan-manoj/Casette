import 'package:casette/providers/auth_provider.dart';
import 'package:casette/screens/Auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:casette/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Presentation/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "CASETTE",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: kAppBarColor,
                fontSize: 50,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            'assets/loginImage.png',
            height: 250,
          ),
          const SizedBox(
            height: 120,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (Auth.isSignedIn == true) {
                  
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OTPScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAppBarColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                "Login",
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
