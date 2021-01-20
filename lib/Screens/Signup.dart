import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Login.dart';

class Signup extends StatelessWidget {
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
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("REGISTRO USUARIOS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenAwareSize(40.0, context),
                        fontWeight: FontWeight.normal,
                        fontFamily: "Montserrat-Bold")),
              ),
              SizedBox(
                height: screenAwareSize(40, context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Nombre de Usuario",style: new TextStyle(color: Colors.white),),
              ),
              SizedBox(
                height: 10,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: new TextField(
                  controller: _fullnameController,
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
              SizedBox(
                height: screenAwareSize(20, context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Correo Electrónico",style: new TextStyle(color: Colors.white),),
              ),
              SizedBox(
                height: 10,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
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
              SizedBox(
                height: screenAwareSize(20, context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Contraseña",style: new TextStyle(color: Colors.white),),
              ),
              SizedBox(
                height: 10,
              ),

              new Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: new TextField(
                  controller: _passwordController,
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
              SizedBox(
                height: screenAwareSize(20, context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Confirmar Contraseña",style: new TextStyle(color: Colors.white),),
              ),
              SizedBox(
                height: 10,
              ),
              /*Padding(
                padding: EdgeInsets.only(left: 10),
                child: new Container(
                  width: 340,
                  height: 30,
                  child: new TextField(
                    obscureText: true,
                    controller: _confirmPasswordController,
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
              ),*/
              new Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: new TextField(
                  controller: _confirmPasswordController,
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
              SizedBox(
                height: screenAwareSize(10, context),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    if(_passwordController.text == _confirmPasswordController.text && (_passwordController.text!="" && _confirmPasswordController.text!="")){
                      for(int i=0;i<_emailController.text.length;i++) {
                        if (!_emailController.text.characters.characterAt(i).contains(" ")) {
                          _signUpUser(
                              _emailController.text, _passwordController.text,
                              context, _fullnameController.text);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()), (
                              route) => false);
                          break;
                        }else{
                          _emailController.text=_emailController.text.substring(0,i);
                          _signUpUser(_emailController.text, _passwordController.text, context, _fullnameController.text);
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
                    }
                    /*for(int i=0;i<_emailController.text.length;i++){
                  if(!_emailController.text.characters.characterAt(i).contains(" ")){
                    _signUpUser(_emailController.text, _passwordController.text, context, _fullnameController.text);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder:(context) =>Home()),(route) => false);
                    break;
                  }else{
                    _emailController.text=_emailController.text.substring(0,i);
                    _signUpUser(_emailController.text, _passwordController.text, context, _fullnameController.text);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder:(context) =>Home()),(route) => false);
                    break;

                  }
                }*/
                  },
                  child: Container(
                    height: 40,
                    width: 170,
                    color: Colors.white,
                    child: new RaisedButton(
                      color: Colors.grey,
                      child: Text("GENERAR USUARIO",style: new TextStyle(color: Colors.black),),
                    ),
                ),
              ),
              )
            ]
        )
    );
  }
}