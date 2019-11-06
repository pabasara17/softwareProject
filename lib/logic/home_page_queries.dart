import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jwel_smart/logic/objects/ad.dart';

class HomePageQueries {
  static Stream<List<Ad>> recent() {
    return Firestore.instance
        .collection('Ads')
        .orderBy('timestamp', descending: true)
        .where('reserved', isEqualTo: false)
        .snapshots()
        .map((v) => v.documents
            .map((w) => Ad.fromMap(w.data)..id = w.documentID)
            .toList());
  }

  static Stream<List<Ad>> myAds(String currentUserId) {
    return Firestore.instance
        .collection('Ads')
        .where('owner_id', isEqualTo: currentUserId)
        .snapshots()
        .map((v) => v.documents
            .map((w) => Ad.fromMap(w.data)..id = w.documentID)
            .toList());
  }

  static Stream<List<Ad>> myReservedAds(String currentUserId) {
    return Firestore.instance
        .collection('Ads')
        .where('reserved_by', isEqualTo: currentUserId)
        .snapshots()
        .map((v) => v.documents
            .map((w) => Ad.fromMap(w.data)..id = w.documentID)
            .toList());
  }

  static Future<String> getImageUrl(Ad ad) async {
    if (ad.imageId == null) {
      return null;
    }

    final StorageReference storageReference =
        FirebaseStorage().ref().child("ads").child(ad.imageId);
    return await storageReference.getDownloadURL();
  }
}
