import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/ScreensNew/ConsRegLeche.dart';
import 'package:myfarm_app/ScreensNew/Tabs/SearchDelMod.dart';


Widget buildSearchDelModCards(BuildContext context, DocumentSnapshot document) {
  final trip = SearchDelMod.fromSnapshot(document);


  return InkWell(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.yellow,
      ),
      width: MediaQuery.of(context).size.width,
      height: 80,
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
                child: Image(image: AssetImage('assets/images/leche.png'),height: 50,)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(trip.fechaReg.toString().substring(0,10),style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.leaderboard,
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
                        child: Text("Cantidad: ${trip.cant}",
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
            builder: (context) => RegLecheDetails(currentUser: trip.currentUser,data: trip.codigo,RegID: trip.RegID,),
          ),
              (route) => false);
    },
  );
}