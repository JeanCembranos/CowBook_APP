import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'file:///C:/Users/JEAN/Desktop/ControlGanaderoAPP/myfarm_app/lib/RegTools/DBReg.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/authModel.dart';
import 'package:myfarm_app/LoginTools/root.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/ScreensNew/ChooseID.dart';
import 'package:myfarm_app/ScreensNew/IDCreate.dart';
import 'package:provider/provider.dart';

import 'Login.dart';

class Scanner extends StatefulWidget {
  final String currentUser;
  @override
  _ScannerState createState() => _ScannerState();
  Scanner({
    this.currentUser
  });
}

class _ScannerState extends State <Scanner> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String currentUid;
  QuerySnapshot id;
  dbID idSearch = new dbID();
  String _scanBarcode = 'Unknown';

  @override
  void initState(){
    super.initState();
    idSearch.getData().then((results){
      setState(() {
        id = results;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //get the state, check current User, set AuthStatus based on state
    AuthModel _authStream = Provider.of<AuthModel>(context);
    if (_authStream != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = _authStream.uid;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    _ScannerRedirection();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar( backgroundColor: Colors.white,
              title:Text('',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  _signOut(context);
                },
                child: Icon(
                  Icons.power_settings_new,color: Colors.red,  // add custom icons also
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Builder(builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /*RaisedButton(
                            color: Colors.blue[900],
                            elevation: 4.0,
                            splashColor:  Colors.blue[400],
                            onPressed: () => scanQR(),
                            child: Text("Start QR scan",style: TextStyle(color: Colors.white, fontSize: 20.0))),*/
                            RawMaterialButton(
                              onPressed: () => scanQR() ,
                              elevation: 2.0,
                              fillColor: Colors.orangeAccent,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.qr_code,
                                    size: 60.0,
                                  ),
                                  Text("INICIAR ESCANEO",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              padding: EdgeInsets.all(90.0),
                              shape: CircleBorder(),
                            ),
                          SizedBox(
                            height: 20.0,
                          ),
                            Padding(
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IDChooser(currentUser: currentUid,),
                                    ),
                                        (route) => false,
                                  );
                                },
                                elevation: 2.0,
                                fillColor: Colors.orangeAccent,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.edit_off,
                                      size: 60.0,
                                    ),
                                    Text("Registro Sin Código QR",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                padding: EdgeInsets.all(90.0),
                                shape: CircleBorder(),
                              ),
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                        ])),
              );
            })));
  }


  Future<void> _ScannerRedirection() {
    bool bandera=true;
   for(var y = 0; y < id.documents.length; y++){
      if(id.documents[y].data['code'] == _scanBarcode){
        bandera=true;
        break;
      }else{
        bandera=false;
      }
    }
    if(bandera){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(currentUser: currentUid,data: _scanBarcode,)
        ),
      );
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>IDCreate(currentUser: currentUid,data: _scanBarcode,))
      );
    }
    }
  void _signOut(BuildContext context) async {
    String _returnString = await Auth().signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
            (route) => false,
      );
    }
  }
  }