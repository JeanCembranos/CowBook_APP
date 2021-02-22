
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:myfarm_app/RegTools/DBReg.dart';
import 'package:myfarm_app/RegTools/RegModel.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/ScreensNew/RegMedico.dart';

class CreateReg extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _CreateRegState createState() => _CreateRegState();
  CreateReg({
    this.data,
    this.currentUser
  });
}

class _CreateRegState extends State<CreateReg> {
  String obs;
  DateTime selectedIniDate = DateTime.now();
  DateTime selectedFinalDate = DateTime.now();
  bool _medHasError = false;
  bool _ObsHasError = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading:
        IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegMedico(
                        currentUser: widget.currentUser, data: widget.data,),
                ),
                    (route) => false,
              );
            }),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: new Column(
          children: [
            Align(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 10,
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/images/CreTratLogo.png"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              alignment: Alignment.center,
            ),
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              skipDisabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: "medicamento",
                    decoration: InputDecoration(
                      labelText: 'Medicamento Prescrito',
                      suffixIcon: _medHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _medHasError =
                        !_formKey.currentState.fields['medicamento'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10.0),
                  Text("Fecha Inicio",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-70.0,
                        height: 20.0,
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
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: ClipOval(
                          child: Material(
                            color: Colors.orange, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(width: 56,
                                  height: 56,
                                  child: Icon(
                                    Icons.calendar_today_outlined,)),
                              onTap: () {
                                _selectIniDate(context);
                                // ignore: invalid_use_of_protected_member
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text("Fecha Finalización",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-70.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                )
                            )
                        ),
                        child: Text(selectedFinalDate.toString().substring(0,10)),

                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: ClipOval(
                          child: Material(
                            color: Colors.orange, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(width: 56,
                                  height: 56,
                                  child: Icon(
                                    Icons.calendar_today_outlined,)),
                              onTap: () {
                                _selectFinalDate(context);
                                // ignore: invalid_use_of_protected_member
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text("Observaciones",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                  SizedBox(height: 10.0),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.black,width: 2.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: TextField(
                          maxLines: 5,
                         decoration: new InputDecoration(
                           border: new OutlineInputBorder(
                               borderSide: new BorderSide(color: Colors.black,width: 10)
                           )
                         ),
                          onChanged: (texto) {
                           obs = texto;
                             },
                        ),
                      )
                  ),
                  SizedBox(height: 20.0,),
                  Align(
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        RegModel regM=RegModel(_formKey.currentState.fields['medicamento'].value, obs, selectedIniDate, selectedFinalDate);
                        _addID(context, regM);
                      },
                      elevation: 4.0,
                      splashColor: Colors.blue[400],
                      child: Text(
                        'GUARDAR',
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            )


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
  Future<void> _selectFinalDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFinalDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFinalDate)
      setState(() {
        selectedFinalDate = picked;
      });
  }
  void _addID(BuildContext context, RegModel reg) async {
    String _returnString;
    _returnString = await DBReg().createGroup(reg, widget.data, widget.currentUser);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RegMedico(currentUser: widget.currentUser,data: widget.data,),
        ),
            (route) => false,
      );
    }

  }
}