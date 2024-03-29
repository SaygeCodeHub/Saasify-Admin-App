import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RetrieveImageFromFirebase {
  Future<String> getImage(String imagePath) async {
    String image = '';
    User? user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("user_images/${user?.uid}/");
    final uploadTask = imagesRef.putFile(File(imagePath));
    final completedTask = await uploadTask;
    final downloadUrl = await completedTask.ref.getDownloadURL();
    image = downloadUrl;
    return image;
  }
}
