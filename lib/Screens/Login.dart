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
            backgroundColor: Color(0xffbE29A2D),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text("MY FARM",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenAwareSize(30.0, context),
                      fontWeight: FontWeight.normal,
                      fontFamily: "Montserrat-Bold")),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[TopPartHome(), BottomPartHome()],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: Image.asset('assets/images/farmlogo.jpg',
                              width: screenAwareSize(145, context),
                              height: screenAwareSize(145, context)),
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
              height: screenAwareSize(10.0, context),
            ),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Correo Electrónico",style: new TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 10,

            ),
            Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: new Container(
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
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Contraseña",style: new TextStyle(color: Colors.white),),
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
                  controller: _passwordController,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(40.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white),
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
            SizedBox(
              height: screenAwareSize(15.0, context),
            ),
            Padding(
              padding: EdgeInsets.only(left: 150.0),
              child: new Container(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>ForgotScreen()));
                  },
                  child: Text(
                    "¿Olvidaste tu Contraseña?",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenAwareSize(5.0, context),
            ),
            new Row(
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
                Padding(
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
                ),

              ],
            ),
            SizedBox(height: 30,),
            new Center(
              child: Text("--OR--"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenAwareSize(50.0, context),
                  right: screenAwareSize(90.0, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _googleButton(),
                  _facebookButton()
                ],
              ),
            )
            /*Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (!EmailValidator.validate(_emailController.text, true) &&
                      !_emailController.text.contains(" ") ||
                      emailValidator(_emailController.text) != null &&
                          !_emailController.text.contains(" ") ||
                      _emailController.text == null &&
                          !_emailController.text.contains(" ") ||
                      _passwordController.text == null) {
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
                  } else {
                    for (int i = 0; i < _emailController.text.length; i++) {
                      if (_emailController.text.characters.characterAt(i)
                          .contains(" ")) {
                        _emailController.text =
                            _emailController.text.substring(0, i);
                        _loginUser(
                            type: LoginType.email,
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context);
                        break;
                      } else {
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
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(0.0)),
                    color: Colors.white70,
                  ),
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
              ),
            ),*/
            /*Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0),
              child: GestureDetector(
                onTap: () {
                  /*Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder:(context) =>Signup()),(route) => false);*/
                },
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(0.0)),
                    color: Colors.white70,
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
              ),
            ),*/


            /* Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("                   Don't have an account? Sign up here",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                         Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                                  builder:(context) =>Signup()),(route) => false);
                },
              ),
              Text(
                '                    - OR -',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '                     Sign in with',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),*/
            /* SizedBox(
            height: screenAwareSize(15, context),
          ),
          */
          ],
        ));
  }
}
