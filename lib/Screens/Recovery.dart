import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
      backgroundColor: Colors.white,
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
  bool _correoHasError = true;
  final _formKeyCorreo = GlobalKey<FormBuilderState>();
  var _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  child: Image.asset('assets/images/recovery.png',
                      width: screenAwareSize(250, context),
                      height: screenAwareSize(250, context),fit: BoxFit.cover,),
                ),
              ),
              SizedBox(
                height: screenAwareSize(30.0, context),
              ),
              FormBuilder(
                key: _formKeyCorreo,
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: "correo",
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          suffixIcon: _correoHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _correoHasError =
                            !_formKeyCorreo.currentState.fields['correo'].validate();
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,errorText: "Este campo no puede estar vacío"),
                          FormBuilderValidators.email(context,errorText: "Ingrese un Correo Electrónico Válido"),
                          FormBuilderValidators.maxLength(context,100,errorText: "Correo debe contener máximo 100 caracteres")
                        ]),
                        textInputAction: TextInputAction.next,
                      ),
                      ]
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0),
                child: Align(
                  child:  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      if(_formKey.currentState.validate()&&_formKeyCorreo.currentState.fields['correo'].validate()){
                        //FirebaseAuth.instance.sendPasswordResetEmail(email: _formKeyCorreo.currentState.fields['correo'].value).then((value) => showSnackBar(context));
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        _auth.sendPasswordResetEmail(email: _formKeyCorreo.currentState.fields['correo'].value ).then((doc) {
                          showSnackBar(context);
                        }).catchError((err) {
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
                            duration: Duration(seconds: 2),
                            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                            forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                            title: 'ERROR',
                            message: 'Correo electrónico inválido',
                          )..show(context);
                        });
                      }
                    },
                    elevation: 4.0,
                    splashColor:  Colors.blue[400],
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


                /*GestureDetector(
                  onTap: () {
                    if(_formKey.currentState.validate()&&_formKeyCorreo.currentState.fields['correo'].validate()){
                      FirebaseAuth.instance.sendPasswordResetEmail(email: _formKeyCorreo.currentState.fields['correo'].value).then((value) => showSnackBar(context));
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
                ),*/
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
      duration: Duration(seconds: 2),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'SOLICITUD DE RECUPERACIÓN ENVIADA CORRECTAMENTE',
      message: 'Revise la bandeja de entrada de su Correo Electrónico',
    )..show(context);
  }
}

