//import 'package:flutter/foundation.dart';
// ignore_for_file: avoid_print

// import 'dart:typed_data';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:rentwise/models/transaction.dart' as model;
import 'package:rentwise/resources/upload_methods.dart';
import 'package:rentwise/utils/global_variables.dart';
// import 'package:rentwise/resources/upload_methods.dart';

class TransactionMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dio = Dio(BaseOptions(baseUrl: apiURL));

  Future<List<model.TransactionReceiver>> getTransactionTenant() async {
    User currentUser = _auth.currentUser!;
    final response = await dio.post('/api/request/gettransactiontenant',
      data: {
        'uid': currentUser.uid
      }
    );

    var res = List<model.TransactionReceiver>.from(response.data.map((x) => model.TransactionReceiver.fromJson(x)));
    return res;
  }  

  Future<model.Transaction> getTransaction({
    required String tId
  }) async {
    final response = await dio.post('/api/request/gettransaction',
      data: {
        'tId': tId
      }
    );

    //var res = List<model.TransactionReceiver>.from(response.data.map((x) => model.TransactionReceiver.fromJson(x)));
    return model.Transaction.fromJson(response.data);
  }  

  Future<List<model.Transaction>> getTransactionFeed() async {
    User currentUser = _auth.currentUser!;
    final response = await dio.post('/api/request/transactionfeed',
      data: {
        'uid': currentUser.uid
      }
    );

    var res = List<model.Transaction>.from(response.data.map((x) => model.Transaction.fromJson(x)));
    return res;
  }  

  Future<String> processTransaction({
    required String tId,
    required String status,
    Uint8List? file
  }) async {
    String res = "Error!";
    try {
      if(tId.isNotEmpty && status.isNotEmpty){
        String photoURL = "";
        if(status == "Awaiting Confirmation"){
          if(file == null){
            res = "Image must be submitted!";
            return res;
          } else {
            photoURL = await UploadMethods().uploadImageToStorage('transactionImage', tId, file);
          }
        }
        await dio.post('/api/post/processtransaction',
          data: {
            'tId': tId,
            'status': status,
            'photoURL': photoURL
          }
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
        } else {
          print(e.requestOptions);
          print(e.message);
        }
    }
    return res;
  }  

  Future<String> createTransaction({
    required String rId,
    required String uid,
    required String title,
    required String destination,
    required String amount,
    required DateTime dueDate
  }) async {
    String res = "Error!";
    try {
      if(rId.isNotEmpty && uid.isNotEmpty && title.isNotEmpty && destination.isNotEmpty && amount.isNotEmpty){
        User currentUser = _auth.currentUser!;

        var tDueDate = Timestamp.fromDate(dueDate);

        model.Transaction transaction = model.Transaction(
          tId: "",
          rId: rId,
          uid: uid,
          sId: currentUser.uid,
          title: title,
          destination: destination,
          amount: amount,
          dueDate: tDueDate,
          photoURL: "",
          status: "",
          name: "",
          roomName: "",
          createdDate: Timestamp.now(), 
          paidDate: Timestamp.now(), 
          updatedDate: Timestamp.now(), 
        );

        await dio.post('/api/post/sendtransaction',
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
        } else {
          print(e.requestOptions);
          print(e.message);
        }
    }
    return res;
  }

  // Future<String> updateRoom({
  //   required String rId,
  //   required String pId,
  //   required String uid,
  //   required String name,
  //   required String price,
  //   required String floor,
  //   required String description,
  //   Uint8List? file
  // }) async {
  //   String res = "Error!";
  //   try {
  //     if(pId.isNotEmpty && name.isNotEmpty && price.isNotEmpty && floor.isNotEmpty && description.isNotEmpty){
  //       String photoURL;
  //       if(file == null){
  //         photoURL = "";
  //       } else {
  //         photoURL = await UploadMethods().uploadImageToStorage('roomImage', pId, file);
  //       }
        
  //       model.Room room = model.Room(
  //         rId: rId,
  //         pId: pId,
  //         uid: uid,
  //         name: name,
  //         price: price,
  //         floor: floor,
  //         description: description,
  //         photoURL: photoURL,
  //         updatedDate: Timestamp.now()
  //       );

  //       await dio.post('http://localhost:3000/api/post/setroom',
  //         data: room.toJson()
  //       );
  //       res = 'success';
  //     } else {
  //       res = 'Fields must be filled!';
  //     }
  //   } on DioException catch(e) {
  //       if (e.response != null) {
  //         print(e.response?.data);
  //         print(e.response?.headers);
  //         print(e.response?.requestOptions);
  //       } else {
  //         print(e.requestOptions);
  //         print(e.message);
  //       }
  //   }
  //   return res;
  // }
}