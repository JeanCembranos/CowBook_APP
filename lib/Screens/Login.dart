import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/ActiveRoot.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Recovery.dart';
import 'package:myfarm_app/Screens/Signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
        return new Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TopPartHome(), BottomPartHome()],
              ),
            ));
  }
}

class TopPartHome extends StatefulWidget {
  @override
  _TopPartHomeState createState() => new _TopPartHomeState();
}

class _TopPartHomeState extends State<TopPartHome> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Stack(children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                  children: <Widget>[
                    SizedBox(height: 30.0,),
                    Center(
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: Image.asset('assets/images/CowBook.png',
                              width: screenAwareSize(250, context),
                              height: screenAwareSize(250, context)),
                        ),
                      ),
                    ),
                  ])
            ],
          )
        ]));
  }
}

enum LoginType {
  email,
  google,
}

class BottomPartHome extends StatefulWidget {
  @override
  _BottomPartHomeState createState() => new _BottomPartHomeState();
}

class _BottomPartHomeState extends State<BottomPartHome> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  /* Email Validator */
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  /* Password Validator*/
  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  /*  LoginUser  Method*/
  void _loginUser({
    @required LoginType type,
    String email,
    String password,
    BuildContext context,
  }) async {
    try {
      String _returnString;
      bool _returnBool=true;

      switch (type) {
        case LoginType.email:
          _returnString = await Auth().loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await Auth().loginUserWithGoogle();
          print(await _returnString);
          break;
        default:
      }
     if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ActiveRoot(),
          ),
              (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  /*  GoogleButton  Widget*/
  Widget _googleButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30.0)),
          _buildSocialBtn(
                () => {
              _loginUser(type: LoginType.google, context: context)
            },
            AssetImage(
              'assets/images/google_logo.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30.0)),
          _buildSocialBtn(
                () => {

            },
            AssetImage(
              'assets/images/facebook_logo.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: screenAwareSize(0, context),
            ),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Correo Electrónico",style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
            ),
            SizedBox(
              height: 10,

            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: new Container(
                height: 40,
                child: new TextField(
                  controller: _emailController,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Contraseña",style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: new Container(
                height: 40,
                child: new TextField(
                  controller: _passwordController,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey),
                  obscureText: true,
                ),
              ),
            ),
            /*TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email, color: Colors.black),
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black)),
              obscureText: false,
              validator: emailValidator,
            ),*/
            /*SizedBox(
              height: screenAwareSize(20, context),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: pwdValidator,
              obscureText: true,
            ),*/
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage("assets/images/granja.png"),
                     fit: BoxFit.cover
                 )
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenAwareSize(15.0, context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 220.0),
                    child: new Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>ForgotScreen()));
                        },
                        child: Text(
                          "¿Olvidaste tu Contraseña?",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenAwareSize(5.0, context),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        height: 50,
                        width: 160,
                        color: Colors.green,
                        child: new RaisedButton(
                          onPressed: (){
                            if (!EmailValidator.validate(_emailController.text, true) && !_emailController.text.contains(" ") || emailValidator(_emailController.text) != null && !_emailController.text.contains(" ") || _emailController.text == null && !_emailController.text.contains(" ") || _passwordController.text == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Warning'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Bad formatting in email or password')
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                            }else{
                              for(int i=0;i<_emailController.text.length;i++){
                                if(_emailController.text.characters.characterAt(i).contains(" ")){
                                  _emailController.text=_emailController.text.substring(0,i);
                                  _loginUser(
                                      type: LoginType.email,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context);
                                  break;
                                }else{
                                  _loginUser(
                                      type: LoginType.email,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context);
                                  break;
                                }
                              }
                            }
                          },
                          color: Colors.green[900],
                          child: Text("Iniciar sesión",style: new TextStyle(color: Colors.white,fontSize: 20),),
                        ),
                      ),
                    ),
                  ),
                  /*new Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 50,top: 20),
                  child: Container(
                    height: 40,
                    width: 120,
                    color: Colors.white,
                    child: new RaisedButton(
                      onPressed: (){
                        if (!EmailValidator.validate(_emailController.text, true) && !_emailController.text.contains(" ") || emailValidator(_emailController.text) != null && !_emailController.text.contains(" ") || _emailController.text == null && !_emailController.text.contains(" ") || _passwordController.text == null) {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Warning'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Bad formatting in email or password')
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                        }else{
                          for(int i=0;i<_emailController.text.length;i++){
                            if(_emailController.text.characters.characterAt(i).contains(" ")){
                              _emailController.text=_emailController.text.substring(0,i);
                              _loginUser(
                                  type: LoginType.email,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context);
                              break;
                            }else{
                              _loginUser(
                                  type: LoginType.email,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context);
                              break;
                            }
                          }
                        }
                      },
                      color: Colors.grey,
                      child: Text("SIGN IN",style: new TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
                /*Padding(
                  padding: EdgeInsets.only(left: 20,top: 20),
                  child: Container(
                    height: 40,
                    width: 120,
                    color: Colors.white,
                    child: new RaisedButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder:(context) =>Signup()),(route) => false);
                      },
                      color: Colors.grey,
                      child: Text("SIGN UP",style: new TextStyle(color: Colors.black),),
                    ),
                  ),
                ),*/

              ],
            ),*/
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: new  Row(
                      children: [
                        Text("Aún no tienes una cuenta?",style: TextStyle(fontWeight: FontWeight.bold),),
                        InkWell(
                          child: Text("Créala Ahora",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
                          onTap: (){
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Signup()
                              ),
                                  (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
