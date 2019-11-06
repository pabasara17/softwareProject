import 'package:cloud_firestore/cloud_firestore.dart';

import 'objects/ad.dart';
import 'objects/user.dart';

class Reserve {
  static Future<void> reserve(Ad ad, String userId) async {
    await Firestore.instance
        .collection('Ads')
        .document(ad.id)
        .updateData({'reserved': true, 'reserved_by': userId});
  }

  static Future<void> unreserve(Ad ad, String userId) async {
    await Firestore.instance
        .collection('Ads')
        .document(ad.id)
        .updateData({'reserved': false, 'reserved_by': null});
  }

  static Future<User> getReservedUser(Ad ad) async {
    final doc = await Firestore.instance
        .collection('Users')
        .document(ad.reservedBy)
        .get();
    return User.fromMap(doc.data);
  }
}
