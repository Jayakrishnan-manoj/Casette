import 'dart:io';

import 'package:casette/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Widget textField({
  required String hintText,
  required IconData icon,
  required TextInputType inputType,
  required int maxLines,
  required TextEditingController controller,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: kAppBarColor,
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        alignLabelWithHint: true,
        fillColor: kAppBarColor.withOpacity(0.7),
        filled: true,
      ),
    ),
  );
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}
