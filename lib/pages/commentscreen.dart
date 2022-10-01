import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instgram_app/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../firebase_services/firestore.dart';
import '../shared/provider/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final data;
  bool showcomment = false;
   CommentScreen({Key? key, required this.data,required this.showcomment}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var CommentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CommentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDatatFromDataBase = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Comments'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.data['postId'])
                    .collection("Comments").orderBy("DatePublished")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                  return Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['ProfilePic']),
                                  radius: 22,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        data['username'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data['textcomment'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    (DateFormat.yMMMd().format(
                                        data['DatePublished'].toDate())),
                                    style: TextStyle(color: secondaryColor),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.favorite_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
           widget.showcomment ? Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(allDatatFromDataBase!.profileImage),
                      radius: 22,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: CommentController,
                      decoration: InputDecoration(
                        hintText: "comment as ${allDatatFromDataBase.username}",
                        fillColor: Colors.grey[900],
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () async {
                              FirestoreMethoud().UploadComment(
                                  postId: widget.data['postId'],
                                  PofileImage:
                                      allDatatFromDataBase.profileImage,
                                  username: allDatatFromDataBase.username,
                                  textcomment: CommentController.text,
                                  Uid: allDatatFromDataBase.Uid);
                              CommentController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ):Column()
          ],
        ));
  }
}

/*
StreamBuilder<QuerySnapshot>(
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
---------------------------------------------------------------------
  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').doc(widget.data['postId']).collection("Comments").snapshots(),
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
            return  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                padding: EdgeInsets.all(1),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://img.a.transfermarkt.technology/portrait/big/28463-1497271438.jpg?lm=1'),
                  radius: 22,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'UserName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Nice Pic ❤️ ',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Text(
                    '29/9/2022',
                    style: TextStyle(color: secondaryColor),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                       allDatatFromDataBase!.profileImage),
                    radius: 22,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    controller: CommentController,
                    decoration: InputDecoration(
                      hintText: "comment as ${allDatatFromDataBase.username}",
                      fillColor: Colors.grey[900],
                      filled: true,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            String commentid = const Uuid().v1();
                        await    FirebaseFirestore.instance
                                .collection("posts")
                                .doc(widget.data['postId'])
                                .collection("Comments")
                                .doc(commentid).set({
                                  "ProfilePic":allDatatFromDataBase!.profileImage,
                                  "username":allDatatFromDataBase.username,
                                  "textcomment":CommentController.text,
                                  "DatePublished":DateTime.now(),
                                  "uid":allDatatFromDataBase.Uid,
                                  "commentid":commentid,
                                 
                                });
                                CommentController.clear();
                          },
                          icon: Icon(
                            Icons.send,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
          }).toList(),
        );
      },
    ), 



-------------------------


 Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                padding: EdgeInsets.all(1),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://img.a.transfermarkt.technology/portrait/big/28463-1497271438.jpg?lm=1'),
                  radius: 22,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'UserName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Nice Pic ❤️ ',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Text(
                    '29/9/2022',
                    style: TextStyle(color: secondaryColor),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ],
          )

    */