import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instgram_app/pages/addscreen.dart';
import 'package:instgram_app/pages/favorite.dart';
import 'package:instgram_app/pages/home.dart';
import 'package:instgram_app/pages/person.dart';
import 'package:instgram_app/pages/search.dart';

import '../shared/colors.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  int CurntIndex = 0 ;
  List Screens = [
    HomeScreen(),
    SearchScreen(),
    AddScreen(),
    FavoriteScreen(),
    PersonScreen(uidd: FirebaseAuth.instance.currentUser!.uid),
  ];
  navigat2screen(int index)
  {
    setState(() {
              CurntIndex = index;
            });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
         title: SvgPicture.asset('assets/images/instagram.svg',color: primarycolor,height: 32,),
        actions: [
          IconButton(onPressed: ()
          {
            navigat2screen(0);
          }, 
          icon: Icon(Icons.home,
                    color: CurntIndex == 0 ? primarycolor : secondaryColor),
          ),
          IconButton(onPressed: (){
             navigat2screen(1);
          }, 
          icon: Icon(Icons.search,
                    color: CurntIndex == 1 ? primarycolor : secondaryColor),
          ),
          IconButton(onPressed: (){
              navigat2screen(2);
          }, 
          icon: Icon(Icons.add_circle,
                    color: CurntIndex == 2 ? primarycolor : secondaryColor),
          ),
          IconButton(onPressed: (){
               navigat2screen(3);
          }, 
          icon: Icon(Icons.favorite,
                    color: CurntIndex == 3 ? primarycolor : secondaryColor),
          ),
          IconButton(onPressed: (){
              navigat2screen(4);
          }, 
          icon: Icon(Icons.person,
                    color: CurntIndex == 4 ? primarycolor : secondaryColor),
          ),
        ],
      ),
      body:Screens[CurntIndex],
    );
  }
}