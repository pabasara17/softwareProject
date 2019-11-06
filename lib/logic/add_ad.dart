import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jwel_smart/logic/objects/ad.dart';
import 'package:uuid/uuid.dart';

class AddAd {
  static Future<void> addAd(Ad ad, File image) async {
    if (image != null) {
      String fileName = Uuid().v4();
      final StorageReference storageReference =
          FirebaseStorage().ref().child("ads").child(fileName);

      final StorageUploadTask uploadTask =
          storageReference.putData(image.readAsBytesSync());
      await uploadTask.onComplete;
      ad.imageId = fileName;
    }
    await Firestore.instance.collection('Ads').add(ad.toMap());
  }
}
