import 'package:casette/constants/constants.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController phoneController = TextEditingController();

  Country country = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register",
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
              "Enter your phone number. We'll send you a verification code",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: kAppBarColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: kAppBarColor,
              controller: phoneController,
              onChanged: (value) {
                setState(() {
                  phoneController.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter phone number",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: kAppBarColor,
                    width: 2,
                  ),
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                        countryListTheme: const CountryListThemeData(
                          bottomSheetHeight: 500,
                        ),
                        context: context,
                        onSelect: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                      );
                    },
                    child: Text(
                      "${country.flagEmoji} +${country.phoneCode}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kAppBarColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                suffixIcon: phoneController.text.length > 9
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 25,
                      )
                    : null,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OTPScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAppBarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  "SEND OTP",
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
