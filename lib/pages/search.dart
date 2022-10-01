import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instgram_app/pages/person.dart';
import 'package:instgram_app/shared/colors.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    SearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: widthScreen > 600
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              title: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: SearchController,
                decoration: InputDecoration(labelText: 'Search for a user...'),
              ),
            ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: SearchController.text)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonScreen(
                   uidd:  snapshot.data!.docs[index]['Uid'],
                  ),
                  ),
                  );
                },
                title: Text(snapshot.data!.docs[index]['username']),
                leading: CircleAvatar(
                    radius: 33,
                    backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['profileImage']
                        ),
                        ),
              ),
            );
          }

          return Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        },
      ),
    );
  }
}



//FirebaseFirestore.instance.collection('posts').where('Uid', isEqualTo:  FirebaseAuth.instance.currentUser!.uid).get()