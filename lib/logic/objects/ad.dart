import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String name;
  final String description;
  final double price;
  final String ownerId;
  String imageId;
  final bool verified;
  final bool reserved;
  final Timestamp timestamp;
  final String reservedBy;
  String id;

  Ad(this.name, this.description, this.price, this.ownerId, this.imageId,
      this.timestamp, this.verified, this.reserved, this.reservedBy);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'owner_id': ownerId,
      'image_id': imageId,
      'timestamp': timestamp,
      'verified': verified,
      'reserved': reserved,
      'reserved_by': reservedBy,
    };
  }

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      map['name'],
      map['description'],
      map['price'] is double ? map['price'] : double.tryParse(map['price']),
      map['owner_id'],
      map['image_id'],
      map['timestamp'],
      map['verified'] ?? false,
      map['reserved'] ?? false,
      map['reserved_by'],
    );
  }
}
