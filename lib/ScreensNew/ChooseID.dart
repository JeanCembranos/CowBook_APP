import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/ScannerQR.dart';
import 'package:myfarm_app/ScreensNew/IDCreate.dart';

class IDChooser extends StatefulWidget{
  final String currentUser;
  @override
  _IDChooserState createState() => _IDChooserState();
  IDChooser({
    this.currentUser
  });
}

class _IDChooserState extends State<IDChooser>{
  QuerySnapshot id;
  dbID idSearch = new dbID();
  @override
  void initState() {
    super.initState();
    idSearch.getData().then((results){
      setState(() {
        id = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Selección de ID",style: TextStyle(color: Colors.black),),
          leading:
          IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black,),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Scanner(),
                  ),
                      (route) => false,
                );
              }),
          actions: [
            ClipOval(
              child: Material(
                color: Colors.lightGreen, // button color
                child: InkWell(
                  splashColor: Colors.red,
                  // inkwell color
                  child: SizedBox(width: 56, height: 56, child: Icon(Icons.add,)),
                  onTap: () {
                   String key=UniqueKey().toString();
                   print(key);
                    String code=key.substring(2,key.length-1);
                   Navigator.pushAndRemoveUntil(
                     context,
                     MaterialPageRoute(
                       builder: (context) =>
                           IDCreate(currentUser: widget.currentUser,data: code,),
                     ),
                         (route) => false,
                   );
                  },
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: _IDList(),

    );
  }
  Widget _IDList(){
    if (id != null) {
      bool carflag = false;
      List<int> location = [];
      for(var y = 0; y < id.documents.length; y++){
        if(id.documents[y].data['currentUser'] == widget.currentUser){
          carflag = true;
          location.add(y);
        }
      }

      if(carflag == true){
        return SingleChildScrollView(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: location.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i){

                    return new InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          color: Colors.yellow,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                  width: 70,
                                  height: 70,
                                  margin: EdgeInsets.only(right: 15),
                                  child: Image(image: AssetImage('assets/images/cowSearch.png'),height: 50,)),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text(
                                    id.documents[location[i]].data['name'],style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                                  ),


                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.featured_video_sharp,
                                          color: Colors.orangeAccent,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text("Raza: ${id.documents[location[i]].data['raza']}",
                                            /* style: TextStyle(
                                                color: primary, fontSize: 18, letterSpacing: .3)*/),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text("Fecha Nacimiento: ${id.documents[location[i]].data['birthDate'].toDate().toString().substring(0,10)}",
                                            /* style: TextStyle(
                                                color: primary, fontSize: 18, letterSpacing: .3)*/),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),
                      onTap: (){
                        _nextpage(context,location[i]);
                      },
                    );
              }
          ),
        );

      }////////
      else{
        return new Scaffold(
          body: new Container(
            width: MediaQuery.of(context).size.width,
            child: new Center(
              child: ListView(
                children: [
                  new Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 80.0),
                        child: new Text("NO HAY REGISTROS EXISTENTES",style: new TextStyle(fontSize: 30,color: Colors.pinkAccent),textAlign: TextAlign.center,),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 60.0),
                        child: new Text("* Para ingresar un nuevo vehículo, pulse aquí:",style: new TextStyle(fontSize: 24,color: Colors.black),textAlign: TextAlign.center,),
                      ),
                      Center(
                          child: Container(
                            width: 150.0,
                            height: 80.0,
                            margin: const EdgeInsets.only(top: 75.0),
                            /*child: new IconButton(
                      icon: Icon(Icons.camera_alt,size: 70,),

                      //child: new Text("SCANNER",style: TextStyle(fontSize: 25),),*/
                            child: FlatButton(
                              onPressed: () {

                              },
                              color: Colors.orange,
                              padding: EdgeInsets.all(10.0),
                              child: Column( // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.add,size: 60,),
                                ],
                              ),
                            ),

                          )
                      ),
                    ],
                  ),
                ],
              ),

            ),
          ),



        );
      }
    }
  }
  _nextpage(BuildContext context, i) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(currentUser: widget.currentUser,data: id.documents[i].data['code'],),
        ),
            (route) => false);
  }

}