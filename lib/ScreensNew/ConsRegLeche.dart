import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:myfarm_app/RegTools/DBProduLeche.dart';
import 'package:myfarm_app/RegTools/DBReg.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Settings.dart';
import 'package:myfarm_app/ScreensNew/ProduccionLeche.dart';
import 'package:myfarm_app/ScreensNew/RegMedico.dart';
import 'dart:io';

class RegLecheDetails extends StatefulWidget{
  final String RegID;
  final String data;
  final String currentUser;
  @override
  _RegLecheDetailsState createState() => _RegLecheDetailsState();
  RegLecheDetails({
    this.RegID,
    this.data,
    this.currentUser
  });
}

class _RegLecheDetailsState extends State<RegLecheDetails> {

  DateTime selectedIniDate = DateTime.now();
  DateTime selectedFinalDate = DateTime.now();

  bool flagA=true,flagB=true;
  QuerySnapshot RegLecheDB;
  DBProduLeche objRegLeche = new DBProduLeche();
  bool flag=true;
  int _currentIndex = 0;
  String obs;
  bool _medHasError = false;
  bool _ObsHasError = false;
  final _formKey = GlobalKey<FormBuilderState>();


  @override
  void initState() {
    super.initState();
    objRegLeche.getData().then((results){
      setState(() {
        RegLecheDB = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading:
        IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegLeche(
                        currentUser: widget.currentUser, data: widget.data,),
                ),
                    (route) => false,
              );
            }),
        backgroundColor: Colors.white,
      ),
      body: _RegList(),
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
    );
  }

  Widget _RegList(){
    if (RegLecheDB != null) {
      bool carflag = false;
      List<int> location = [];

      for (var y = 0; y < RegLecheDB.documents.length; y++) {
        if (RegLecheDB.documents[y].data['currentUser'] == widget.currentUser&&RegLecheDB.documents[y].data['codigo'] == widget.data&&RegLecheDB.documents[y].data['RegID']==widget.RegID) {
          carflag = true;
          location.add(y);
          print(carflag);
        }
      }

      if (carflag == true) {
        return ListView.builder(
            itemCount: location.length,
            padding: EdgeInsets.all(5.0),

            itemBuilder:(context,i){
              return SingleChildScrollView(
                child: new Column(
                  children: [
                    Align(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 10,
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage("assets/images/CreTratLogo.png"),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      skipDisabled: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha de Registro",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width-90.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        )
                                    )
                                ),
                                child:flagA
                                    ? Text(RegLecheDB.documents[location[i]].data['fechaReg'].toDate().toString().substring(0,10))
                                    :Text(selectedIniDate.toString().substring(0,10)),

                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: flag==false
                                    ? ClipOval(
                                  child: Material(
                                    color: Colors.orange, // button color
                                    child: InkWell(
                                      splashColor: Colors.red, // inkwell color
                                      child: SizedBox(width: 56, height: 56, child: Icon(Icons.calendar_today_outlined,)),
                                      onTap: () {
                                        flagA=false;
                                        _selectIniDate(context);
                                      },
                                    ),
                                  ),
                                )
                                    : Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                ),
                              ),
                            ],
                          ),
                          FormBuilderTextField(
                              readOnly: flag
                                  ? true
                                  : false,
                              initialValue: RegLecheDB.documents[location[i]].data['cantProd'],
                            autovalidateMode: AutovalidateMode.always,
                            name: "cantidad",
                            decoration: InputDecoration(
                              labelText: 'Cantidad de Leche Producida (Litros)',
                              suffixIcon: _medHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check, color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _medHasError =
                                !_formKey.currentState.fields['cantidad'].validate();
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,errorText: "Este campo no puede estar vacío"),
                              FormBuilderValidators.maxLength(context,30,errorText: "Este campo debe contener hasta un máximo de 50 caracteres"),
                            ]),
                            textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number
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
                                        selectedIniDate=RegLecheDB.documents[location[i]].data['fechaReg'].toDate();
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
                                          var SelectedDoc=RegLecheDB.documents[location[i]].documentID.toString();
                                          objRegLeche.deleteReg(SelectedDoc);
                                          Flushbar(
                                            borderRadius: 8,
                                            backgroundGradient: LinearGradient(
                                              colors: [Colors.green.shade800,Colors.green.shade700],
                                              stops: [0.6,1],
                                            ),
                                            boxShadows: [
                                              BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(3, 3),
                                                blurRadius: 3,
                                              )
                                            ],
                                            duration: Duration(seconds: 2),
                                            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                            forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                                            title: 'NOTIFICACIÓN',
                                            message: 'Reporte Inidividual Eliminado Correctamente',
                                          )..show(context).then((value) => Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => RegLeche(currentUser: widget.currentUser,data: widget.data,))
                                          ));
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
                                    if(_formKey.currentState.fields['cantidad'].validate()){
                                      var SelectedDoc=RegLecheDB.documents[location[i]].documentID.toString();
                                      print(RegLecheDB.documents[location[i]].documentID.toString());
                                      objRegLeche.updateRegLeche(SelectedDoc, {'fechaReg':selectedIniDate,'cantProd':_formKey.currentState.fields['cantidad'].value});
                                      flag=true;
                                      Flushbar(
                                        borderRadius: 8,
                                        backgroundGradient: LinearGradient(
                                          colors: [Colors.green.shade800,Colors.green.shade700],
                                          stops: [0.6,1],
                                        ),
                                        boxShadows: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(3, 3),
                                            blurRadius: 3,
                                          )
                                        ],
                                        duration: Duration(seconds: 2),
                                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                                        title: 'NOTIFICACIÓN',
                                        message: 'Registro modificado Correctamente',
                                      )..show(context).then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  RegLecheDetails(currentUser: widget.currentUser,data: widget.data,RegID: widget.RegID,))
                                      ));
                                    }
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    )


                  ],

                ),
              );
            }

        );
      }
    }
  }


  Future<void> _selectIniDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedIniDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedIniDate)
      setState(() {
        selectedIniDate = picked;
      });
  }
  Future<void> _selectFinalDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFinalDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFinalDate)
      setState(() {
        selectedFinalDate = picked;
      });
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