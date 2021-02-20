/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:myfarm_app/HomeTools/CowModel.dart';
import 'package:myfarm_app/HomeTools/dbID.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'dart:io';
import 'package:path/path.dart';


class CreateID extends StatefulWidget{
  final String data;
  final String currentUser;
  CreateID({
    this.data,
    this.currentUser
  });
  @override
  _CreateIDState createState() => _CreateIDState();
}

class _CreateIDState extends State<CreateID>{
  dbID id=new dbID();
  DateTime selectedDate = DateTime.now();
  File _image;
  String contents;
  dynamic result;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _pesoController = TextEditingController();
  TextEditingController _razaController = TextEditingController();
  @override
  void initState(){

    super.initState();
  }
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  void _addCow(BuildContext context, CowModel cow) async {
    String _returnString;
    /*if(_image!=null){
      String fileName = basename(_image?.path);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('carros/$fileName');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      image_url = await taskSnapshot.ref.getDownloadURL();
    }else{
      image_url = "https://firebasestorage.googleapis.com/v0/b/parking-1f14e.appspot.com/o/images%2FnoPhotoImage.jpg?alt=media&token=594a1610-554c-4058-add9-f2cee60cfcc2";
    }*/
    _returnString = await id.createGroup(cow,widget.data, widget.currentUser);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>Home(data: widget.data,currentUser: widget.currentUser),
        ),
            (route) => false,
      );
    }

  }

  /*Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    //Check for valid file
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        return;
      }
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Edit Profile',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) =>  Container(
          width: MediaQuery.of(context).size.width,
          child:ListView(
            children: [
              Column(
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
                          backgroundColor: Colors.blue[900],
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
                      Padding(
                        padding: EdgeInsets.only(top: 60.0),
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30.0,
                          ),
                          /*onPressed: () {
                        getImage();
                      },*/
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.drive_eta,color: Colors.black ),
                        hintText: "Nombre",
                        hintStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _pesoController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline,color: Colors.black ),
                        hintText: "Peso",
                        hintStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _razaController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.drive_eta,color: Colors.black ),
                        hintText: "Raza/Cruce",
                        hintStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 45.0),
                    child: Text("Fecha Nacimiento"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 45.0),
                    child: Row(
                      children: [
                        new Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width/3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              left: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              right: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: new Text("${selectedDate.toLocal()}".split(' ')[0],textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: RaisedButton(
                            onPressed: () => _selectDate(context),
                            color: Colors.grey,
                            child: Text('Seleccionar Fecha'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      RaisedButton(
                        color: Colors.blue[900],
                        onPressed: () {
                          CowModel cowM=CowModel(_nombreController.text,_razaController.text,_pesoController.text,selectedDate);
                          _addCow(context,cowM);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(currentUser: widget.currentUser,data: widget.data,),
                            ),
                                (route) => false,
                          );
                        },
                        elevation: 4.0,
                        splashColor:  Colors.blue[400],
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}*/
