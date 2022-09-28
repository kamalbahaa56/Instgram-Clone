import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_app/shared/colors.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

import '../firebase_services/firestore.dart';
import '../shared/provider/user_provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  File? imgPath;
  String? imgName;
  final controllerr = TextEditingController();
  bool addPost = true;
  bool isloading = true;
  // Show Sheet
  showsheet() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await uploadImageScreen(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'From Camera',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await uploadImageScreen(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.photo, color: Colors.white),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'From Gallery',
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
  }

//--------------------------Upload Image To Screen------------------------------------
// Upload Image
  uploadImageScreen(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    final double widthScreen = MediaQuery.of(context).size.width;
    return imgPath != null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              actions: [
                TextButton(
                    onPressed: ()async {
                      setState(() {
                        isloading = false;
                      });

                    await  FirestoreMethoud().upoladPost(
                          description: controllerr.text,
                          username: allDataFromDB!.username,
                          imgName: imgName,
                          profileImg: allDataFromDB.profileImage,
                          imgPath: imgPath
                          );
                          setState(() {
                        isloading = true;
                         imgPath = null;
                      });
                   
                    },
                    child: Text("Post"))
              ],
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                isloading
                    ? Divider(
                        thickness: 1,
                        height: 30,
                      )
                    : LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(allDataFromDB!.profileImage),
                        radius: 33,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: controllerr,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: "write a caption ....",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    imgPath == null
                        ? CircularProgressIndicator()
                        : Image.file(
                            imgPath!,
                            width: 66,
                            height: 74,
                            // fit: BoxFit.cover,
                          ),
                  ],
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: IconButton(
                icon: Icon(
                  Icons.upload,
                  size: 50,
                ),
                onPressed: () {
                  showsheet();
                },
              ),
            ),
          );
  }
}
