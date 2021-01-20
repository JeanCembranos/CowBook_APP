import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/HomeTools/DBPublicity.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/HistorialMedicoSeleccion.dart';
import 'package:myfarm_app/Screens/Identification.dart';
import 'package:myfarm_app/Screens/Login.dart';
import 'package:myfarm_app/Screens/ObservacionesSeleccion.dart';
import 'package:myfarm_app/Screens/Settings.dart';

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

class _HomeState extends State<Home>{
  @override
  void initState() {
    print('Qr: ${widget.data}');
    print('Usuario: ${widget.currentUser}');
    super.initState();
    // Test if cloud firebase works
    //print(publicity.documents[0].data['name']);
  }
  Future getCarouselWidget() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("carousel").getDocuments();
    return qn.documents;
  }
  @override
  Widget build(BuildContext context)


  {
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

      body:SingleChildScrollView(
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
           /* FutureBuilder(
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
                      autoplay: true,
                      dotSize: 4.0,
                      indicatorBgPadding: 4.0,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 1000),
                    ));
              }
            }
          }),*/



                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  padding: const EdgeInsets.only(top:25.0),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        padding: const EdgeInsets.all(8),
                        child:Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top:30),
                                child: new Image.asset(
                                  'assets/images/histmedico.png',
                                  height: 70.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text("HISTORIAL MÉDICO",style: new TextStyle(fontSize: 15),),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.orangeAccent[100],
                      ),
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HealthHistSelection(data: widget.data,currentUser: widget.currentUser,),
                          ),
                              (route) => false,
                        );
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top:30),
                                child: new Image.asset(
                                  'assets/images/historial.png',
                                  height: 70.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text("NOVEDADES/OBSERVACIONES",style: new TextStyle(fontSize: 15),),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.orangeAccent[100],
                      ),
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            ObsSelection(data: widget.data,currentUser: widget.currentUser,)), (Route<dynamic> route) => false);
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top:10),
                                child: new Image.asset(
                                  'assets/images/vaca.png',
                                  height: 90.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text("DATOS DE IDENTIFICACIÓN",style: new TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.orangeAccent[100],
                      ),
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            Identification(data: widget.data,currentUser: widget.currentUser,)), (Route<dynamic> route) => false);
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top:10),
                                child: new Image.asset(
                                  'assets/images/ajustes.png',
                                  height: 90.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text("AJUSTES",style: new TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.orangeAccent[100],
                      ),
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            SettingsOnePage(data: widget.data,currentUser: widget.currentUser,)), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                )

          ],
        ) ,
      ) ,

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
}