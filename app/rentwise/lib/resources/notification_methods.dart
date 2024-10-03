// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:rentwise/models/notification.dart' as model;
import 'package:rentwise/utils/global_variables.dart';

class NotificationMethods{
  final dio = Dio(BaseOptions(baseUrl: apiURL));

  Future<String> sendNotification({
    required String uid,
    required String title,
    required String content
  }) async {
    String res = "Error!";
    try {
      if(uid.isNotEmpty && title.isNotEmpty && content.isNotEmpty){

        model.Notification notification = model.Notification(
          uid: uid,
          title: title,
          content: content
        );

        await dio.post('/api/ns/user',
          data: notification.toJson()
        );

        res = 'success';
      } else if(title.isNotEmpty && content.isNotEmpty){

        model.Notification notification = model.Notification(
          title: title,
          content: content, 
          uid: ''
        );

        await dio.post('/api/ns/all',
          data: notification.toJson()
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