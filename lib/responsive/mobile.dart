import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instgram_app/pages/addscreen.dart';
import 'package:instgram_app/pages/favorite.dart';
import 'package:instgram_app/pages/home.dart';
import 'package:instgram_app/pages/person.dart';
import 'package:instgram_app/pages/search.dart';

import '../shared/colors.dart';

class MobileScree extends StatefulWidget {
  const MobileScree({Key? key}) : super(key: key);

  @override
  State<MobileScree> createState() => _MobileScreeState();
}

class _MobileScreeState extends State<MobileScree> {
  final PageController _pageController = PageController();
  int CurntIndex = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          //inactiveColor: primaryColor,
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              CurntIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: CurntIndex == 0 ? primarycolor : secondaryColor),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: CurntIndex == 1 ? primarycolor : secondaryColor),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: CurntIndex == 2 ? primarycolor : secondaryColor),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,
                    color: CurntIndex == 3 ? primarycolor : secondaryColor),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: CurntIndex == 4 ? primarycolor : secondaryColor),
                label: ''),
          ]),
      body: PageView(
        onPageChanged: (index) {},
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          SearchScreen(),
          AddScreen(),
          FavoriteScreen(),
          PersonScreen(uidd: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
    );
  }
}
