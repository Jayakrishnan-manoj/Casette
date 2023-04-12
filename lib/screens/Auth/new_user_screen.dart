import 'dart:io';

import 'package:casette/constants/constants.dart';
import 'package:casette/models/user_model.dart';
import 'package:casette/providers/auth_provider.dart';
import 'package:casette/screens/Presentation/home_screen.dart';
import 'package:casette/widgets/reusables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: false).isLoading;
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 10,
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: kAppBarColor,
                  )
                : Column(
                    children: [
                      InkWell(
                        onTap: () => selectImage(),
                        child: image == null
                            ? const CircleAvatar(
                                radius: 60,
                                backgroundColor: kAppBarColor,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(
                                  image!,
                                ),
                                radius: 60,
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Column(
                          children: [
                            textField(
                              controller: nameController,
                              icon: Icons.account_circle,
                              hintText: "Name",
                              inputType: TextInputType.name,
                              maxLines: 1,
                            ),
                            textField(
                                controller: emailController,
                                icon: Icons.email,
                                hintText: "Email",
                                inputType: TextInputType.emailAddress,
                                maxLines: 1),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => storeData(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAppBarColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Text(
                            "Register",
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              letterSpacing: 2,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void storeData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      profilePic: "",
      joinedAt: "",
      uid: "",
      phoneNumber: "",
    );
    if (image != null) {
      auth.saveUserToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          auth.saveUserDataLocally().then(
                (value) => auth.saveSignIn().then(
                      (value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      ),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }
}
