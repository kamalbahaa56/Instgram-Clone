import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instgram_app/pages/login_screen.dart';
import 'package:intl/intl.dart';

import '../shared/cachhelper.dart';
import '../shared/colors.dart';
import '../shared/navigator.dart';
import '../shared/post_templet.dart';
class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
     final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
       backgroundColor:widthScreen>600?webBackgroundColor: mobileBackgroundColor, 
      appBar: widthScreen >600 ?null :
      AppBar(
        backgroundColor:widthScreen>600?webBackgroundColor: mobileBackgroundColor,
       title: SvgPicture.asset('assets/images/instagram.svg',color: primarycolor,height: 32,),
       actions: [
        IconButton(onPressed: (){}, 
        icon: Icon(Icons.messenger_outline)
        ),
         IconButton(onPressed: ()async
         {
            await   FirebaseAuth.instance.signOut();
                   CachHelper.removeData(key: 'token');
                 DefultReplaceNavigator(
                  context: context,
                  widget: Login(),
                 );
         }, 
        icon: Icon(Icons.logout),
        ),
       ],
      ),
      body:  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.white,));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return  PostDesign(data: data,);
          }).toList(),
        );
      },
    ),
    );
  }
}
//https://besthqwallpapers.com/Uploads/4-9-2021/177930/thumb-shikabala-zamalek-sc-mahmoud-abdelrazek-hassan-fadlala-egypt-football.jpg
//https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUCxe7s30cFmp2jXTxlYKqUo79h2S0re4C0g&usqp=CAU'

