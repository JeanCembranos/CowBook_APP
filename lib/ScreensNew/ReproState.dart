
import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'package:myfarm_app/Screens/Home.dart';

class ReproScreen extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _ReproScreenState createState() => _ReproScreenState();
  ReproScreen({
    this.data,
    this.currentUser
  });
}

class _ReproScreenState extends State<ReproScreen>{
  DateTime InitialDate;
  DateTime FinalDate;
  File _image;
  final picker = ImagePicker();
  QuerySnapshot id;
  dbID idSearch = new dbID();

  void initState(){
    super.initState();
    idSearch.getData().then((results){
      setState(() {
        id = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: new AppBar(leading:
      IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Home(currentUser: widget.currentUser,data: widget.data,),
              ),
                  (route) => false,
            );
          }),
        backgroundColor: Colors.transparent,
        ),*/
      body: _idList()
    );
  }
  Widget _idList() {
    if (id != null) {
      bool carflag = false;
      List<int> location = [];
      for (var y = 0; y < id.documents.length; y++) {
        if (id.documents[y].data['code'] == widget.data&&id.documents[y].data['currentUser'] == widget.currentUser) {
          carflag = true;
          location.add(y);
        }
      }

      if (carflag == true) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: SingleChildScrollView(
            child: new Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        border: Border.all(color: Color(0xffF2B90F),width: 5)
                    ),
                    child: new Column(
                      children: [
                        Align(
                          child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Home(currentUser: widget.currentUser,data: widget.data,),
                                  ),
                                      (route) => false,
                                );
                              }),
                          alignment: Alignment.topLeft,
                        ),
                        SizedBox(height: 15.0,),
                        Align(
                          child: Text("ESTADO REPRODUCTIVO",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,),),
                          alignment: Alignment.topLeft,
                        ),
                        SizedBox(height: 30.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: new SizedBox(
                                    width: 180.0,
                                    height: 180.0,
                                    child: (_image!=null)?Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    ):Image.network(
                                      id.documents[location[0]].data['imageUrl'],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0,),
                        Text(id.documents[location[0]].data['name'],style: TextStyle(fontSize: 30.0),),
                        SizedBox(height: 30.0,),
                        Container(
                          width: MediaQuery.of(context).size.width-40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xffF2B90F).withOpacity(0.79),
                            border: Border.all(color: Color(0xffF2B90F),width: 10),
                          ),
                          child: new Column(
                            children: [
                              DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<120
                                  ? Text("TERNERA",style: TextStyle(fontSize: 30.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=120&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<180
                                  ? Text("DESTETADA",style: TextStyle(fontSize: 30.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=180&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<360
                                  ? Text("NOVILLA",style: TextStyle(fontSize: 30.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=360?Text("ADULTA VACÍA",style: TextStyle(fontSize: 30.0),):Text("INDEFINIDO",style: TextStyle(fontSize: 30.0),),

                              SizedBox(height: 20.0,),
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text("Fecha Inicio",style: TextStyle(fontSize: 20.0),),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left:85.0),
                                        child:  DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<120
                                            ?Text(id.documents[location[0]].data['birthDate'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=120&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<180
                                            ?Text(id.documents[location[0]].data['fechaIniDeste'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=180&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<360
                                            ?Text(id.documents[location[0]].data['fechaIniNovi'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=360
                                            ?Text(id.documents[location[0]].data['fechaIniAdulta'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):Text("NN-NN-NN")
                                    )
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              SizedBox(height: 20.0,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text("Fecha Finalización",style: TextStyle(fontSize: 20.0),),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left:25.0),
                                        child: DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<120
                                            ?Text(id.documents[location[0]].data['fechaIniDeste'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=120&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<180
                                            ?Text(id.documents[location[0]].data['fechaIniNovi'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=180&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<360
                                            ?Text(id.documents[location[0]].data['fechaIniAdulta'].toDate().toString().substring(0,10),style: TextStyle(fontSize: 15.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=360
                                            ?Text('',style: TextStyle(fontSize: 20.0),):Text("NN-NN-NN")
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Tiempo Restante",style: TextStyle(fontSize: 20.0),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:40.0),
                                    child:  DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<120
                                        ?Text('${id.documents[location[0]].data['fechaIniDeste'].toDate().difference(DateTime.now()).inDays.toString()} días',style: TextStyle(fontSize: 20.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=120&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<180
                                        ?Text('${id.documents[location[0]].data['fechaIniNovi'].toDate().difference(DateTime.now()).inDays.toString()} días',style: TextStyle(fontSize: 20.0),):DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays>=180&&DateTime.now().difference(id.documents[location[0]].data['birthDate'].toDate()).inDays<360
                                        ?Text('${id.documents[location[0]].data['fechaIniAdulta'].toDate().difference(DateTime.now()).inDays.toString()} días',style: TextStyle(fontSize: 20.0),):Text(""),
                                  )
                                ],
                              ),
                              // Text(id.documents[location[0]].data['birthDate'].toDate()+new DateTime(id.documents[location[0]].data['birthDate'].toDate().year, id.documents[location[0]].data['birthDate'].toDate().year, date.day);)

                            ],
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
        );
      }
    }
  }
  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Home(currentUser: widget.currentUser,data: widget.data,),
      ),
          (route) => false,
    );
  }
}