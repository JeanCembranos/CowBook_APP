import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:myfarm_app/RegTools/DBProduLeche.dart';
import 'package:myfarm_app/RegTools/DBReg.dart';
import 'package:myfarm_app/RegTools/RegLecheModel.dart';
import 'package:myfarm_app/RegTools/RegModel.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Settings.dart';
import 'package:myfarm_app/ScreensNew/ProduccionLeche.dart';
import 'package:myfarm_app/ScreensNew/RegMedico.dart';

class CreateRegLeche extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _CreateRegLecheState createState() => _CreateRegLecheState();
  CreateRegLeche({
    this.data,
    this.currentUser
  });
}

class _CreateRegLecheState extends State<CreateRegLeche> {
  int _currentIndex = 0;
  String obs;
  DateTime selectedDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  bool _medHasError = true;
  final _formKey = GlobalKey<FormBuilderState>();

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
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SingleChildScrollView(
          child: new Column(
            children: [
              Align(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage("assets/images/CrearRegLeche.JPG"),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(height: 30.0),
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Text("Fecha de Registro",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width-70.0,
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
                          child: Text(selectedDate.toString().substring(0,10)),

                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: ClipOval(
                            child: Material(
                              color: Colors.orange, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(width: 56,
                                    height: 56,
                                    child: Icon(
                                      Icons.calendar_today_outlined,)),
                                onTap: () {
                                  _selectDate(context);
                                  // ignore: invalid_use_of_protected_member
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    FormBuilderTextField(
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
                          FormBuilderValidators.maxLength(context,30,errorText: "Este campo debe contener hasta un máximo de 30 caracteres"),
                        ]),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number
                    ),
                    Align(
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          if(_formKey.currentState.fields['cantidad'].validate()){
                            RegLecheModel  reg = RegLecheModel(_formKey.currentState.fields['cantidad'].value, selectedDate);
                            _addRegLeche(context, reg);
                          }
                        },
                        elevation: 4.0,
                        splashColor: Colors.green,
                        child: Text(
                          'GUARDAR',
                          style: TextStyle(color: Colors.green, fontSize: 25.0),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.green)
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              )


            ],

          ),
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
    );
  }
  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegLeche(data: widget.data,currentUser: widget.currentUser,),
      ),
          (route) => false,
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
  }
  void _addRegLeche(BuildContext context, RegLecheModel regLeche) async {
    String _returnString;
    String key=UniqueKey().toString();
    String code=key.substring(2,key.length-1);
    _returnString = await DBProduLeche().createGroup(regLeche, widget.data, widget.currentUser,code);
    if (_returnString == "success") {
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
        duration: Duration(seconds: 1),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        title: 'NOTIFICACIÓN',
        message: 'Registro Diario creado Correctamente',
      )..show(context).then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  RegLeche(currentUser: widget.currentUser,data: widget.data,),)
      ));
    }

  }
}