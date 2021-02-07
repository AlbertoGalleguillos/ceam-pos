import 'dart:convert';

import 'package:ceam_pos/providers/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'constants.dart' as Constants;

class Login extends StatefulWidget {
  static final String route = '/';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController =
      TextEditingController(text: 'agustin'); // text: 'agustin'
  TextEditingController rutController =
      TextEditingController(text: '77127713-6'); // text: '77127713-6'
  TextEditingController passController =
      TextEditingController(text: '123'); // text: '123'
  bool isLoading = false;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => isKeyboardVisible = visible);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(Constants.SECONDARY_COLOR),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 64.0,
            top: 16.0,
            right: 16,
            left: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!isKeyboardVisible)
                Image.asset(
                  Constants.CEAM_LOGO_PATH,
                  scale: 0.5,
                ),
              // Spacer(),
              TextFormField(
                controller: userController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
            ],
          ),
        ),
      ),
      floatingActionButton: isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(Constants.PRIMARY_COLOR),
                  onPressed: () {
                    attemptLogin(context);
                  },
                  icon: const Icon(Icons.login),
                  label: const Text(Constants.LOGIN_ACTION_TEXT),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> attemptLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (await canLogin()) {
        Navigator.of(context).pushNamed('/home');
      }
      setState(() => isLoading = false);
    }
  }

  //TODO: Pass this function to UserServices
  Future<bool> canLogin() async {
    setState(() => isLoading = true);

    FocusScope.of(context).unfocus();
    String loginUrl = '${Constants.BASE_URL}/validaLogin/';

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
      LoginProvider provider =
          Provider.of<LoginProvider>(context, listen: false);
      provider.setCompany(response.body);
      // TODO: Create User
      return true;
    } else {
      const String ERROR_MESSAGE = 'Hubo un error al tratar de acceder';
      final cannotLogin = jsonDecode(response.body)['mensaje'] ?? ERROR_MESSAGE;
      final snackBar = SnackBar(content: Text(cannotLogin));
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(snackBar);
      // throw Exception('Failed to sign in');
      return false;
    }
  }
}
