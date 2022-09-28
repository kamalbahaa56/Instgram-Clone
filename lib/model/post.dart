

import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
final String profileImg;
final String username;
final String description;
final String imgPost;
final String Uid;
final String postId;
final DateTime datePublished;
final List likes;
  PostData({
    required this.username,
    required this.profileImg,
    required this.description,
    required this.imgPost,
    required this.datePublished,
    required this.Uid,
    required this.postId,
    required this.likes,
  });

  // To convert the UserData(Data type) to   Map<String, Object>
  Map<String,dynamic> Convert2Map()
  {
    return 
    {
      "username":username,
      "profileImg":profileImg,
      "description":description,
      "imgPost":imgPost,
      "datePublished":datePublished,
      "Uid":Uid,
      "postId":postId,
      "likes":likes,
    };
  }

  
 // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User
 
 static convertSnap2Model(DocumentSnapshot snap) {
 var snapshot = snap.data() as Map<String, dynamic>;
 return PostData(
  username: snapshot["username"],
  profileImg: snapshot["profileImg"],
  description: snapshot["description"],
  imgPost: snapshot["imgPost"],
  datePublished: snapshot["datePublished"],
  Uid: snapshot["Uid"],
  postId: snapshot["postId"],
  likes: snapshot["likes"],
  );
 }
}
