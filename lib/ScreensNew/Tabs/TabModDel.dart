import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/RegTools/DBProduLeche.dart';
import 'package:myfarm_app/ScreensNew/Tabs/SearchDelMod.dart';
import 'package:myfarm_app/ScreensNew/Tabs/SearchDelModCards.dart';

class TabModDel extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _TabModDelState createState() => _TabModDelState();
  TabModDel({
    this.data,
    this.currentUser
  });
}

class _TabModDelState extends State<TabModDel> {
  DateTime selectedIniDate = DateTime.now();
  DateTime selectedFinDate = DateTime.now();
  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  TextEditingController _searchController = TextEditingController();
  QuerySnapshot registroLeche;
  DBProduLeche objRegLeche = new DBProduLeche();


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getRegLecheSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  getRegLecheSnapshots() async {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await Firestore.instance
        .collection('DBProduLeche').document(widget.currentUser).collection(widget.data)
        .where('fechaReg',isGreaterThanOrEqualTo: selectedIniDate)
       .where('fechaReg',isLessThanOrEqualTo: selectedFinDate)
        .getDocuments();
    setState(() {
      print(widget.currentUser);
      _allResults = data.documents;
    });
    searchResultsList();
    return "complete";
  }

  searchResultsList() {
    var showResults = [];
      showResults = List.from(_allResults);
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  new Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
              width:MediaQuery.of(context).size.width,
              child: Row(
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
              )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              color: Colors.white,
              onPressed: () {
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
      Expanded(
            child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (BuildContext context, int index) =>
                 buildSearchDelModCards(context, _resultsList[index]),
            ),
          ),
        ],

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