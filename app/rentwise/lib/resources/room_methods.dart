//import 'package:flutter/foundation.dart';
// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:rentwise/models/property.dart' as model;
import 'package:rentwise/resources/upload_methods.dart';
import 'package:rentwise/utils/global_variables.dart';

class RoomMethods{
  final dio = Dio(BaseOptions(baseUrl: apiURL));
  
  Future<String> createRoom({
    required String pId,
    required String uid,
    required String name,
    required String price,
    required String floor,
    required String description,
    required Uint8List file
  }) async {
    String res = "Error!";
    try {
      if(pId.isNotEmpty && name.isNotEmpty && price.isNotEmpty && floor.isNotEmpty && description.isNotEmpty){

        model.Room room = model.Room(
          rId: "",
          pId: pId,
          uid: uid,
          name: name,
          price: price,
          floor: floor,
          description: description,
          photoURL: "",
          updatedDate: Timestamp.now()
        );

        var response = await dio.post('/api/post/setroom',
          data: room.toJson()
        );

        Map<String, dynamic> json = response.data;
        String rId = json["id"];

        String photoURL = await UploadMethods().uploadImageToStorage('roomImage', rId, file);
        print(rId);
        print(photoURL);
        model.Room updateRoom = model.Room(
          rId: rId,
          pId: pId,
          uid: uid,
          name: name,
          price: price,
          floor: floor,
          description: description,
          photoURL: photoURL,
          updatedDate: Timestamp.now()
        );

        await dio.post('/api/post/setroom',
          data: updateRoom.toJson()
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

  Future<String> updateRoom({
    required String rId,
    required String pId,
    required String uid,
    required String name,
    required String price,
    required String floor,
    required String description,
    Uint8List? file
  }) async {
    String res = "Error!";
    try {
      //print("whatthefuck");
      if(pId.isNotEmpty && name.isNotEmpty && price.isNotEmpty && floor.isNotEmpty && description.isNotEmpty){
        String photoURL;
        if(file == null){
          photoURL = "";
        } else {
          photoURL = await UploadMethods().uploadImageToStorage('roomImage', pId, file);
        }
        
        model.Room room = model.Room(
          rId: rId,
          pId: pId,
          uid: uid,
          name: name,
          price: price,
          floor: floor,
          description: description,
          photoURL: photoURL,
          updatedDate: Timestamp.now()
        );

        await dio.post('/api/post/setroom',
          data: room.toJson()
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

  Future<model.Room> getRoom({
    required String rId
  }) async {
    final response = await dio.post('/api/request/getroom',
      data: {
        'rId': rId
      }
    );

    return model.Room.fromJson(response.data);
  }
}