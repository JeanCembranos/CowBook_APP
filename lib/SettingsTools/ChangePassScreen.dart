
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/Screens/Login.dart';
import 'package:myfarm_app/Screens/Settings.dart';

class ChangePassScreen extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
  ChangePassScreen({
    this.data,
    this.currentUser
  });
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  bool _contrasenaHasError = true;
  bool _contrasenaConfirmHasError = true;
  bool _newContrasenaHasError = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Cambiar Contraseña", style: TextStyle(color: Colors.black),),
        leading:
        IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsOnePage(
                        currentUser: widget.currentUser, data: widget.data,),
                ),
                    (route) => false,
              );
            }),
        backgroundColor: Colors.white,
      ),
      body: WillPopScope(
        child: new Column(
          children: [
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              skipDisabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: "contrasena",
                    decoration: InputDecoration(
                      labelText: 'Contraseña Actual',
                      suffixIcon: _contrasenaHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _contrasenaHasError =
                        !_formKey.currentState.fields['contrasena'].validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.minLength(context, 8,
                          errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                      FormBuilderValidators.maxLength(context, 16,
                          errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: "newContrasena",
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      suffixIcon: _newContrasenaHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _newContrasenaHasError =
                        !_formKey.currentState.fields['newContrasena']
                            .validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.minLength(context, 8,
                          errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                      FormBuilderValidators.maxLength(context, 16,
                          errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: "contrasenaConfirm",
                    decoration: InputDecoration(
                      labelText: 'Confirmar Nueva Contraseña',
                      suffixIcon: _contrasenaConfirmHasError
                          ? const Icon(Icons.error, color: Colors.red)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _contrasenaConfirmHasError =
                        !_formKey.currentState.fields['contrasenaConfirm']
                            .validate();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Este campo no puede estar vacío"),
                      FormBuilderValidators.minLength(context, 8,
                          errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                      FormBuilderValidators.maxLength(context, 16,
                          errorText: "Contraseña debe contener entre 8 y 16 caracteres"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                  Align(
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                       
                      },
                      elevation: 4.0,
                      splashColor: Colors.blue[400],
                      child: Text(
                        'GUARDAR',
                        style: TextStyle(color: Colors.green, fontSize: 25.0),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)
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
}