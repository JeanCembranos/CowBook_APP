import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfarm_app/IDTools/IDModel.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:path/path.dart';

class IDCreate extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _IDCreateState createState() => _IDCreateState();
  IDCreate({
    this.data,
    this.currentUser
  });
}

class _IDCreateState extends State<IDCreate>{
  File _image;
  String image_url;
  final picker = ImagePicker();
  dbID idCreate = new dbID();
  DateTime selectedDate = DateTime.now();
  bool _nameHasError = true;
  bool _razaHasError = true;
  bool _birthDateHasError = false;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC4C4C4),
        title: Text('REGISTRO INDIVIDUAL',
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                    CircleAvatar(
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
                          "https://images.unsplash.com/photo-1542158921223-4939bbed53f1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80",
                          fit: BoxFit.fill,
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
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
                    ],
                  )
                ),
              ],
            ),
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              skipDisabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name:"Nombre",
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Vaca',
                      suffixIcon: _nameHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _nameHasError =
                        !_formKey.currentState.fields['Nombre'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name:"Raza",
                    decoration: InputDecoration(
                      labelText: 'Raza de la Vaca',
                      suffixIcon: _razaHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _razaHasError =
                        !_formKey.currentState.fields['Raza'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("Fecha de Nacimiento",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16.0),),
                  Row(
                    children: [
                      SizedBox(height: 20.0,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.black)
                        ),
                        width: MediaQuery.of(context).size.width-80,
                        height: 20.0,
                        child: new Text("${selectedDate.toLocal()}".split(' ')[0],textAlign: TextAlign.center,style: TextStyle(fontSize: 17.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child:  ClipOval(
                          child: Material(
                            color: Colors.orange, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(width: 56, height: 56, child: Icon(Icons.calendar_today_outlined,)),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Align(
                   child: RaisedButton(
                     color: Colors.white,
                     onPressed: () {
                       IDModel id=IDModel(_formKey.currentState.fields['Nombre'].value,_formKey.currentState.fields['Raza'].value,selectedDate);
                       _addID(context, id);

                     },
                     elevation: 4.0,
                     splashColor:  Colors.blue[400],
                     child: Text(
                       'GUARDAR',
                       style: TextStyle(color: Colors.red, fontSize: 25.0),
                     ),
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(18.0),
                         side: BorderSide(color: Colors.red)
                     ),
                   ),
                    alignment: Alignment.center,
                    ),
                ],
              ),

            )
            /*Text("Nombre de la Vaca",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xffC4C4C4),
              ),
              width: MediaQuery.of(context).size.width,
              height: 40.0,
            ),
            SizedBox(height: 40.0,),
            Text("Raza de la Vaca",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xffC4C4C4),
              ),
              width: MediaQuery.of(context).size.width,
              height: 40.0,
            ),
            SizedBox(height: 40.0,),
            Text("Fecha de Nacimiento",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xffC4C4C4),
              ),
              width: MediaQuery.of(context).size.width,
              height: 40.0,
            ),
            SizedBox(height: 20.0,),
            Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-80),
                child: Row(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 56, height: 56, child: Icon(Icons.edit,)),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:35.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.red, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(width: 56, height: 56, child: Icon(Icons.delete,)),
                            onTap: () {},
                          ),
                        ),
                      ),
                    )
                  ],
                )
            )*/
          ],
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
  void _addID(BuildContext context, IDModel idCre) async {
    String _returnString;
    if(_image!=null){
      String fileName = basename(_image?.path);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('CowImages/$fileName');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      image_url = await taskSnapshot.ref.getDownloadURL();
    }else{
      image_url = "https://firebasestorage.googleapis.com/v0/b/myfarmespe.appspot.com/o/CowImages%2Fvaca-1200x800.jpg?alt=media&token=535bb730-a9fb-453f-8063-8b7699341ed7";
    }

    _returnString = await dbID().createID(widget.data, widget.currentUser, idCre,image_url);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(currentUser: widget.currentUser,data: widget.data,),
        ),
            (route) => false,
      );
    }

  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    //Check for valid file
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        return;
      }
    });
  }

}