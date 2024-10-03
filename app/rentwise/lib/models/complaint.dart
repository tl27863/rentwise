import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint{
  final String cId;
  final String rId;
  final String uid;
  final String sId;
  final String title;
  final String content;
  final String cPhotoURL;
  final String pPhotoURL;
  final String status;
  final String name;
  final String roomName;
  final Timestamp createdDate;

  const Complaint({
    required this.cId,
    required this.rId,
    required this.uid,
    required this.sId,
    required this.title,
    required this.content,
    required this.cPhotoURL,
    required this.pPhotoURL,
    required this.createdDate,
    required this.status,
    required this.name,
    required this.roomName
  });

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    cId: json["cId"],
    rId: json["rId"],
    uid: json["uid"],
    sId: json["sId"],
    title: json["title"],
    content: json["content"],
    cPhotoURL: json["cPhotoURL"],
    pPhotoURL: json["pPhotoURL"],
    status: json["status"],
    name: json["name"],
    roomName: json["roomName"],
    createdDate: Timestamp(json["createdDate"]["_seconds"], json["createdDate"]["_nanoseconds"]),
    //updatedDate: Timestamp(json["updatedDate"]["_seconds"], json["updatedDate"]["_nanoseconds"])
  );

  Map<String, dynamic> toJson() => {
    'cId' : cId,
    'rId': rId,
    'uid': uid,
    'sId' : sId,
    'title': title,
    'content': content,
    'cPhotoURL' : cPhotoURL,
    'pPhotoURL' : pPhotoURL,
    'status': status,
    // 'updatedDate' : updatedDate
  };
}

// class ComplaintReceiver{
//   final String rId;
//   final String uid;
//   final String pId;
//   final String name;
//   final String propertyName;
//   final String username;

//   const ComplaintReceiver({
//     required this.rId,
//     required this.uid,
//     required this.pId,
//     required this.name,
//     required this.propertyName,
//     required this.username
//   });

//   factory ComplaintReceiver.fromJson(Map<String, dynamic> json) => ComplaintReceiver(
//     rId: json["rId"],
//     uid: json["uid"],
//     pId: json["pId"],
//     name: json["name"],
//     propertyName: json["propertyName"],
//     username: json["username"]
//   );

//   // Map<String, dynamic> toJson() => {
//   //   'rId' : rId,
//   //   'rId': rId,
//   //   'uid': uid,
//   //   'sId' : sId,
//   //   'title': title,
//   //   'destination': destination,
//   //   'amount' : amount,
//   //   'dueDate' : dueDate,
//   //   'photoURL' : photoURL
//   //   // 'updatedDate' : updatedDate
//   // };
// }