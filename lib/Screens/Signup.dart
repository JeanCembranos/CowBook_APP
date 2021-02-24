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
    return Container(
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
                    FormBuilderValidators.required(context),
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
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
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
                    FormBuilderValidators.required(context),
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
                    FormBuilderValidators.required(context),
                  ]),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20.0,),
                Align(
                  child:  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      /*if(_formKey.currentState.fields['contrasena'].value ==_formKey.currentState.fields['contrasenaConfirm'].value  && (_formKey.currentState.fields['contrasena'].value!="" && _formKey.currentState.fields['contrasenaConfirm'].value!="")){
                        for(int i=0;i<_formKey.currentState.fields['correo'].value.length;i++) {
                          if (!_formKey.currentState.fields['correo'].value.characterAt(i).contains(" ")) {
                            _signUpUser(
                                _formKey.currentState.fields['correo'].value, _formKey.currentState.fields['contrasena'].value,
                                context, _formKey.currentState.fields['nombre'].value);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()), (
                                route) => false);
                            break;
                          }else{
                            _formKey.currentState.fields['correo'].setValue( _formKey.currentState.fields['correo'].value.substring(0,i));
                            _signUpUser(_formKey.currentState.fields['correo'].value, _formKey.currentState.fields['contrasena'].value, context, _formKey.currentState.fields['nombre'].value);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder:(context) =>Login()),(route) => false);
                            break;
                          }
                        }
                      }else{
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password do not match"),
                            duration: Duration(seconds:2),
                          ),
                        );
                      }*/
                      _signUpUser(
                          _formKey.currentState.fields['correo'].value, _formKey.currentState.fields['contrasena'].value,
                          context, _formKey.currentState.fields['nombre'].value);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()), (
                          route) => false);
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
        ],
      ),
    );
  }
  void _signUpUser(String email, String password, BuildContext context, String fullName) async{
    try{
      String _returnString = await Auth().signUpUser(email,password,fullName);
      if (_returnString == "success"){
        Navigator.pop(context);
      } else{
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch(e){
      print(e);
    }
  }
}