import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(
      XFile image, Function(double)? onProgress) async {
    final storageRef = storage.ref('profile_images_buyer/${image.name}');
    final uploadTask = storageRef.putFile(File(image.path));

    uploadTask.snapshotEvents.listen((event) {
      final progress = event.bytesTransferred / event.totalBytes;
      onProgress?.call(progress);
    });

    final snapshot = await uploadTask.whenComplete(() {});

    final downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<String> getProfileUrl(String imageName) async {
    String downloadURL =
        await storage.ref('profile_images/$imageName').getDownloadURL();

    return downloadURL;
  }
}
