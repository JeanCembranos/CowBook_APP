import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/Screens/Home.dart';

import 'Trip.dart';

Widget buildTripCard(BuildContext context, DocumentSnapshot document) {
  final trip = Trip.fromSnapshot(document);

   return InkWell(
       child: Container(
         decoration: BoxDecoration(
           borderRadius: BorderRadius.only(
               topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
           color: Colors.yellow,
         ),
         width: MediaQuery.of(context).size.width,
         height: 100,
         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Center(
               child: Container(
                   width: 70,
                   height: 70,
                   margin: EdgeInsets.only(right: 15),
                   child: Image(image: AssetImage('assets/images/cowSearch.png'),height: 50,)),
             ),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Flexible(
                     child: Text(
                       trip.title,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                     ),
                   ),


                   Row(
                     children: <Widget>[
                       Container(
                         child: Icon(
                           Icons.featured_video_sharp,
                           color: Colors.orangeAccent,
                           size: 20,
                         ),
                       ),
                       SizedBox(
                         width: 5,
                       ),
                       Flexible(
                         child: Container(
                           width: MediaQuery.of(context).size.width,
                           child: Text("ID: ${trip.code}",
                             /* style: TextStyle(
                                                color: primary, fontSize: 18, letterSpacing: .3)*/),
                         ),
                       ),

                     ],
                   ),
                   Row(
                 children: <Widget>[
                   Container(
                     child: Icon(
                       Icons.calendar_today,
                       color: Colors.blue,
                       size: 20,
                     ),
                   ),
                   SizedBox(
                     width: 5,
                   ),
                   Flexible(
                     child: Container(
                       width: MediaQuery.of(context).size.width,
                       child: Text("Fecha Nacimiento: ${trip.startDate.toString().substring(0,10)}",
                         /* style: TextStyle(
                                                color: primary, fontSize: 18, letterSpacing: .3)*/),
                     ),
                   ),

                 ],
               ),
                 ],
               ),
             ),
           ],
         ),

       ),
           onTap: (){
             Navigator.pushAndRemoveUntil(
                 context,
                 MaterialPageRoute(
                   builder: (context) => Home(currentUser: trip.currentUser,data: trip.code,),
                 ),
                     (route) => false);
           },
   );
}