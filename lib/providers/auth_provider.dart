import 'dart:convert';
import 'dart:io';

import 'package:casette/models/user_model.dart';
import 'package:casette/screens/Auth/confirm_screen.dart';
import 'package:casette/widgets/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    _isSignedIn = sf.getBool("is_signedIn") ?? false;
    notifyListeners();
  }

  Future saveSignIn() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setBool("is_signedIn", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ConfirmationScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message.toString(),
      );
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );
      User? user = (await firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message.toString(),
      );
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  void saveUserToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await storeImage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.joinedAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = firebaseAuth.currentUser!.uid;
      });
      _userModel = userModel;
      await firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future getUserFromFirestore() async {
    await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot["name"],
        email: snapshot["email"],
        profilePic: snapshot["profilePic"],
        joinedAt: snapshot["joinedAt"],
        uid: snapshot["uid"],
        phoneNumber: snapshot["phoneNumber"],
      );
      _uid = userModel.uid;
    });
  }

  Future<String> storeImage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future saveUserDataLocally() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.setString(
      "user_model",
      jsonEncode(
        userModel.toMap(),
      ),
    );
  }

  Future getUserFromLocal() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String data = sf.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(
      jsonDecode(data),
    );
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future signOut() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    await firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    sf.clear();
  }
}
