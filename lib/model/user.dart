

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
String username;
String Title;
String email;
String Password;
String profileImage;
String Uid;
 List followers ;
 List following ;
 List Posts;
  UserData({
    required this.username,
    required this.Title,
    required this.email,
    required this.Password,
    required this.profileImage,
    required this.Uid,
    required this.followers,
    required this.following,
    required this.Posts,
  });

  // To convert the UserData(Data type) to   Map<String, Object>
  Map<String,dynamic> Convert2Map()
  {
    return 
    {
      "username":username,
      "Title":Title,
      "email":email,
      "Password":Password,
      "profileImage":profileImage,
      "Uid":Uid,
      "following":[],
      "followers":[],
      "Posts":[],
    };
  }

  
 // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User
 
 static    convertSnap2Model(DocumentSnapshot snap) {
 var snapshot = snap.data() as Map<String, dynamic>;
 return UserData(
  username: snapshot["username"],
  Title: snapshot["Title"],
  email: snapshot["email"],
  Password: snapshot["Password"],
  profileImage: snapshot["profileImage"],
  Uid: snapshot["Uid"],
  following: snapshot["following"],
  followers: snapshot["followers"],
  Posts:snapshot['Posts']
  );
 }
}
