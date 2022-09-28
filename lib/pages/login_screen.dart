// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instgram_app/pages/register_screen.dart';
import 'package:instgram_app/pages/resetpassword_screen.dart';
import 'package:instgram_app/shared/colors.dart';
import '../componants/formfield.dart';
import '../firebase_services/auth.dart';
import '../shared/navigator.dart';
class Login extends StatefulWidget {
  static  final String  id ='login' ;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var EmailController = TextEditingController();

  var PasswordController = TextEditingController();

  var _formkey = GlobalKey<FormState>();

   IconData iconData = Icons.visibility_off_outlined;
    bool ispaswwordshow = false;
    bool isloadinglogin = false;
    //final credential = FirebaseAuth.instance ;
//   signIn() async
//   {
//     setState(() {
//       isloadinglogin = true;
//     });
//     try {
//      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: EmailController.text,
//      password: PasswordController.text
//   );  
//     CachHelper.SaveData(key: 'token', value:credential.user!.uid ).then((value){
//                Navigator.popAndPushNamed(context, HomeScreen.id);
//             });
//   //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
// } on FirebaseAuthException catch (e) {
//   if (e.code == 'user-not-found') {
//     DefultTost(masseg:'No user found for that email.' , color:Colors.deepOrange );
//     //print('No user found for that email.');
//   } else if (e.code == 'wrong-password') {
//      DefultTost(masseg:'Wrong password provided for that user.' , color:Colors.deepOrange );
//     //print('Wrong password provided for that user.');
//   }
// }
// setState(() {
//       isloadinglogin = false;
//     });
//   }
void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  
  {
   // var googleSingIn = Provider.of<GoogleSignInProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: Center(
          child: Padding(
            padding:  EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                    [
                    //  Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    SvgPicture.asset('assets/images/instagram.svg',color: primarycolor,),
                    SizedBox(
                      height: 40,
                    
                    ),
                    
                    DefultFormFiled
                    (
                      
                      controller:EmailController ,
                      typee: TextInputType.emailAddress,
                      Label: 'Email Address',
                      Validator: (value) 
                        {
                          return value!.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ? null : "Enter a valid email"  ;
                        },
                      autovalidate: AutovalidateMode.onUserInteraction,
                      PreFixIcon:Icons.email_outlined,
                    ),
                    
                     SizedBox(
                      height: 20,
                    
                    ),
                    
                     DefultFormFiled
                    (
                      controller:PasswordController ,
                      SufFixIcon: iconData,
                      ispassword: ispaswwordshow,
                      Label: 'Password',
                      Validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                        return 'Please enter the password';
                        }
                      },
                      PreFixIcon:Icons.lock_clock_outlined,
                      SuffixIcon:() { 
                            setState(() {
                              ispaswwordshow=!ispaswwordshow;
                             iconData= ispaswwordshow? Icons.visibility_off_outlined:Icons.visibility_outlined;
                            });
                          },
                    ),
                  
                    SizedBox(
                      height: 20,
                    
                    ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      
                     onPressed: () async
                        {
                          if(_formkey.currentState!.validate())
                          {
                             setState(() {
                                isloadinglogin = true;
                              });
                           await   AuthMethods().signIn(
                                emaill: EmailController.text, 
                                Passwordd: PasswordController.text, 
                                context: context
                                );
                                 setState(() {
                                  isloadinglogin = false;
                            });
                          }
                            // await   signIn();
                            // DefultNavigator(context: context,widget: HomeScreen());
                           // Navigator.pushReplacementNamed(context, HomeScreen.id);
                        }
                      , 
                      child: isloadinglogin?CircularProgressIndicator(color: Colors.white,):Text( 'Login'),
                      ),
                  ),
                              
                  SizedBox(
                      height: 10,
                    
                    ), 
                              
                  TextButton(
                    onPressed: ()
                    {
                     DefultNavigator(context: context,widget:ResetPasswordScreen() );
                    }, 
                  child: Text('Forgotten your password?',),
                  ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't Have an account ?"),
                          SizedBox(
                            width: 1,
                          ),
                          TextButton(onPressed: ()
                          {
                           DefultNavigator(context: context,widget: Register());
                          }, 
                          child: Text('sign up'),
                          ),
                        ],
                      ),
                  //     Row(
                  //       children: [
                  //         Expanded(
                  //           child:Divider(
                  //             thickness: 0.6,
                  //             color: Colors.white,
                  //           ) ,
                  //           ),
                  //           Text(
                  //             'OR',
                  //             ),
                  //             Expanded(
                  //               child: Divider(
                  //                 thickness: 0.6,
                  //                  color: Colors.white,
                  //               ),
                  //               ),
                              
                  //       ],
                  //     ),
                              
                  //      Container(
                  //         margin: EdgeInsets.symmetric(vertical: 27),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                              
                  //            GestureDetector(
                  //                   onTap: (){  
                  //                   // googleSingIn.googlelogin(context);
                  //                       },
                  //               child: Container(
                  //                 padding: EdgeInsets.all(13),
                  //                 decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     border:
                  //                         Border.all(color: Colors.white, width: 1)),
                  //                 child: SvgPicture.asset(
                  //                   "assets/images/icons8-google.svg",
                  //                   color: Colors.red,
                  //                   height: 27,
                  //                 ),
                  //               ),
                  //             ),
                              
                  //   ],
                      
                  // ),
                  // ),
                  //Image.asset('assets/images/icons8-meta-48.png')
                    
                  ],
                        ),
                      
                  SizedBox(height: 120,),
                     Container(
                       child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                          Text('from',style: TextStyle(color: primarycolor),),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Image.asset('assets/images/icons8-meta-48.png',width: 30,height: 30,),
                               SizedBox(width: 5,),
                                 Text('Meta',style: TextStyle(color: primarycolor),),
                             ],
                           )
                       
                         ],
                       ),
                     ),
                    ],
              ),
          ),
                 ),
        ),
        ),
        );
  }
}
