import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instgram_app/firebase_services/storage.dart';
import 'package:instgram_app/pages/home.dart';
import 'package:instgram_app/pages/login_screen.dart';
import 'package:instgram_app/shared/navigator.dart';
import '../model/user.dart';
import '../responsive/responsive.dart';
import '../shared/cachhelper.dart';
import '../shared/tostfile.dart';

class AuthMethods {
  register(
      {required email,
      required password,
      required context,
      required UserName,
      required ttitle,
      required imgPath,
      required imgName,
      }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      DefultTost(
          masseg: 'An account has been created successfully',
          color: Colors.green);
          //------------------ Get URL PIC ---------------------------------------

          String url = await GitURLImage(imgName:imgName ,imgPath:imgPath, ImageFile: 'UserProfileImage' );
   

          //ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ
      DefultReplaceNavigator(context: context, widget: Login());
      //----------- Send Data To DataBase(FireStore)

      CollectionReference users = FirebaseFirestore.instance.collection('users');



      UserData userrr =    UserData(
        Password: password,
        Title:ttitle ,
        email:email ,
        username:UserName ,
        profileImage:url,
        Uid: credential.user!.uid,
        followers:[],
        following:[],
        Posts: [],
        );





      users
          .doc('${credential.user!.uid}')
          .set(userrr.Convert2Map())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      DefultTost(masseg: 'Erorr is ${e.code}', color: Colors.red);
    }
  }

   signIn({required emaill , required Passwordd , required context}) async
  {
   
    try {
     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emaill,
     password: Passwordd,
  );  
    CachHelper.SaveData(key: 'token', value:credential.user!.uid ).then((value){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ResposiveScreen()), (route) => false);
            });
  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    DefultTost(masseg:'No user found for that email.' , color:Colors.deepOrange );
    //print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
     DefultTost(masseg:'Wrong password provided for that user.' , color:Colors.deepOrange );
    //print('Wrong password provided for that user.');
  }
}

  }
  // functoin to get user details from Firestore (Database)
Future<UserData> getUserDetails() async {
   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(); 
   return UserData.convertSnap2Model(snap);
 }

}
/*
 setState(() {
      isloadinglogin = true;
    });
    */