import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;

  const ResponsiveLayout({super.key, required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context , listen: false);
    await userProvider.refreshUser();
  } 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return widget.mobileScreenLayout;
      },
    );
  }
}