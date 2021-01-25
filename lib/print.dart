import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PrinterApp extends StatefulWidget {
  static final String route = 'testPrinter';

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<PrinterApp> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
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
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blue Thermal Printer'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Device:',
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
                          : _connected
                              ? _disconnect
                              : _connect,
                      child: Text(_connected ? 'Disconnect' : 'Connect'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                child: RaisedButton(
                  onPressed: _connected ? _testPrint : null,
                  child: Text('Test Print'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
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
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _pressed = false);
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

  void _testPrint() async {
    //SIZE
    const NORMAL_TEXT = 0;
    const BOLD_SMALL_TEXT = 1;
    const BOLD_MEDIUM_TEXT = 2;
    const BOLD_LARGE_TEXT = 3;
    //ALIGN
    const ESC_ALIGN_LEFT = 0;
    const ESC_ALIGN_CENTER = 1;
    const ESC_ALIGN_RIGHT = 2;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        final lineSize = 32;
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('R.U.T.: 99.999.999-9', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('Boleta electronica', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('No. 466', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('-' * lineSize, NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printCustom('S.I.I. Santiago', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printCustom("Tu tienda S.A.", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom("Venta al por menor de Alimentos", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom("Prat #533 Curico", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printCustom("Fecha Emision 22-01-2021", NORMAL_TEXT, ESC_ALIGN_LEFT);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("TOTAL:", "\$ 30.000", NORMAL_TEXT);
        bluetooth.printNewLine();
        bluetooth.printCustom('El IVA de esta boleta es \$ 4.790', NORMAL_TEXT, ESC_ALIGN_CENTER);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
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
