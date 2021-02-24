import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/HomeTools/DBPublicity.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/Login.dart';
import 'package:myfarm_app/Screens/Settings.dart';
import 'package:myfarm_app/ScreensNew/IDConsulta.dart';
import 'package:myfarm_app/ScreensNew/RegMedico.dart';
import 'package:myfarm_app/ScreensNew/ReproState.dart';

import '../AdMob.dart';

class Home extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _HomeState createState() => _HomeState();

  Home({
    this.data,
    this.currentUser
  });
}


class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [];


  @override
  void initState() {
    print('Qr: ${widget.data}');
    print('Usuario: ${widget.currentUser}');
    super.initState();
  }



  Future getCarouselWidget() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("carousel").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.blue,
      /*appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('My Farm'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],

      ),*/

      body: SingleChildScrollView(
        child: Column(
          children: [
            /*SizedBox(
              height: 210.0,
              width: double.infinity,
              child: new Carousel(
                boxFit: BoxFit.cover,
                dotColor: Colors.white.withOpacity(0.8),
                dotSize: 5.5,
                dotSpacing: 16.0,
                dotBgColor: Colors.transparent,
                showIndicator: true,
                overlayShadow: true,
                overlayShadowColors: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
                overlayShadowSize: 0.25,
                images: [
                  AssetImage(
                    'assets/images/1.jpg',
                  ),
                  AssetImage(
                    'assets/images/2.jpg',
                  ),
                  AssetImage(
                    'assets/images/3.jpg',
                  ),
                ],
              )),*/
            FutureBuilder(
        future: getCarouselWidget(),
          builder: (context, AsyncSnapshot snapshot) {
            List<NetworkImage> list = new List<NetworkImage>();
            if (snapshot.connectionState == ConnectionState.waiting) {
                    return new CircularProgressIndicator();
                  } else {
              if (snapshot.hasError) {
                return new Text("fetch error");
              } else {
                for(int i = 0; i < snapshot.data.length; i++ ) {
                  list.add(NetworkImage(snapshot.data[i].data["url"]));
                }
                return new Container(
                    height: 250.0,
                    child: new Carousel(
                      boxFit: BoxFit.cover,
                      images: list,
                      autoplay: false,
                      dotSize: 4.0,
                      indicatorBgPadding: 4.0,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 1000),
                    ));
              }
            }
          }),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.only(right:MediaQuery.of(context).size.width-100),
              child: new Text("Recordatorios"),
            ),
            SizedBox(
              height: 15.0,
            ),
            new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.orange.withOpacity(0.37),
                border: Border.all(color: Colors.orange,width: 5)
              ),
              width: MediaQuery.of(context).size.width-10,
              height: 80.0,
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsets.all(15.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xff84DCEF).withOpacity(0.34),
                      border: Border.all(color: Color(0xff84DCEF),width: 10.0)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: new Image.asset(
                              'assets/images/Info.png',
                              height: 70.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,

                              ),
                              child:  Text("Identificación",
                                style: new TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                           ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IDSearch(data: widget.data,currentUser: widget.currentUser,),
                      ),
                          (route) => false,
                    );
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xff84DCEF).withOpacity(0.34),
                        border: Border.all(color: Color(0xff84DCEF),width: 10.0)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: new Image.asset(
                              'assets/images/estadistica.png',
                              height: 90.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,

                              ),
                              child:  Text("Producción Leche",
                                style: new TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  /*Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xffC4C4C4),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: new Image.asset(
                              'assets/images/estadistica.png',
                              height: 70.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("Producción Leche",
                              style: new TextStyle(fontSize: 15),),
                          ),
                        ],
                      ),
                    )
                  ),*/
                  onTap: () {
                    /*Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) =>
                            ObsSelection(data: widget.data,
                              currentUser: widget.currentUser,)), (
                        Route<dynamic> route) => false);*/
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xff84DCEF).withOpacity(0.34),
                        border: Border.all(color: Color(0xff84DCEF),width: 10.0)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: new Image.asset(
                              'assets/images/vaca.png',
                              height: 70.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,

                              ),
                              child:  Text("Estado Reproductivo",
                                style: new TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  /*Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xffC4C4C4),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: new Image.asset(
                              'assets/images/vaca.png',
                              height: 90.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("ESTADO REPRODUCTIVO",
                              style: new TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  ),*/
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) =>
                            ReproScreen(data: widget.data,currentUser:widget.currentUser)), (
                        Route<dynamic> route) => false);
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xff84DCEF).withOpacity(0.34),
                        border: Border.all(color: Color(0xff84DCEF),width: 10.0)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: new Image.asset(
                              'assets/images/medicina.png',
                              height: 85.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,

                              ),
                              child:  Text("Estado Médico",
                                style: new TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),





                  /*Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xffC4C4C4),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: new Image.asset(
                              'assets/images/ajustes.png',
                              height: 90.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "ESTADO MÉDICO", style: new TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  ),*/
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) =>
                            RegMedico(data: widget.data,
                              currentUser: widget.currentUser,)), (
                        Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Ajustes')
          )
        ],
      ),

      /*body: new Center(
        child: new Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: Text("BIENVENIDO",style: new TextStyle(fontSize: 30.0),),
            ),
            SizedBox(height: 20.0,),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.asset('assets/images/farmlogo.jpg',
                  width: screenAwareSize(300, context),
                  height: screenAwareSize(300, context)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        elevation: 20.0,
        onTap: (value) async {
          /*final routes = [Scanner(currentUser: currentUid),Earnings(),Eliminate()];
          _currentIndex = value;*/
          /*  if(value == 2){
            bool _returnString;
            Eliminate();*/
          //_returnString  = await Auth().deleteCurrentUser(currentUid,currentEmail);
          /* _signOut(context);*/
          // } else{
          /*Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => routes[value],
              ),
                  (Route<dynamic> route) => true);//}*/
        },
        //currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.qr_code,color: Colors.white,),
            title: new Text('Escanear',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_box,color: Colors.white,),
            title: new Text('Eliminar Cuenta',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings,color: Colors.white,),
            title: new Text('Ajustes',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
          ),
        ],
      ),*/

    );
  }
  void _signOut(BuildContext context) async {
    String _returnString = await Auth().signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
            (route) => false,
      );
    }
  }
  void onTabTapped(int index) {
    switch(index){
      case 0: {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(data: widget.data,currentUser: widget.currentUser,),
          ),
              (route) => false,
        );
      }
      break;
      case 1: {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsOnePage(data: widget.data,currentUser: widget.currentUser,),
          ),
              (route) => false,
        );
      }
      break;
    }
    setState(() {
      _currentIndex = index;
    });
  }
}