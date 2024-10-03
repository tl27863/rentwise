// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentwise/models/dashboard.dart' as model;
import 'package:rentwise/utils/global_variables.dart';

class DashboardMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dio = Dio(BaseOptions(baseUrl: apiURL));

  Future<model.MDashboardData> getMDashboard() async{
    User currentUser = _auth.currentUser!;
    final response = await dio.post('/api/request/getdashboardmanager',
      data: {
        'uid': currentUser.uid
      }
    );

    return model.MDashboardData.fromJson(response.data);
  }

  Future<model.TDashboardData> getTDashboard() async{
    User currentUser = _auth.currentUser!;
    final response = await dio.post('/api/request/getdashboardtenant',
      data: {
        'uid': currentUser.uid
      }
    );

    return model.TDashboardData.fromJson(response.data);
  }

}