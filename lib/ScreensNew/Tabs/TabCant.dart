import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TabCant extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _TabCantState createState() => _TabCantState();
  TabCant({
    this.data,
    this.currentUser
  });
}

class _TabCantState extends State<TabCant> {
  double result=0;
  DateTime selectedIniDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  DateTime selectedFinDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: new Column(
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 10,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/ConsLeche.png"),
                      fit: BoxFit.cover
                  )
              ),
            ),
            SizedBox(height: 35.0,),
            Container(
                width:MediaQuery.of(context).size.width,
                child:Row(
                  children: [
                    Column(
                      children: [
                        Text("Desde: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Padding(
                          child: Container(
                            width: MediaQuery.of(context).size.width/2-70,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    )
                                )
                            ),
                            child: Text(selectedIniDate.toString().substring(0,10)),
                          ),
                          padding: EdgeInsets.only(left: 20.0),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 46, height:46, child: Icon(Icons.calendar_today_outlined,)),
                          onTap: () {
                            _selectIniDate(context);
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text("Hasta:",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width/2-70,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      )
                                  )
                              ),
                              child: Text(selectedFinDate.toString().substring(0,10))
                          ),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 46, height: 46, child: Icon(Icons.calendar_today_outlined,)),
                          onTap: () {
                            _selectFinDate(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              /*Row(
                  children: [
                    Padding(
                      child: Container(
                        width: MediaQuery.of(context).size.width/2-70,
                        height: 30.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                )
                            )
                        ),
                        child: Text(selectedIniDate.toString().substring(0,10)),
                      ),
                      padding: EdgeInsets.only(left: 20.0),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 46, height:46, child: Icon(Icons.calendar_today_outlined,)),
                          onTap: () {
                            _selectIniDate(context);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width/2-70,
                          height: 30.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  )
                              )
                          ),
                          child: Text(selectedFinDate.toString().substring(0,10))
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 46, height: 46, child: Icon(Icons.calendar_today_outlined,)),
                          onTap: () {
                            _selectFinDate(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )*/
            ),
            SizedBox(height: 20.0,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  result=0;
                  getRegLecheSnapshots();
                },
                elevation: 4.0,
                splashColor:  Colors.blue[400],
                child: Text(
                  'BUSCAR',
                  style: TextStyle(color: Colors.red, fontSize: 25.0),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Text("Cantidad de Leche Producida",textAlign: TextAlign.start,),
            SizedBox(height: 10.0,),
            Padding(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 30.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.black)
                ),
                child: Text("${result.toString()} Litros",textAlign: TextAlign.center,),
              ),
              padding: EdgeInsets.only(left: 20.0,right: 20.0),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _selectIniDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedIniDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedIniDate)
      setState(() {
        selectedIniDate = picked;
      });
  }
  getRegLecheSnapshots() async {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await Firestore.instance
        .collection('DBProduLeche').document(widget.currentUser).collection(widget.data)
        .where('fechaReg',isGreaterThanOrEqualTo: selectedIniDate)
        .where('fechaReg', isLessThanOrEqualTo: selectedFinDate)
        .getDocuments();
    setState(() {
      for(int i=0;i<data.documents.length;i++){
        result = result+double.parse(data.documents[i]['cantProd']);
      }
    });
    return "complete";
  }
  Future<void> _selectFinDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFinDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFinDate)
      setState(() {
        selectedFinDate = picked;
      });
  }

}