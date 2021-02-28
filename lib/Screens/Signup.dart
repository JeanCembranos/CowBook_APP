import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Login.dart';

class Signup extends StatelessWidget {
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
  bool _nombreHasError = true;
  bool _correoHasError = true;
  bool _passwordHasError = true;
  bool _passwordConfirmHasError = true;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        child: Column(
          children: [
            new Container(
              width: MediaQuery.of(context).size.width,
              height:190.0,
              child: ClipRRect(
                child: Image.asset('assets/images/signup.png',
                  width: screenAwareSize(250, context),
                  height: screenAwareSize(250, context),fit: BoxFit.cover,),
              ),
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
                    name: "nombre",
                    decoration: InputDecoration(
                      labelText: 'Nombre del titular',
                      suffixIcon: _nombreHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _nombreHasError =
                        !_formKey.currentState.fields['nombre'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.maxLength(context,50,errorText: "Correo debe contener máximo 50 caracteres"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
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
                        !_formKey.currentState.fields['correo'].validate();
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.email(context,errorText: "Ingrese un Correo Electrónico Válido"),
                      FormBuilderValidators.maxLength(context,100,errorText: "Correo debe contener máximo 100 caracteres")
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.always,
                    name: "contrasena",
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: _passwordHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _passwordHasError =
                        !_formKey.currentState.fields['contrasena'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.minLength(context, 8,errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                      FormBuilderValidators.maxLength(context, 16,errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.always,
                    name: "contrasenaConfirm",
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      suffixIcon: _passwordHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _passwordHasError =
                        !_formKey.currentState.fields['contrasenaConfirm'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.minLength(context, 8,errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                      FormBuilderValidators.maxLength(context, 16,errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20.0,),
                  Align(
                    child:  RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        if(_formKey.currentState.fields['contrasena'].value==_formKey.currentState.fields['contrasenaConfirm'].value){
                          if(_formKey.currentState.fields['correo'].validate()&&_formKey.currentState.fields['nombre'].validate()&&_formKey.currentState.fields['contrasena'].validate()){
                            _signUpUser(
                                _formKey.currentState.fields['correo'].value, _formKey.currentState.fields['contrasena'].value,
                                context, _formKey.currentState.fields['nombre'].value);
                          }
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
                            duration: Duration(seconds: 2),
                            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                            forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                            title: 'ERROR',
                            message: 'Contraseñas no Coinciden',
                          )..show(context);
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Login(),
      ),
          (route) => false,
    );
  }
  void _signUpUser(String email, String password, BuildContext context, String fullName) async{
    try{
      String _returnString = await Auth().signUpUser(email,password,fullName);
      if (_returnString == "success"){
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
          duration: Duration(seconds: 3),
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
          title: 'NOTIFICACIÓN',
          message: 'Usuario Creado Correctamente',
        )..show(context).then((value) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  Login())
        ));
      } else{
        Flushbar(
          borderRadius: 8,
          backgroundGradient: LinearGradient(
            colors: [Colors.red.shade800,Colors.red.shade700],
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
          message: 'Usuario ya creado Anteriormente',
        )..show(context);
      }
    } catch(e){
      print(e);
    }
  }
}