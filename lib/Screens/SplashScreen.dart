import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/ActiveRoot.dart';
import 'package:myfarm_app/LoginTools/root.dart';
import 'package:myfarm_app/LoginTools/utils.dart';
import 'package:myfarm_app/Screens/Login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () => {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ActiveRoot(),
          ),
              (route) => false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/wallpaperSplash.jpg",
                ),
                fit: BoxFit.cover,
              )
            ),
          ),
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child:Padding(
                          child: Column(
                            children: <Widget>[
                              new Container(
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  child: Image.asset('assets/images/CowBook1.png',
                                      width: screenAwareSize(400, context),
                                      height: screenAwareSize(400, context)),
                                ),
                              ),

                            ],
                          ),
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(

                      children: <Widget>[
                        CircularProgressIndicator(backgroundColor: Colors.lightGreen,),
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                        ),
                        SizedBox(height: 10.0,),
                        Text(
                          "TU MEJOR OPCIÓN",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
        ],
      ),
    );
  }
}
