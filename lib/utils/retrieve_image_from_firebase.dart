import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RetrieveImageFromFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageAndGetUrl(String filePath, String cloudPath) async {
    File file = File(filePath);
    final User? user = _auth.currentUser;
    if (user == null) {
      return '';
    }
    try {
      String fileName = filePath.split('/').last;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('userUploads/${user.uid}/$cloudPath/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      uploadTask.snapshotEvents
          .listen((TaskSnapshot snapshot) {}, onError: (e) {});
      try {
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        throw Exception('Upload task failed: $e');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
