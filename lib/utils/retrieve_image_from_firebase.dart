import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class RetrieveImageFromFirebase {
  Future<String> getImage(String imagePath) async {
    String image = '';
    if (imagePath.isNotEmpty) {
      final User? user = FirebaseAuth.instance.currentUser;
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child("user_images/${user?.uid}/");

      final fileName = imagePath.split('/').last; // Extract filename

      try {
        final ref = imagesRef.child(fileName);
        final downloadUrl = await ref.getDownloadURL(); // Check if file exists
        image = downloadUrl;
      } catch (e) {
        final uploadTask = (kIsWeb)
            ? imagesRef.putString(imagePath)
            : imagesRef.putFile(File(imagePath));
        final completedTask = await uploadTask;
        final downloadUrl = await completedTask.ref.getDownloadURL();
        image = downloadUrl;
      }
    }
    return image;
  }
}
