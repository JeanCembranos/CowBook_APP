import 'package:flutter/material.dart';
import 'package:myfarm_app/Screens/ConsultaHistMedico.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/IngresoHistMedico.dart';

class HealthHistSelection extends StatefulWidget{
  String data;
  String currentUser;
  @override
  _HealthHistSelection createState() => _HealthHistSelection();
  HealthHistSelection({
    this.data,
    this.currentUser
  });
}

class _HealthHistSelection extends State<HealthHistSelection>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('My Farm'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                Home(currentUser: widget.currentUser,data: widget.data,)), (Route<dynamic> route) => false);
          },
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),
      ),
      body: new Column(
        children: [
          Padding(
            padding:EdgeInsets.all(10.0),
            child: new InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2.5,
                color: Colors.orangeAccent[100],

                child: new Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top:20),
                      child: new Image.asset(
                        'assets/images/nuevo.png',
                        height: MediaQuery.of(context).size.height/2-200,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(top:35.0),
                        child: Text("Ingresar Nuevo Registro",style: new TextStyle(fontSize: 25.0),textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    IngHistMedico(currentUser: widget.currentUser,data: widget.data,)), (Route<dynamic> route) => false);
              },
            ),
          ),
          Padding(
            padding:EdgeInsets.all(10.0),
            child: new InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.5,
              color: Colors.orangeAccent[100],
              child: new Column(
              children: [
              Padding(
              padding: EdgeInsets.only(top:20),
              child: new Image.asset(
              'assets/images/busqueda.png',
              height: MediaQuery.of(context).size.height/2-200,
              ),
              ),
              Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
              padding: EdgeInsets.only(top:35.0),
              child: Text("Consultar Registro Existente",style: new TextStyle(fontSize: 25.0),textAlign: TextAlign.center,),
              ),
              ),
              ],
              ),
              ),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    SearchHistMedico(currentUser: widget.currentUser,data: widget.data,)), (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }

}