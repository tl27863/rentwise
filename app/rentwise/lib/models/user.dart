// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String uid;
  final String email;
  final String username;
  final String phoneNumber;
  final String FCMToken;
  final bool isManager;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.FCMToken,
    required this.isManager
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    phoneNumber: json["phoneNumber"],
    FCMToken: json["FCMToken"],
    isManager: json["isManager"],
    email: json["email"],
    username: json["username"],
    uid: json["uid"]
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'phoneNumber': phoneNumber,
    'FCMToken' : FCMToken,
    'isManager' : isManager
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
      FCMToken: snapshot['FCMToken'],
      isManager: snapshot['isManager']
    );
  }
}