import 'dart:html';

import 'package:flutter/material.dart';

void main() => runApp(MyConvert());

class MyConvert extends StatefulWidget {
  @override
  State<MyConvert> createState() => _MyConvertState();
}

class _MyConvertState extends State<MyConvert> {
  double? _numberFrom;
  String? _startMeasure;
  String? _convertedMeasure;
  String? _resultMessage;

  final List<String> _measures = [
    'metros',
    'kilometros',
    'gramos',
    'kilogramos',
    'pies',
    'millas',
    'libras (lbs)',
    'onzas'
  ];
  final Map<String, int> _measuresMap = {
    'metros': 0,
    'kilometros': 1,
    'gramos': 2,
    'kilogramos': 3,
    'pies': 4,
    'millas': 5,
    'libras (lbs)': 6,
    'onzas': 7,
  };
  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  final TextStyle inputStyle = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );
  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  @override
  void initState() {
    _numberFrom = 0;
    _startMeasure;
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Convertidor de Medidas',
      
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),

          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
          title: Text('Convertidor de Medidas'),
          centerTitle: true,
                  backgroundColor: Colors.red,

        ),
        body:
        
         
        Container(
             
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image(
                  width: double.infinity,
                  height: 200.0,
                 
                  image: NetworkImage(
                      'data:image/jpeg;base64,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')),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  ),
            
              TextField(
                style: inputStyle,
                decoration: InputDecoration(
                  hintText: " Valor a transformar",
                ),
                onChanged: (text) {
                  var rv = double.tryParse(text);
                  if (rv != null) {
                    setState(() {
                      _numberFrom = rv;
                    });
                  }
                },
              ),

              Spacer(),
              Text('convertir '),
              Text(
                'seleccione la medida de convertir',
                style: labelStyle,
              ),

              DropdownButton(
                isExpanded: true,
                style: inputStyle,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _startMeasure = value;
                  });
                },
                value: _startMeasure,
              ),
              Spacer(),
              Text(
                'seleccione la medida a convertir',
                style: labelStyle,
              ),
              Spacer(),
              DropdownButton(
                isExpanded: true,
                style: inputStyle,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: inputStyle,
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _convertedMeasure = value;
                  });
                },
                value: _convertedMeasure,
              ),
              Spacer(
                flex: 2,
              ),

              //Raised Button
              Spacer(
                flex: 2,
              ),
              RaisedButton(
                child: Text(
                  'CONVERTIR',
                  style: labelStyle,
                ),
                onPressed: () {
                  if (_startMeasure!.isEmpty ||
                      _convertedMeasure!.isEmpty ||
                      _numberFrom == 0) {
                    return;
                  } else {
                    convert(_numberFrom!, _startMeasure!, _convertedMeasure!);
                  }
                },
              ),
              Spacer(
                flex: 2,
              ),

              //Text From
              Text((_resultMessage == null) ? '' : _resultMessage!,
                  style: labelStyle),
              Spacer(
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void convert(double value, String from, String to) {
    int? nFrom = _measuresMap[from];
    int? nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;

    if (result == 0) {
      _resultMessage = 'esta conversion no se puede realizar [0]';
    } else {
      _resultMessage =
          '${_numberFrom.toString()} $_startMeasure es igual a ${result.toString()} $_convertedMeasure';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}