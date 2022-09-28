import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

class PostDesign extends StatefulWidget {
   PostDesign({Key? key,required this.data}) : super(key: key);
  final data ;
  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: mobileBackgroundColor,
            borderRadius: BorderRadius.circular(20)
          ),
          margin: EdgeInsets.symmetric(vertical: widthScreen >600?11:0,horizontal :widthScreen >600 ?widthScreen/7:0),
          padding: EdgeInsets.symmetric(vertical: widthScreen >600?11:0,horizontal :widthScreen >600 ?20:0),
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
                      shape: BoxShape.circle,
                      color: Colors.grey
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(widget.data['profileImg']),
                    ),
                  ), 
                  SizedBox(width: 10,),
                  Text(widget.data['username']),
                ],
              ),
              //------- Icon -------------------------
              Row(
                children: [
               IconButton(onPressed: (){}, 
               icon: Icon(Icons.more_vert),
               ),
                ],
              ),
            
                ],
              ),
                 SizedBox(height: 10,),
                 //----------- Image Poste---------------------------------------
              Image.network(widget.data['imgPost'],
                height: MediaQuery.of(context).size.height*.35,
                width: double.infinity,
                ),
              SizedBox(height: 10,),
              //-------------Big ROW- (Icons Like , Commnent,Send , Iocn Archive)------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     //----------Icons Like , Commnent,Send---------------
                Row(
                  children: [
                  IconButton(onPressed: (){}, 
                  icon: Icon(Icons.favorite_border)
                  ),
                  IconButton(onPressed: (){}, 
                  icon: Icon(Icons.comment)
                  ),
                  IconButton(onPressed: (){}, 
                  icon: Icon(Icons.send),
                  ),
                  ],
                ),
                
                //------------------------ Iocn Archive ----------------------
                IconButton(onPressed: (){}, 
                icon: Icon(Icons.bookmark_border_outlined),
                ),
                ],
              ),
              SizedBox(height: 10,),
               //------------------ Likes (Text)-----------------
              Container(
                width: double.infinity,
                child: Text(widget.data['likes'].length>1 ? '${widget.data['likes'].length} Likes' : '${widget.data['likes'].length} Like' ,style: TextStyle(color: secondaryColor),
                ),
                ),
               SizedBox(height: 10,),
               //---------------- username and commnet-----------------
              Row(
                children: [
                   Text(widget.data['username'],style: TextStyle(color: secondaryColor),),
                   SizedBox(width: 5,),
                   Text(widget.data['description']),
                ],
              ),
              SizedBox(height: 10,),
              //------------------- Text View all 100 comments---------------------
            GestureDetector(
              onTap: (){
                print('Done');
              },
              child: Container(
                width: double.infinity,
                  child: Text('View all 100 comments',style: TextStyle(color:secondaryColor ),),
                ),
            ),
              SizedBox(height: 10,),
              //-------------------- Date 9 Sept 2022
               Container(
              width: double.infinity,
                child: Text(DateFormat.yMMMd().format(widget.data['datePublished'].toDate()),style: TextStyle(color:secondaryColor ),),
               
              ),
              
           ],
          ),
        ),
      );
  }
}