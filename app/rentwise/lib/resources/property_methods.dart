//import 'package:flutter/foundation.dart';
// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:rentwise/models/property.dart' as model;
import 'package:rentwise/resources/upload_methods.dart';
import 'package:rentwise/utils/global_variables.dart';

class PropertyMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dio = Dio(BaseOptions(baseUrl: apiURL));

  Future<List<model.Room>> getPropertyDetails({
    required String pId
  }) async {
    final response = await dio.post('/api/request/getpropertyroom',
      data: {
        'pId': pId,
        'uid': ""
      }
    );

    return List<model.Room>.from(response.data.map((x) => model.Room.fromJson(x)));
  }

  Future<List<model.Room>> getPropertyDetailsTenant({
    required String pId
  }) async {
    User currentUser = _auth.currentUser!;
    final response = await dio.post('/api/request/getpropertyroom',
      data: {
        'pId': pId,
        'uid': currentUser.uid
      }
    );

    return List<model.Room>.from(response.data.map((x) => model.Room.fromJson(x)));
  }

  Future<model.Property> getPropertyTenant() async{
    User currentUser = _auth.currentUser!;

    final response = await dio.post('/api/request/getpropertytenant',
      data: {
        'uid': currentUser.uid
      });

    return model.Property.fromJson(response.data);
  }

  Future<List<model.Property>> getPropertyFeed() async{
    User currentUser = _auth.currentUser!;

    final response = await dio.post('/api/request/getpropertyfeed',
      data: {
        'uid': currentUser.uid
      });

    return List<model.Property>.from(response.data.map((x) => model.Property.fromJson(x)));
  }

  Future<String> createProperty({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    required Uint8List file
  }) async {
    String res = "Error!";
    try {
      if(email.isNotEmpty && address.isNotEmpty && name.isNotEmpty && phoneNumber.isNotEmpty){
        User currentUser = _auth.currentUser!;

        model.Property property = model.Property(
          pId: "",
          uid: currentUser.uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          address: address,
          photoURL: "", 
          updatedDate: Timestamp.now()
        );

        var response = await dio.post('/api/post/setproperty',
          data: property.toJson()
        );

        Map<String, dynamic> json = response.data;
        var pId = json["id"];

        String photoURL = await UploadMethods().uploadImageToStorage('propertyImage', pId, file);
        print(pId);
        print(photoURL);
        model.Property updateProperty = model.Property(
          pId: pId,
          uid: currentUser.uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          address: address,
          photoURL: photoURL, 
          updatedDate: Timestamp.now()
        );
        await dio.post('/api/post/setproperty',
          data: updateProperty.toJson()
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

  Future<String> updateProperty({
    required String pId,
    required String uid,
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    Uint8List? file
  }) async {
    String res = "Error!";
    try {
      if(pId.isNotEmpty && uid.isNotEmpty && email.isNotEmpty && address.isNotEmpty && name.isNotEmpty && phoneNumber.isNotEmpty){
        String photoURL;
        if(file == null){
          photoURL = "";
        } else {
          photoURL = await UploadMethods().uploadImageToStorage('propertyImage', pId, file);
        }
        
        model.Property property = model.Property(
          pId: pId,
          uid: uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          address: address,
          photoURL: photoURL, 
          updatedDate: Timestamp.now()
        );

        await dio.post('/api/post/setproperty',
          data: property.toJson()
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
}