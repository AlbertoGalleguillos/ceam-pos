import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController(text: 'ellanca');
  TextEditingController rutController =
      TextEditingController(text: '25107882-3');
  TextEditingController passController =
      TextEditingController(text: '43734373');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('CEAM POS',
                  style: TextStyle(fontSize: 96), textAlign: TextAlign.center),
              TextFormField(
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingrese su usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: rutController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rut',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingrese su Rut';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingrese su contraseña';
                  }
                  return null;
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  attemptLogin(context);
                },
                label: Text('Login'),
                icon: Icon(Icons.login),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> attemptLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (await canLogin()) {
        Navigator.of(context).pushNamed('/home');
      }
    }
  }

  //TODO: Pass this function to UserServices
  Future<bool> canLogin() async {
    String loginUrl = 'https://ceamspa.cl/pos/services/app/v1/validaLogin/';

    final http.Response response = await http.post(
      loginUrl,
      body: jsonEncode(<String, String>{
        'login': userController.text,
        'pw': passController.text,
        'rut': rutController.text,
      }),
    );

    print('response');
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      // TODO: Create User
      return true;
    } else {
      final cannotLogin = jsonDecode(response.body)['mensaje'] ??
          'Hubo un error al tratar de acceder';
      final snackBar = SnackBar(content: Text(cannotLogin));
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(snackBar);
      // throw Exception('Failed to sign in');
      return false;
    }
  }
}
