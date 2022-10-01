import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instgram_app/pages/commentscreen.dart';
import 'package:intl/intl.dart';

import 'colors.dart';
import 'heart_animation.dart';

class PostDesign extends StatefulWidget {
  PostDesign({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  int Likes = 0;
  bool DeletePost = false;
  var uiid;
  bool showLike =false;
  bool isLikeAnimating = false;
  getcommentData() async {
    try {
      QuerySnapshot CommentData = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.data['postId'])
          .collection('Comments')
          .get();

      setState(() {
        Likes = CommentData.docs.length;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcommentData();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: mobileBackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(
            vertical: widthScreen > 600 ? 11 : 0,
            horizontal: widthScreen > 600 ? widthScreen / 7 : 0),
        padding: EdgeInsets.symmetric(
            vertical: widthScreen > 600 ? 11 : 0,
            horizontal: widthScreen > 600 ? 20 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //-------- BIG Row   ( pic and UserName and Icon )-------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //---------  pic and UserName ----------------------
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(widget.data['profileImg']),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.data['username']),
                  ],
                ),
                //------- Icon -------------------------
                //-----------------showDialog----------------------
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return Container(
                                padding: EdgeInsets.all(20),
                                height: 170,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.data['Uid']
                                        ? GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);

                                              await FirebaseFirestore.instance
                                                  .collection('posts')
                                                  .doc(widget.data['postId'])
                                                  .delete();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.white),
                                                SizedBox(
                                                  width: 11,
                                                ),
                                                Text(
                                                  'Delete Post',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text('Can not Delete this post ✋'),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.cancel,
                                              color: Colors.white),
                                          SizedBox(
                                            width: 11,
                                          ),
                                          Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            //----------- Image Poste---------------------------------------
            GestureDetector(
              onDoubleTap: ()async{
                  setState(() {
                             isLikeAnimating=true;
                          });
                            await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.data['postId'])
                              .update({
                            "likes": FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                         
                          // Timer(const Duration(seconds: 1), () =>
                        
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.network(
                    widget.data['imgPost'],
                    height: MediaQuery.of(context).size.height * .35,
                    width: double.infinity,
                  ),
               AnimatedOpacity(
  duration: const Duration(milliseconds: 200),
  opacity: isLikeAnimating ? 1 : 0,
  child: LikeAnimation(
    isAnimating: isLikeAnimating,
    duration: const Duration(
      milliseconds: 400,
    ),
    onEnd: () {
      setState(() {
        isLikeAnimating = false;
      });
    },
    child: Icon(
      Icons.favorite,
      color: Colors.white,
      size: 90,
    ),
  ),
)
                  
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //-------------Big ROW- (Icons Like , Commnent,Send , Iocn Archive)------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //----------Icons Like , Commnent,Send---------------
                Row(
                  children: [


                    LikeAnimation(
         isAnimating: widget.data['likes']
        .contains(FirebaseAuth.instance.currentUser!.uid),
    smallLike: true,
    child: IconButton(
      onPressed: () async {
        if (widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid))
                                 {
                                   await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.data['postId'])
                              .update({
                            "likes": FieldValue.arrayRemove( 
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                          } else {
                             await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.data['postId'])
                              .update({
                            "likes": FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                          }
      },
      icon: widget.data['likes'].contains(
              FirebaseAuth.instance.currentUser!.uid)
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : const Icon(
              Icons.favorite_border,
            ),
    ),
  ),

                    // IconButton(
                    //     onPressed: () async {

                    //       if (widget.data['likes'].contains(
                    //             FirebaseAuth.instance.currentUser!.uid))
                    //              {
                    //                await FirebaseFirestore.instance
                    //           .collection('posts')
                    //           .doc(widget.data['postId'])
                    //           .update({
                    //         "likes": FieldValue.arrayRemove( 
                    //             [FirebaseAuth.instance.currentUser!.uid]),
                    //       });
                    //       } else {
                    //          await FirebaseFirestore.instance
                    //           .collection('posts')
                    //           .doc(widget.data['postId'])
                    //           .update({
                    //         "likes": FieldValue.arrayUnion(
                    //             [FirebaseAuth.instance.currentUser!.uid]),
                    //       });
                    //       }



      
                    //     },
                    //     icon: widget.data['likes'].contains(
                    //             FirebaseAuth.instance.currentUser!.uid)
                    //             ?Icon(
                    //             Icons.favorite,
                    //             color: Colors.red,
                    //           )
                    //         : Icon(Icons.favorite_border)
                    //          ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        data: widget.data,
                                        showcomment: true,
                                      )));
                        },
                        icon: Icon(Icons.comment)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),

                //------------------------ Iocn Archive ----------------------
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border_outlined),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            //------------------ Likes (Text)-----------------
            Container(
              width: double.infinity,
              child: Text(
                widget.data['likes'].length > 1
                    ? '${widget.data['likes'].length} Likes'
                    : '${widget.data['likes'].length} Like',
                style: TextStyle(color: secondaryColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //---------------- username and commnet-----------------
            Row(
              children: [
                Text(
                  widget.data['username'],
                  style: TextStyle(color: secondaryColor),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(widget.data['description']),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            //------------------- Text View all 100 comments---------------------
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentScreen(
                              data: widget.data,
                              showcomment: false,
                            )));
              },
              child: Container(
                width: double.infinity,
                child: Text(
                  'View all ${Likes} comments',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //-------------------- Date 9 Sept 2022
            Container(
              width: double.infinity,
              child: Text(
                DateFormat.yMMMd()
                    .format(widget.data['datePublished'].toDate()),
                style: TextStyle(color: secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
