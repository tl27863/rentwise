//import 'package:flutter/foundation.dart';
// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:rentwise/models/complaint.dart' as model;
import 'package:rentwise/resources/upload_methods.dart';
import 'package:rentwise/utils/global_variables.dart';

class ComplaintMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dio = Dio(BaseOptions(baseUrl: apiURL));

  Future<List<model.Complaint>> getComplaintFeed() async {
    User currentUser = _auth.currentUser!;
    final response = await dio.post('/api/request/complaintfeed',
      data: {
        'uid': currentUser.uid
      }
    );
    //print(response.data.toString());
    var res = List<model.Complaint>.from(response.data.map((x) => model.Complaint.fromJson(x)));
    return res;
  }  

  Future<model.Complaint> getComplaint({
    required String cId
  }) async {
    final response = await dio.post('/api/request/getcomplaint',
      data: {
        'cId': cId
      }
    );
    //print(response.data.toString());
    //var res = List<model.Complaint>.from(response.data.map((x) => model.Complaint.fromJson(x)));
    return model.Complaint.fromJson(response.data);
  }  

  Future<String> processComplaint({
    required String cId,
    required String status,
    Uint8List? file
  }) async {
    String res = "Error!";
    try {
      if(cId.isNotEmpty && status.isNotEmpty){
        String photoURL;
        if(file == null){
          photoURL = "";
        } else {
          photoURL = await UploadMethods().uploadImageToStorage('complaintImage', cId, file);
        }
        await dio.post('/api/post/processcomplaint',
          data: {
            'cId': cId,
            'status': status,
            'pPhotoURL': photoURL
          }
        );
      }
      res = 'success';
    } on DioException catch(e) {
        if (e.response != null) {
          print(e.response?.data);
          print(e.response?.headers);
          print(e.response?.requestOptions);
        } else {
          print(e.requestOptions);
          print(e.message);
        }
    }
    return res;
  }  

  Future<String> createComplaint({
    required String title,
    required String content,
    required Uint8List file
  }) async {
    String res = "Error!";
    try {
      if(title.isNotEmpty && content.isNotEmpty){
        User currentUser = _auth.currentUser!;
        String photoUrl = await UploadMethods().uploadImageToStorage('complaintImage', currentUser.uid, file);

        model.Complaint transaction = model.Complaint(
          cId: "",
          rId: "",
          uid: "",
          sId: currentUser.uid,
          title: title,
          content: content,
          cPhotoURL: photoUrl,
          pPhotoURL: "",
          status: "",
          name: "",
          roomName: "",
          createdDate: Timestamp.now()
        );

        await dio.post('/api/post/sendcomplaint',
          data: transaction.toJson()
        );

        res = 'success';
      } else {
        res = 'Fields must be filled!';
      }
    } on DioException catch(e) {
        if (e.response != null) {
          print(e.response?.data);
          print(e.response?.headers);
          print(e.response?.requestOptions);
          Map<String, dynamic> json = e.response?.data;
          res = json["message"];
        } else {
          print(e.requestOptions);
          print(e.message);
        }
    }
    return res;
  }
}