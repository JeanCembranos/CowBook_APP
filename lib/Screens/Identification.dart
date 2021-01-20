import 'dart:async';

import 'package:flutter/material.dart';


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfarm_app/HomeTools/dbID.dart';

import 'Home.dart';


class Identification extends StatefulWidget{
  final String data;
  final String currentUser;


  Identification({
    this.data,
    this.currentUser
  });

  @override
  _IdentificationState createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification>{
  QuerySnapshot identificacion;
  dbID id=new dbID();
  File _image;
  String contents;
  dynamic result;

  @override
  void initState(){
    super.initState();
    id.getData().then((results){
      setState(() {
        identificacion = results;
      });
    });
  }
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>Home(currentUser: widget.currentUser,data: widget.data,),
                ),
                    (route) => false,
              );
            }),
        title: Text('IDENTIFICACIÓN',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _carList(),
    );
  }
  Widget _carList(){
    if (identificacion != null) {
      bool carflag = false;
      List<int> location = [];
      for(var y = 0; y < identificacion.documents.length; y++){
        if(identificacion.documents[y].data['codigo'] == widget.data){
          carflag = true;
          location.add(y);
        }
      }

      if(carflag == true){
        return ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.cyan,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image!=null)?Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ):Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/myfarmespe.appspot.com/o/CowImages%2Fvaca-1200x800.jpg?alt=media&token=535bb730-a9fb-453f-8063-8b7699341ed7",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  /*TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.drive_eta,color: Colors.black,size:30, ),
                            hintStyle: TextStyle(color: Colors.black),
                            labelText: snapshot.data.documents[indice]['car'],labelStyle: new  TextStyle(color: Colors.black,fontSize: 20),
                          ),
                        ),*/
                  Divider(
                    color: Colors.black,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.house,size: 30.0,color: Colors.black,),
                      title: Text('Nombre',style: new TextStyle(fontSize: 20.0),),
                      subtitle: Text(identificacion.documents[location[0]].data['nombre'],style: new TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.featured_video_sharp,size: 30.0,color: Colors.black,),
                      title: Text('Raza',style: new TextStyle(fontSize: 20.0),),
                      subtitle: Text(identificacion.documents[location[0]].data['raza'],style: new TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.watch_later_outlined,size: 30.0,color: Colors.black,),
                      title: Text('Peso',style: new TextStyle(fontSize: 20.0),),
                      subtitle: Text(identificacion.documents[location[0]].data['peso'],style: new TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.featured_video_sharp,size: 30.0,color: Colors.black,),
                      title: Text('Fecha Nacimiento',style: new TextStyle(fontSize: 20.0),),
                      subtitle: Text(identificacion.documents[location[0]].data['fechaNac'].toDate().toString(),style: new TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.watch_later_sharp,size: 30.0,color: Colors.black,),
                      title: Text('Edad Aproximada',style: new TextStyle(fontSize: 20.0),),
                      subtitle: Text((DateTime.now().year-identificacion.documents[location[0]].data['fechaNac'].toDate().year).toString(),style: new TextStyle(fontSize: 20.0),),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  /*TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline,color: Colors.black,size:30, ),
                            labelText: snapshot.data.documents[indice]['owner'],labelStyle: new  TextStyle(color: Colors.black,fontSize: 20),
                          ),
                        ),*/

                  /*TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.featured_video_sharp,color: Colors.black,size:30,),
                            labelText: snapshot.data.documents[indice]['license'],labelStyle: new  TextStyle(color: Colors.black,fontSize: 20),
                          ),
                        ),*/
                  /*TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone,color: Colors.black,size:30, ),
                            labelText: snapshot.data.documents[indice]['phone'].toString(),labelStyle: new  TextStyle(color: Colors.black,fontSize: 20),
                          ),
                        ),*/
                  /*TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.watch_later_outlined,color: Colors.black,size:30, ),
                            labelText: DateTime.now().difference(snapshot.data.documents[indice]['carCreated'].toDate()).toString().substring(0,7),labelStyle: new  TextStyle(color: Colors.black,fontSize: 20),
                          ),
                        ),*/
                  /*RaisedButton(
                            color: Colors.lightGreen,
                            child: new Text("LLAMAR",style: new TextStyle(color: Colors.white),),
                            onPressed: () async {
                              FlutterPhoneDirectCaller.callNumber(snapshot.data.documents[indice]['phone'].toString());
                            })*/
                ],
              ),
            )
          ],
        );

      }////////
      else{
        return new Scaffold(
          body: new Container(
            width: MediaQuery.of(context).size.width,
            child: new Center(
              child: ListView(
                children: [
                  new Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 80.0),
                        child: new Text("NO HAY REGISTROS EXISTENTES",style: new TextStyle(fontSize: 30,color: Colors.pinkAccent),textAlign: TextAlign.center,),
                      ),

                    ],
                  ),
                ],
              ),

            ),
          ),



        );
      }
    }
    else{
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.orangeAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 50.0,
                        child: Icon(
                          Icons.local_parking,
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "ParkingApp",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "LA MEJOR OPCIÓN",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      );
    }
  }
  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer timer = new Timer(new Duration(seconds: 1), () {
      setState(() {
      });
      completer.complete();
    });
    return completer.future;
  }
}
