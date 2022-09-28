import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instgram_app/shared/colors.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key, required this.uidd}) : super(key: key);
  final uidd;
  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  Map UserData = {};
  bool isLoading = true;
  int following = 0;
  int followers = 0;
  int posts = 0;
  bool showUnfollow = true;
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snaphsot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.uidd)
          .get();
      UserData = snaphsot.data()!;
      following = UserData["following"].length; //length
      followers = UserData["followers"].length;
      var snaphsotPosts = await FirebaseFirestore.instance
          .collection('posts')
          .where('Uid', isEqualTo: widget.uidd)
          .get();
      posts = snaphsotPosts.docs.length;
      //length
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return SafeArea(
      child: isLoading
          ? Scaffold(
              backgroundColor: mobileBackgroundColor,
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )),
            )
          : Scaffold(
              backgroundColor: mobileBackgroundColor,
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    //---------Text UserName-----------------
                    Container(
                        width: double.infinity,
                        child: Text(
                          UserData['username'],
                          style: TextStyle(fontSize: 18),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    //------------Big Row (Pic , Posts , Followers,Following)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(UserData['profileImage']),
                          ),
                        ),
                        //------------Posts-----------
                        Column(
                          children: [
                            Text(
                              '${posts}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 12),
                            ),
                          ],
                        ),
                        //------------------------Followers-----------
                        Column(
                          children: [
                            Text(
                              followers.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Text(
                              'Followers',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 12),
                            ),
                          ],
                        ),
                        //-------------------Following----------
                        Column(
                          children: [
                            Text(
                              following.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //-------Discription(Text) -------------
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      width: double.infinity,
                      child: Text(
                        UserData['Title'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //---------Divider------------------
                    const Divider(
                      thickness: 1.0,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    widget.uidd == FirebaseAuth.instance.currentUser!.uid
                        ?
                        //---------(Row)ElevatedButtomn(Edit profile , Logout)-----------
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                                label: Text('Edit profile'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          mobileBackgroundColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side:
                                            BorderSide(color: secondaryColor)),
                                  ),
                                ),
                              ),
                              //SizedBox(width: 10,),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.logout),
                                label: Text('Log out'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 183, 52, 52)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side:
                                            BorderSide(color: secondaryColor)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : showUnfollow == true
                            ? ElevatedButton(
                                onPressed: ()async {
                                  setState(() {
                                    showUnfollow = false;
                                    following++;
                                  });

                             await     FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.uidd)
                                      .update({
                                    "followers": FieldValue.arrayUnion([
                                    FirebaseAuth.instance.currentUser!.uid
                                    ])
                                  });

                              await   FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                      .update({
                                    "following": FieldValue.arrayUnion([
                                      widget.uidd
                                    ])
                                  });
                                },
                                child: Text('Follow'),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 9, horizontal: 70)
                                            )
                                            ),
                              )
                            : ElevatedButton(
                                onPressed: ()async{
                                  setState(() {
                                    showUnfollow = true;
                                    following--;
                                  });
                               await   FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.uidd)
                                      .update({
                                    "followers": FieldValue.arrayRemove([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ])
                                  });
                                },
                                child: Text('UnFollow'),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(143, 255, 55, 112)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 9, horizontal: 70))),
                              ),

                    SizedBox(
                      height: 10,
                    ),
                    //---------Divider------------------
                    Divider(
                      thickness: 1.0,
                    ),

                    //----------GrideView----------------------
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('Uid', isEqualTo: widget.uidd)
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return Expanded(
                            child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              //primary: false,
                              //   padding: const EdgeInsets.all(20),
                              itemCount: snapshot.data.docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                              ),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    snapshot.data.docs[index]['imgPost'],
                                    // height: MediaQuery.of(context).size.height*.35,
                                    //     width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
