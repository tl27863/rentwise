// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/responsive/mobileScreen.dart';
import 'package:rentwise/responsive/responsive_layout.dart';
import 'package:rentwise/screens/login_screen.dart';
import 'package:rentwise/utils/colors.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "",
        authDomain: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: "",
        measurementId: ""
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  // final fcmToken = await messaging.getToken(/*vapidKey: "BP3gmSB5_K6b8-SSzgvXYSLlIkDvyY1rI-BxTPKtspE3hlIXDCtSeAJB0qfWI4UGYhxS1HGyg2ZMTxG-c0X7KXw"*/);
  // print(fcmToken);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RentWise',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if(snapshot.hasData){
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout()
                  );
                } else if(snapshot.hasError){
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
                break;
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                );
              default:
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
