import 'package:cloud_firestore/cloud_firestore.dart';

class Board{
  final String bId;
  final String uid;
  final String name;
  final String title;
  final String content;
  final Timestamp createdDate;
  final Timestamp updatedDate;
  final String brId;

  const Board({
    required this.bId,
    required this.uid,
    required this.name,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.updatedDate,
    required this.brId
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    bId: json["bId"],
    uid: json["uid"],
    name: json["name"],
    title: json["title"],
    content: json["content"],
    createdDate: Timestamp(json["createdDate"]["_seconds"], json["createdDate"]["_nanoseconds"]),
    updatedDate: Timestamp(json["updatedDate"]["_seconds"], json["updatedDate"]["_nanoseconds"]),
    brId: json["brId"]
  );

  Map<String, dynamic> toJson() => {
    'bId': bId,
    'uid': uid,
    'name': name,
    'title': title,
    'content': content,
    'brId': brId
    // 'updatedDate' : updatedDate
  };
}
