import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_app/firebase_services/storage.dart';
import 'package:uuid/uuid.dart';

import '../model/post.dart';
import '../shared/tostfile.dart';

class FirestoreMethoud {
  upoladPost(
      {required description,
      required username,
      required imgName,
      required profileImg,
      required imgPath}) async {
    try {
      //------------------ Get URL PIC ---------------------------------------

      String url = await GitURLImage(
          imgName: imgName,
          imgPath: imgPath,
          ImageFile: 'ImagePosts/${FirebaseAuth.instance.currentUser!.uid}');

      //------------- New ID To Posts ---------------------------
      var NewId = Uuid().v1();

      //----------- Send Data To DataBase(FireStore)

      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');

      PostData postData = PostData(
        Uid: FirebaseAuth.instance.currentUser!.uid,
        datePublished: DateTime.now(),
        description: description,
        imgPost: url,
        likes: [],
        postId: NewId,
        profileImg: profileImg,
        username: username,
      );

      posts
          .doc(NewId)
          .set(postData.Convert2Map())
          .then((value) =>
              DefultTost(masseg: "Posted Added", color: Colors.green))
          .catchError((error) => print("Failed to add post: $error"));
    } on FirebaseAuthException catch (e) {
      DefultTost(masseg: 'Erorr is ${e.code}', color: Colors.red);
    }
  }
}
