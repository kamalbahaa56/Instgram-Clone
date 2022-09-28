import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_app/firebase_services/auth.dart';
import 'package:instgram_app/shared/colors.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;
import "dart:math";

import '../componants/formfield.dart';
import '../shared/navigator.dart';
import '../shared/tostfile.dart';
import 'login_screen.dart';

class Register extends StatefulWidget {
  static final String id = 'register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var EmailController = TextEditingController();

  var PasswordController = TextEditingController();

  var UserName = TextEditingController();

  var TitleController = TextEditingController();

  var AgeController = TextEditingController();

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool ispaswwordshow = false;

  IconData iconData = Icons.visibility_off_outlined;

  bool ispassword8Charcter = false;

  bool ispasswordAtLest1number = false;

  bool passwordHasUpperCase = false;

  bool passwordHasLowercase = false;

  bool hasSpecialCharacters = false;
  File? imgPath;
  String? imgName;

// Show Sheet
  showsheet() {
    return showModalBottomSheet(
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
  void dispose() {
    UserName.dispose();
    AgeController.dispose();
    TitleController.dispose();
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        // width: double.infinity,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            imgPath == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 60,
                                    backgroundImage:
                                        AssetImage('assets/images/avatar.png'),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      imgPath!,
                                      width: 145,
                                      height: 145,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 85,
                              child: IconButton(
                                  onPressed: () {
                                    // uploadImageScreen(ImageSource.source);
                                    showsheet();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      DefultFormFiled(
                        controller: UserName,
                        typee: TextInputType.text,
                        Label: 'user name',
                        Validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Please enter your user name';
                          }
                        },
                        PreFixIcon: Icons.person,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefultFormFiled(
                        controller: TitleController,
                        typee: TextInputType.text,
                        Label: 'Title',
                        Validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Please enter your title';
                          }
                        },
                        PreFixIcon: Icons.title,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefultFormFiled(
                        controller: EmailController,
                        typee: TextInputType.emailAddress,
                        Label: 'Email Address',
                        Validator: (value) {
                          return value!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidate: AutovalidateMode.onUserInteraction,
                        PreFixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefultFormFiled(
                        // onChanged: (value) {
                        //   onPasswordChanged(value);
                        // },
                        controller: PasswordController,
                        SufFixIcon: iconData,
                        ispassword: ispaswwordshow,
                        Label: 'Password',
                        Validator: (value) {
                          return value!.length < 8
                              ? "Enter at least 6 characters"
                              : null;
                        },
                        PreFixIcon: Icons.lock_outlined,
                        autovalidate: AutovalidateMode.onUserInteraction,
                        SuffixIcon: () {
                          setState(() {
                            ispaswwordshow = !ispaswwordshow;
                            iconData = ispaswwordshow
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            // ;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            if (_formKey.currentState!.validate() 
                            // &&
                            //     imgName != null &&
                            //     imgPath != null
                                )
                                {
                                   setState(() {
                                isLoading = true;
                              });
                            await AuthMethods().register(
                              email: EmailController.text,
                              password: PasswordController.text,
                              UserName: UserName.text,
                              ttitle: TitleController.text,
                              context: context,
                              imgName: imgName,
                              imgPath: imgPath,
                            );
                            setState(() {
                              isLoading = false;
                            });
                                }
                              
                          },
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('Register'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't Have an account ?"),
                          const SizedBox(
                            width: 1,
                          ),
                          TextButton(
                            onPressed: () {
                              DefultNavigator(
                                  context: context, widget: Login());
                            },
                            child: const Text('sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
