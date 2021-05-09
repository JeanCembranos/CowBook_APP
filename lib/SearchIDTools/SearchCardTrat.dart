import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/ScreensNew/ConsTratamiento.dart';
import 'package:myfarm_app/SearchIDTools/HealthTrip.dart';


Widget buildTripCardTrat(BuildContext context, DocumentSnapshot document) {
  final trip = HealthTrip.fromSnapshot(document);

  return InkWell(
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff84DCEF).withOpacity(0.34),
          border: Border.all(color: Color(0xff84DCEF),width: 3.0)
      ),
      width: MediaQuery.of(context).size.width,
      height: 110,
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
                child: Image(image: AssetImage('assets/images/vacaTrat.png'),height: 50,)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      trip.fechaFin.difference(DateTime.now()).inDays<=0&&trip.fechaFin.difference(DateTime.now()).inHours<=1
                          ?"COMPLETADO":DateTime.now().difference(trip.fechaIni).inDays<=0&&DateTime.now().difference(trip.fechaIni).inHours<=5?"POR COMENZAR":"EN CURSO",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.watch_later_sharp,
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
                        child: Text("Fecha Inicio: ${trip.fechaIni.toString().substring(0,10)}",
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
                        child: Text("Fecha Fin: ${trip.fechaFin.toString().substring(0,10)}",
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
            builder: (context) => TratDetails(currentUser: trip.currentUser,data: trip.codigo,RegID: trip.RegID,),
          ),
              (route) => false);
    },
  );
}