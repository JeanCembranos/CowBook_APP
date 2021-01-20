import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/HistMedicoTools/RegistroMedicoModel.dart';
import 'package:myfarm_app/LoginTools/DBRecords.dart';
import 'package:myfarm_app/ObsTools/ObsModel.dart';
import 'package:myfarm_app/Screens/HistorialMedicoSeleccion.dart';
import 'package:myfarm_app/Screens/ObservacionesSeleccion.dart';

class IngNovedades extends StatefulWidget{
  String data;
  String currentUser;
  @override
  _IngNovedadesState createState() => _IngNovedadesState();
  IngNovedades({
    this.data,
    this.currentUser
  });
}

class _IngNovedadesState extends State<IngNovedades> {
  String descripcion;
  List<String> _companies = ["Proceso de Gestación","Otros"];
  List<String> _importancia = ["Alto","Medio","Bajo"];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownMenuItemsI;
  String _selectedCompany;
  String _selectedOption;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateProx = DateTime.now();


  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    _dropdownMenuItemsI = buildDropdownMenuItemsI(_importancia);
    _selectedOption = _dropdownMenuItemsI[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<String>> items = List();
    for (String company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company),
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<String>> buildDropdownMenuItemsI(List companies) {
    List<DropdownMenuItem<String>> items = List();
    for (String company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(String selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  onChangeDropdownItemI(String selectedCompany) {
    setState(() {
      _selectedOption = selectedCompany;
    });
  }

  void _addRegister(BuildContext context, ObsModel obsRegistro) async {
    String _returnString;
    /*if(_image!=null){
      String fileName = basename(_image?.path);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('carros/$fileName');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      image_url = await taskSnapshot.ref.getDownloadURL();
    }else{
      image_url = "https://firebasestorage.googleapis.com/v0/b/parking-1f14e.appspot.com/o/images%2FnoPhotoImage.jpg?alt=media&token=594a1610-554c-4058-add9-f2cee60cfcc2";
    }*/
    _returnString = await DBRecords().createGroupI(obsRegistro,widget.data, widget.currentUser);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ObsSelection(data: widget.data,currentUser: widget.currentUser,),
        ),
            (route) => false,
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('My Farm'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                ObsSelection(currentUser: widget.currentUser,data: widget.data,)), (Route<dynamic> route) => false);
          },
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),
      ),
      body:  new ListView(
        children: [
          new Container(
            width: MediaQuery.of(context).size.width,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35.0,
                ),
                Text("Evento a Registrar"),
                SizedBox(
                  height: 20.0,
                ),
                /* Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: new Container(
                  height: 30,
                  child: new TextField(
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
              ),*/
                DropdownButton(
                  value: _selectedCompany,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
                SizedBox(
                  height: 35.0,
                ),

                Text("Nivel de Importancia"),
                SizedBox(
                  height: 20.0,
                ),
                /* Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: new Container(
                  height: 30,
                  child: new TextField(
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
              ),*/
                DropdownButton(
                  value: _selectedOption,
                  items: _dropdownMenuItemsI,
                  onChanged: onChangeDropdownItemI,
                ),

                Text("Descripción"),
                SizedBox(
                  height: 20.0,
                ),
                Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (texto) {
                          descripcion = texto;
                        },
                        maxLines: 8,
                        decoration:  new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                      ),
                    )
                ),
                SizedBox(
                  height: 35.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 45.0),
                  child: Text("Fecha de Control"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 45.0),
                  child: Row(
                    children: [
                      new Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width/3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            top: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            left: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            right: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: new Text("${selectedDate.toLocal()}".split(' ')[0],textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: RaisedButton(
                          onPressed: () => _selectDate(context),
                          color: Colors.grey,
                          child: Text('Seleccionar Fecha'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 45.0),
                  child: Text("Fecha Próxima Aplicación"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 45.0),
                  child: Row(
                    children: [
                      new Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width/3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            top: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            left: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            right: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: new Text("${selectedDateProx.toLocal()}".split(' ')[0],textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: RaisedButton(
                          onPressed: () => _selectDateProx(context),
                          color: Colors.grey,
                          child: Text('Seleccionar Fecha'),
                        ),
                      ),
                    ],
                  ),
                ),
                new RaisedButton(
                  child: Text("Enviar"),
                  onPressed: (){
                    ObsModel registro=ObsModel(_selectedCompany, descripcion,_selectedOption, selectedDate, selectedDateProx,'observacion');
                    _addRegister(context, registro,);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  Future<void> _selectDateProx(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateProx,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateProx)
      setState(() {
        selectedDateProx = picked;
      });
  }
}