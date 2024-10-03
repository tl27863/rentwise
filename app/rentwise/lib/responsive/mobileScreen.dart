import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/global_variables.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/models/user.dart' as model;
import 'package:rentwise/utils/utils.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if(!kIsWeb){
        showSnackBar('(${notification?.title}) ${notification?.body}', context);
      }
    });

    return (user == null) ?
    const Center(child: CircularProgressIndicator(),)
    :
    Scaffold(
      //backgroundColor: mainBackgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: user.isManager ? 
        homeScreenManagerItems
        :
        homeScreenTenantItems,
      ),
      bottomNavigationBar: user.isManager ? CupertinoTabBar(
        height: 60,
        backgroundColor: primaryColor,
        border: const Border(top: BorderSide(style: BorderStyle.none)),
        iconSize: 35,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home , color: _page == 0 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment , color: _page == 1 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt , color: _page == 2 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign , color: _page == 3 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add , color: _page == 4 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum , color: _page == 5 ? bgColor : tabIcon),
          ),
        ],
        onTap: navigationTap,
      ) : 
      CupertinoTabBar(
        height: 60,
        backgroundColor: primaryColor,
        border: const Border(top: BorderSide(style: BorderStyle.none)),
        iconSize: 35,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home , color: _page == 0 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment , color: _page == 1 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt , color: _page == 2 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign , color: _page == 3 ? bgColor : tabIcon),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum , color: _page == 4 ? bgColor : tabIcon),
          ),
        ],
        onTap: navigationTap,
      ),
    );
  }
}