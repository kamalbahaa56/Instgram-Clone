import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instgram_app/pages/login_screen.dart';
import 'package:instgram_app/pages/register_screen.dart';
import 'package:instgram_app/responsive/responsive.dart';
import 'package:instgram_app/shared/cachhelper.dart';
import 'package:instgram_app/shared/provider/user_provider.dart';
import 'package:provider/provider.dart';

 void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CachHelper.init();
     String token = CachHelper.getData(key: 'token');
     print(token);
     Widget widget;
     if(token!=null)
    {
      widget = ResposiveScreen();
    }else{
      widget = Login();
    }
    if (kIsWeb) {
      await Firebase.initializeApp(
         options: const FirebaseOptions(
           apiKey: "AIzaSyDM9Gllupe4dPgn0wfP2SNqGJe2WkiDH4c",
           authDomain: "instgramsocial-2f2d3.firebaseapp.com",
           projectId: "instgramsocial-2f2d3",
           storageBucket: "instgramsocial-2f2d3.appspot.com",
           messagingSenderId: "905900690574",
           appId: "1:905900690574:web:fa66dc34b16d0bdddbcddf"));
  } else {
 await Firebase.initializeApp();
  }
 runApp( MyApp(startwidget: widget,));
 }
class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startwidget}) : super(key: key);
    final Widget startwidget ;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home:  startwidget,
        //Register()
       //   ResposiveScreen(),
      ),
    );
  }
}