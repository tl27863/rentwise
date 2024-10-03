// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:rentwise/models/user.dart' as model;
import 'package:rentwise/utils/global_variables.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dio = Dio(BaseOptions(baseUrl: apiURL));
  
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    final response = await dio.post('/api/user/getaccount',
      data: {
        'uid': currentUser.uid
      }
    );
    
    return model.User.fromJson(response.data);
  }

  Future<model.User> getTenantDetails({
    required String uid
  }) async {
    final response = await dio.post('/api/user/getaccount',
      data: {
        'uid': uid
      }
    );
    
    return model.User.fromJson(response.data);
  }

  Future<List<model.User>> getTenant() async{
    final response = await dio.post('/api/user/gettenant');
    var res = List<model.User>.from(response.data.map((x) => model.User.fromJson(x)));
    //res.add(const model.User(uid: "", email: "", username: "Vacant", phoneNumber: "", FCMToken: "", isManager: false));
    //print(res.first.uid);
    return res;
  }

  Future<void> refreshFCMToken() async {
    String token;
    if(kIsWeb){
      final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BP3gmSB5_K6b8-SSzgvXYSLlIkDvyY1rI-BxTPKtspE3hlIXDCtSeAJB0qfWI4UGYhxS1HGyg2ZMTxG-c0X7KXw");
      token = fcmToken!;
    } else {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      token = fcmToken!;
    }

    await dio.post('/api/user/refreshfcm',
      data: {
        'uid': _auth.currentUser!.uid,
        'FCMToken': token
      }
    );
  }

  Future<String> updateUser({
    required String username,
    required String phoneNumber
  }) async {
    String res = "Error!";
    try {
      if(username.isNotEmpty && phoneNumber.isNotEmpty){

        await dio.post('/api/user/update',
          data: {
            'uid': _auth.currentUser!.uid,
            'username': username,
            'phoneNumber': phoneNumber
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

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required bool isManager
  }) async {
    String res = "Error!";
    try {
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && phoneNumber.isNotEmpty){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String token;
      if(kIsWeb){
        final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BP3gmSB5_K6b8-SSzgvXYSLlIkDvyY1rI-BxTPKtspE3hlIXDCtSeAJB0qfWI4UGYhxS1HGyg2ZMTxG-c0X7KXw");
        token = fcmToken!;
      } else {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        token = fcmToken!;
      }

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          isManager: isManager,
          FCMToken: token
        );

        await dio.post('/api/user/register',
          data: user.toJson()
        );
        res = 'success';
      } else {
        res = 'Fields must be filled!';
      }
    } on FirebaseAuthException catch(err) {
      switch (err.code) {
        case 'invalid-email':
          res = 'Email is invalid!';
          break;
        case 'weak-password':
          res = 'Password must be atleast 6 characters!';
          break;
        default:
          res = err.toString();
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

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = 'Error!';
    try {
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        refreshFCMToken();
        res = 'success';
      } else {
        res = 'Please enter the email and password!';
      }
    } on FirebaseAuthException catch(err) {
      switch (err.code) {
        case 'wrong-password':
          res = 'Password is Incorrect!';
          break;
        case 'user-not-found':
          res = 'Account doesnt exist!';
          break;
        default:
          res = err.toString();
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}