import 'package:flutter/material.dart';
import 'package:instgram_app/responsive/mobile.dart';
import 'package:instgram_app/responsive/web.dart';
import 'package:provider/provider.dart';

import '../shared/provider/user_provider.dart';

class ResposiveScreen extends StatefulWidget {
  const ResposiveScreen({Key? key}) : super(key: key);

  @override
  State<ResposiveScreen> createState() => _ResposiveScreenState();
}

class _ResposiveScreenState extends State<ResposiveScreen> {
  // To get data from DB using provider
 getDataFromDB() async {
 UserProvider userProvider = Provider.of(context, listen: false);
 await userProvider.refreshUser();
 }
 
 @override
 void initState() {
    super.initState();
    getDataFromDB();
 }
  @override
  Widget build(BuildContext context) {
        final double widthScreen = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder:(context, constraints)
      {
        if (widthScreen>600) {
          return WebScreen();
        } else {
          return MobileScree();
        }
      }
      );
  }
}