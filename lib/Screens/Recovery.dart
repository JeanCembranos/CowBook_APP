import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/Login.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffbE29A2D),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20.0),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder:(context) =>Login()),(route) => false);
                          })
                        ],
                      ),
                      SizedBox(
                          height: screenAwareSize(20, context)
                      ),
                      Signupform()
                    ],
                  )
              )
            ],
          ),
    );
  }
}
class Signupform extends StatefulWidget {
  @override
  _SignupformState createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  TextEditingController _emailController = TextEditingController();
  var _formKey=GlobalKey<FormState>();
  String email="";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              Text("RECUPERACIÓN",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenAwareSize(30.0, context),
                      fontWeight: FontWeight.normal,
                      fontFamily: "Montserrat-Bold")),
              SizedBox(
                height: screenAwareSize(5.0, context),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Image.asset('assets/images/llave.png',
                            width: screenAwareSize(180, context),
                            height: screenAwareSize(180, context)),
                      ),
                    ),
                  ]),
              SizedBox(
                height: screenAwareSize(30.0, context),
              ),
              Padding(
                padding: EdgeInsets.only(right: 175),
                child: Text("Correo Electrónico",style: new TextStyle(color: Colors.white),),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: new Container(
                  width: 340,
                  height: 30,
                  child: new TextField(
                    controller: _emailController,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(40.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: screenAwareSize(80.0, context),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    if(_formKey.currentState.validate()&&!_emailController.text.contains(" ")){
                      FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value) => showSnackBar(context));
                    }else{
                      Flushbar(
                        borderRadius: 8,
                        backgroundGradient: LinearGradient(
                          colors: [Colors.red.shade800,Colors.redAccent.shade700],
                          stops: [0.6,1],
                        ),
                        boxShadows: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(3, 3),
                            blurRadius: 3,
                          )
                        ],
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                        title: 'ERROR',
                        message: 'Correo electrónico inválido',
                      )..show(context);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 170,
                    color: Colors.white,
                    child: new RaisedButton(
                      color: Colors.grey,
                      child: Text("ENVIAR SOLICITUD",style: new TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
  Flushbar showSnackBar(BuildContext context){
    return Flushbar(
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.green.shade800,Colors.greenAccent.shade700],
        stops: [0.6,1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        )
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'SOLICITUD DE RECUPERACIÓN ENVIADA CORRECTAMENTE',
      message: 'Revise la bandeja de entrada de su Correo Electrónico',
    )..show(context);
  }
}

