import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class RetrieveImageFromFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getImage(String imagePath) async {
    String imageUrl = '';
    if (imagePath.isEmpty) {
      return imageUrl;
    }

    final User? user = _auth.currentUser;
    if (user == null) {
      return imageUrl;
    } else {}

    final Reference storageRef = _storage.ref('user_images/${user.uid}/');
    final String fileName = imagePath.split('/').last;

    try {
      final Reference fileRef = storageRef.child(fileName);
      imageUrl = await fileRef.getDownloadURL();
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        try {
          imageUrl =
              await _uploadAndRetrieveImage(storageRef, fileName, imagePath);
        } catch (uploadError) {}
      } else {}
    }

    return imageUrl;
  }

  Future<String> _uploadAndRetrieveImage(
      Reference storageRef, String fileName, String localPath) async {
    TaskSnapshot task;
    if (kIsWeb) {
      task = await storageRef.child(fileName).putString(localPath);
    } else {
      task = await storageRef.child(fileName).putFile(File(localPath));
    }
    final String downloadUrl = await task.ref.getDownloadURL();
    return downloadUrl;
  }
}
