// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Property{
  final String pId;
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String photoURL;
  final Timestamp updatedDate;

  const Property({
    required this.pId,
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.photoURL,
    required this.updatedDate
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    pId: json["pId"],
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    photoURL: json["photoURL"],
    updatedDate: Timestamp(json["updatedDate"]["_seconds"], json["updatedDate"]["_nanoseconds"])
  );

  Map<String, dynamic> toJson() => {
    'pId': pId,
    'uid': uid,
    'name': name,
    'email': email,
    'phoneNumber' : phoneNumber,
    'address' : address,
    'photoURL' : photoURL
    // 'updatedDate' : updatedDate
  };
}

class Room{
  final String rId;
  final String pId;
  final String uid;
  final String name;
  final String price;
  final String floor;
  final String description;
  final String photoURL;
  final Timestamp updatedDate;

  const Room({
    required this.rId,
    required this.pId,
    required this.uid,
    required this.name,
    required this.price,
    required this.floor,
    required this.description,
    required this.photoURL,
    required this.updatedDate
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    rId: json["rId"],
    pId: json["pId"],
    uid: json["uid"],
    name: json["name"],
    price: json["price"],
    floor: json["floor"],
    description: json["description"],
    photoURL: json["photoURL"],
    updatedDate: Timestamp(json["updatedDate"]["_seconds"], json["updatedDate"]["_nanoseconds"])
  );

  Map<String, dynamic> toJson() => {
    'rId': rId,
    'pId': pId,
    'uid': uid,
    'name': name,
    'price': price,
    'floor' : floor,
    'description' : description,
    'photoURL' : photoURL
    //'updatedDate' : updatedDate
  };
}

class PropertyDetails{
  final Property property;
  final List<Room>? room;

  const PropertyDetails({
    required this.property,
    this.room
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) => PropertyDetails(
    property: Property.fromJson(json["property"]),
    room: List<Room>.from(json["room"].map((x) => Room.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    'property' : property.toJson(),
    'room' : List<Room>.from(room!.map((x) => x.toJson()))
  };
}