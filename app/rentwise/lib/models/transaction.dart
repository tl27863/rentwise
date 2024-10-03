import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction{
  final String tId;
  final String rId;
  final String uid;
  final String sId;
  final String title;
  final String destination;
  final String amount;
  final Timestamp dueDate;
  final String photoURL;
  final String status;
  final String name;
  final String roomName;
  final Timestamp createdDate;
  final Timestamp paidDate;
  final Timestamp updatedDate;

  const Transaction({
    required this.tId,
    required this.rId,
    required this.uid,
    required this.sId,
    required this.title,
    required this.destination,
    required this.amount,
    required this.dueDate,
    required this.photoURL,
    required this.updatedDate,
    required this.createdDate,
    required this.paidDate,
    required this.status,
    required this.name,
    required this.roomName
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    tId: json["tId"],
    rId: json["rId"],
    uid: json["uid"],
    sId: json["sId"],
    title: json["title"],
    destination: json["destination"],
    amount: json["amount"],
    dueDate: Timestamp(json["dueDate"]["_seconds"], json["dueDate"]["_nanoseconds"]),
    photoURL: json["photoURL"],
    status: json["status"],
    name: json["name"],
    roomName: json["roomName"],
    createdDate: Timestamp(json["createdDate"]["_seconds"], json["createdDate"]["_nanoseconds"]),
    paidDate: Timestamp(json["paidDate"]["_seconds"], json["paidDate"]["_nanoseconds"]),
    updatedDate: Timestamp(json["updatedDate"]["_seconds"], json["updatedDate"]["_nanoseconds"])
  );

  Map<String, dynamic> toJson() => {
    'tId' : tId,
    'rId': rId,
    'uid': uid,
    'sId' : sId,
    'title': title,
    'destination': destination,
    'amount' : amount,
    'dueDate' : dueDate.toDate().toIso8601String(),
    'photoURL' : photoURL,
    'status': status,
    'paidDate' : paidDate.toDate().toIso8601String()
    // 'updatedDate' : updatedDate
  };
}

class TransactionReceiver{
  final String rId;
  final String uid;
  final String pId;
  final String name;
  final String propertyName;
  final String username;

  const TransactionReceiver({
    required this.rId,
    required this.uid,
    required this.pId,
    required this.name,
    required this.propertyName,
    required this.username
  });

  factory TransactionReceiver.fromJson(Map<String, dynamic> json) => TransactionReceiver(
    rId: json["rId"],
    uid: json["uid"],
    pId: json["pId"],
    name: json["name"],
    propertyName: json["propertyName"],
    username: json["username"]
  );

  // Map<String, dynamic> toJson() => {
  //   'rId' : rId,
  //   'rId': rId,
  //   'uid': uid,
  //   'sId' : sId,
  //   'title': title,
  //   'destination': destination,
  //   'amount' : amount,
  //   'dueDate' : dueDate,
  //   'photoURL' : photoURL
  //   // 'updatedDate' : updatedDate
  // };
}