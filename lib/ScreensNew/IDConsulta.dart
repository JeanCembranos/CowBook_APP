import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/ScannerQR.dart';

class IDSearch extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _IDSearchState createState() => _IDSearchState();
  IDSearch({
    this.data,
    this.currentUser
  });
}

class _IDSearchState extends State<IDSearch>{
  DateTime fechaFinTer,fechainiDeste,fechaFinDeste,fechaIniNovi,fechaFinNovi,fechaIniAdulta;
  bool flag=true;
  DateTime selectedDate = DateTime.now();
  bool _nameHasError = false;
  bool _razaHasError = false;
  bool _birthDateHasError = false;
  final _formKey = GlobalKey<FormBuilderState>();

  File _image;
  final picker = ImagePicker();
  QuerySnapshot id;
  dbID idSearch = new dbID();
  @override
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
      appBar: AppBar(
        backgroundColor: Color(0xffC4C4C4),
        leading: IconButton(
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
      body: _idList(),
    );
  }
  Widget _idList() {
    if (id != null) {
      bool carflag = false;
      List<int> location = [];
      for (var y = 0; y < id.documents.length; y++) {
        if (id.documents[y].data['code'] == widget.data) {
          carflag = true;
          location.add(y);
        }
      }

      if (carflag == true) {
        return new SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.0,),
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
                            id.documents[location[0]].data['imageUrl'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
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
                      readOnly: flag
                          ? true
                          : false,
                      initialValue: id.documents[location[0]].data['name'],
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
                      readOnly: flag
                          ? true
                          : false,
                      initialValue: id.documents[location[0]].data['raza'],
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
                          child: flag
                          ? new Text(id.documents[location[0]].data['birthDate'].toDate().toString().substring(0,10)):new Text(selectedDate.toString().substring(0,10)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: flag==false
                          ? ClipOval(
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
                          )
                          : Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-80),
                      child: flag==true
                          ?
                      Row(
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.orange, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(width: 56, height: 56, child: Icon(Icons.edit,)),
                                onTap: () {
                                  flag=false;
                                  selectedDate=id.documents[location[0]].data['birthDate'].toDate();
                                  setState(() {
                                  });
                                },
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
                                  onTap: () {
                                    var SelectedDoc=id.documents[location[0]].documentID.toString();
                                    idSearch.deleteID(SelectedDoc);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Scanner(currentUser: widget.currentUser),
                                      ),
                                          (route) => false,
                                    );

                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ):Column(
                        children: [
                          RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              calcFechas(selectedDate);
                              var SelectedDoc=id.documents[location[0]].documentID.toString();
                              print(id.documents[location[0]].documentID.toString());
                              idSearch.updateID(SelectedDoc, {'name':_formKey.currentState.fields['Nombre'].value,'raza':_formKey.currentState.fields['Raza'].value,'birthDate':selectedDate,'fechaIniDeste':fechainiDeste,'fechaIniNovi':fechaIniNovi,'fechaIniAdulta':fechaIniAdulta});
                              flag=true;
                              setState(() {

                              });
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
                          RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              flag=true;
                              setState(() {

                              });
                            },
                            elevation: 4.0,
                            splashColor:  Colors.blue[400],
                            child: Text(
                              'CANCELAR',
                              style: TextStyle(color: Colors.red, fontSize: 25.0),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              )
             /* SizedBox(height: 30.0,),
              Text("Nombre de la Vaca",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 20.0,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xffC4C4C4),
                ),
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                child: Text(id.documents[location[0]].data['name'],style: new TextStyle(fontSize: 20.0),),
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
                child: Text(id.documents[location[0]].data['raza'],style: new TextStyle(fontSize: 20.0),),
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
                child: Text(id.documents[location[0]].data['birthDate'].toDate().toString().substring(0,10),style: new TextStyle(fontSize: 20.0),),
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
                            onTap: () {
                              var SelectedDoc=id.documents[location[0]].documentID.toString();
                              print(id.documents[location[0]].documentID.toString());
                              idSearch.updateID(SelectedDoc, {'name':'Muuuuuu','raza':'vacaFlaca'});
                            },
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
                              onTap: () {
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  )child: Row(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.orange, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(width: 56, height: 56, child: Icon(Icons.edit,)),
                            onTap: () {
                              var SelectedDoc=id.documents[location[0]].documentID.toString();
                              print(id.documents[location[0]].documentID.toString());
                              idSearch.updateID(SelectedDoc, {'name':'Muuuuuu','raza':'vacaFlaca'});
                            },
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
                              onTap: () {
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              )*/
            ],
          ),
        );
      }
    }
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
  calcFechas(DateTime inicio){
    fechaFinTer=new DateTime(inicio.year,inicio.month+4,inicio.day);
    fechainiDeste=new DateTime(inicio.year,inicio.month+4,inicio.day);
    fechaFinDeste=new DateTime(inicio.year,inicio.month+6,inicio.day);
    fechaIniNovi=new DateTime(inicio.year,inicio.month+6,inicio.day);
    fechaFinNovi=new DateTime(inicio.year,inicio.month+12,inicio.day);
    fechaIniAdulta=new DateTime(inicio.year,inicio.month+12,inicio.day);

  }

}