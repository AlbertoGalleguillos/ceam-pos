import 'dart:async';
import 'package:ceam_pos/PosAppBar.dart';
import 'package:ceam_pos/PosDrawer.dart';
import 'package:flutter/material.dart';
import 'package:ceam_pos/providers/PrintProvider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ceam_pos/constants.dart' as Constants;

class PrinterApp extends StatefulWidget {
  static final String route = 'testPrinter';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PrinterApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;

  // bool _connected = false;
  bool _pressed = false;
  String pathImage;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print('Ocurrio un error al traer los dispositivos bluetooth');
    } catch (e) {
      print('Ocurrio un error al traer los dispositivos bluetooth $e');
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            // _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            // _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    const subListPadding = EdgeInsets.only(left: 40, right: 16);
    final isConnected = Provider.of<PrintProvider>(context).isConnected;

    return Scaffold(
      key: _scaffoldKey,
      appBar: posAppBar(),
      drawer: PosDrawer(),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Dispositivo:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton(
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _device,
                  ),
                  RaisedButton(
                    onPressed: _pressed
                        ? null
                        : isConnected
                            ? _disconnect
                            : _connect,
                    child: Text(isConnected ? 'Desconec' : 'Conectar'),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text(
                      'Como configurar la impresora:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Instructivo'),
                  ),
                  ListTile(
                    leading: Icon(Icons.android),
                    title: Text(
                      'Configuración del dispositivo:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    contentPadding: subListPadding,
                    leading: Icon(Icons.bluetooth),
                    title: Text(
                        'Verifique que el bluetooth de su dispositivo se encuentre encendido'),
                  ),
                  ListTile(
                    contentPadding: subListPadding,
                    leading: Icon(Icons.bluetooth_connected),
                    title: Text(
                        'Conecte la impresora bluetooth, su nombre es "MTP-2"'),
                  ),
                  ListTile(
                    leading: Icon(Icons.app_settings_alt),
                    title: Text(
                      'Configuración de la aplicación:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    contentPadding: subListPadding,
                    leading: Icon(Icons.list),
                    title: Text(
                        'Seleccione "MTP-2" en el listado de la sección superior de esta pantalla'),
                  ),
                  ListTile(
                    contentPadding: subListPadding,
                    leading: Icon(Icons.touch_app),
                    title: Text('Presione el botón conectar'),
                  ),
                  ListTile(
                    contentPadding: subListPadding,
                    leading: Icon(Icons.check),
                    title:
                        Text('Listo! Ya puedes generar boletas electrónicas'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            backgroundColor:
                isConnected ? Color(Constants.PRIMARY_COLOR) : Colors.grey,
            onPressed: isConnected ? _testPrint : null,
            label: const Text('Impresión de prueba'),
            icon: Icon(Icons.receipt),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('Bluethoot Apagado'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No se ha seleccionado ningún dispositivo.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          PrintProvider provider =
              Provider.of<PrintProvider>(context, listen: false);
          provider.connect(_device).catchError((error) {
            // print('Los errores se están manejando $error');
            setState(() => _pressed = false);
            show(error);
          });

          setState(() => _pressed = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

  void _testPrint() {
    Provider.of<PrintProvider>(context, listen: false).testPrint();
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    // await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}
