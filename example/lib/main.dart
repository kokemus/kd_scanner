import 'package:flutter/material.dart';
import 'package:kd_scanner/kd_scanner.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _code = '-';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scanner example app'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(_code, textAlign: TextAlign.center,),
          )
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            setState(() {
              _code = '-';
            });
            try {
              String code = await scan();
              setState(() {
                _code = code;
              });
            } catch (e) {
              setState(() {
                _code = e.toString();
              });
            }
          }
        ),
      ),
    );
  }
}
