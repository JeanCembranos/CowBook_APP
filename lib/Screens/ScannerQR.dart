import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:myfarm_app/HomeTools/dbQR.dart';
import 'package:myfarm_app/LoginTools/DBRecords.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/LoginTools/root.dart';
import 'package:myfarm_app/Screens/CreateIdentification.dart';
import 'package:myfarm_app/Screens/Home.dart';

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
  QuerySnapshot QR;
  dbQR objQR = new dbQR();
  String _scanBarcode = 'Unknown';

  @override
  void initState(){
    super.initState();
    objQR.getData().then((results){
      setState(() {
        QR = results;
      });
    });
  }

  @override
void didChangeDependencies() async {
  super.didChangeDependencies();
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
            appBar: AppBar( backgroundColor: Colors.orange,
              title:Text('BARCODE SCANNER',
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
                  Icons.power_settings_new,  // add custom icons also
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
                                  size: 130.0,
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

                        ])),
              );
            })));
  }


  Future<void> _ScannerRedirection() {
    for(var y = 0; y < QR.documents.length; y++){
      if(QR.documents[y].data['codigo'] == _scanBarcode){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(currentUser: widget.currentUser,data: _scanBarcode,)
          ),
        );
        break;
      }else{
        objQR.createGroupQR(_scanBarcode, widget.currentUser);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>CreateID(data: _scanBarcode,currentUser: widget.currentUser,))
        );
      }
    }


    //bool newdata = false;
    /*if (cars != null) {
      for (var index = 0; index < cars.documents.length; index++) {
        if (_scanBarcode == cars.documents[index].data['data'] &&
            cars.documents[index].data['currentUser'] == widget.currentUser) {
          newdata = true;
          print(_scanBarcode);
          print(newdata);
        }
      }*/
      /*if(!newdata){

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Description(
                data: _scanBarcode,
                currentUser: widget.currentUser,
              ),
            ),
                (route) => true
        );
      }*/
      /*else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Money(
                  scanBarcode: _scanBarcode,
                )
            ),
                (route) => true
        );
      }
    }*/
      /* else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OurRoot()
        ),
      );

    }*/
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