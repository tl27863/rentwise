// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentwise/models/board.dart' as model;
import 'package:rentwise/utils/global_variables.dart';

class BoardMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dio = Dio(BaseOptions(baseUrl: apiURL));

  Future<List<model.Board>> getBoardFeed() async{
    final response = await dio.get('/api/request/getboardfeed');
    var res = List<model.Board>.from(response.data.map((x) => model.Board.fromJson(x)));
    return res;
  }

  Future<List<model.Board>> getBoardDetail({
    required String bId
  }) async{
    final response = await dio.post('/api/request/getboarddetail',
      data: {
        'bId': bId
      }
    );

    return List<model.Board>.from(response.data.map((x) => model.Board.fromJson(x)));
  }

  Future<String> sendBoard({
    String? brId,
    required String title,
    required String content
  }) async {
    User currentUser = _auth.currentUser!;
    String res = "Error!";
    try {
      if(title.isNotEmpty && content.isNotEmpty){
        String temp = brId!;

        model.Board board = model.Board(
          bId: "",
          uid: currentUser.uid,
          name: "",
          title: title,
          content: content,
          createdDate: Timestamp.now(),
          updatedDate: Timestamp.now(),
          brId: temp
        );

        await dio.post('/api/post/setboard',
          data: board.toJson()
        );

        res = "success";
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