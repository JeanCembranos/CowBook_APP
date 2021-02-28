import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/IDTools/dbID.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/ScannerQR.dart';
import 'package:myfarm_app/ScreensNew/IDCreate.dart';
import 'package:myfarm_app/SearchIDTools/SearchCard.dart';
import 'package:myfarm_app/SearchIDTools/Trip.dart';
import 'package:provider/provider.dart';

class IDChooser extends StatefulWidget{
  final String currentUser;
  @override
  _IDChooserState createState() => _IDChooserState();
  IDChooser({
    this.currentUser
  });
}

class _IDChooserState extends State<IDChooser>{
  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  TextEditingController _searchController = TextEditingController();
  QuerySnapshot id;
  dbID idSearch = new dbID();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    /*idSearch.getData().then((results){
      setState(() {
        id = results;
      });
    });*/
  }
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }
  _onSearchChanged() {
    searchResultsList();
  }
  searchResultsList() {
    var showResults = [];

    if(_searchController.text != "") {
      for(var tripSnapshot in _allResults){
        var title = Trip.fromSnapshot(tripSnapshot).title.toLowerCase();
        var code = Trip.fromSnapshot(tripSnapshot).code.toLowerCase();

        if(title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }else if(code.contains(_searchController.text.toLowerCase())){
          showResults.add(tripSnapshot);
        }
      }

    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
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
      body:WillPopScope(
        onWillPop: _onBackPressed,
        child:  new Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search)
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildTripCard(context, _resultsList[index]),
              ),
            ),
          ],

        ),
      )
    );
  }
  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scanner(currentUser: widget.currentUser,),
      ),
          (route) => false,
    );
  }

  getUsersPastTripsStreamSnapshots() async {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await Firestore.instance
        .collection('CowIDs')
        .where('currentUser',isEqualTo: widget.currentUser)
        .getDocuments();
    setState(() {
      _allResults = data.documents;
    });
    searchResultsList();
    return "complete";
  }

  _nextpage(BuildContext context, i) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(currentUser: widget.currentUser,),
        ),
            (route) => false);
  }

}