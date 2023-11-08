import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isWidgetVisible = false;

  void toggleWidgetVisibility() {
    setState(() {
      isWidgetVisible = !isWidgetVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Show and Hide Widgets'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: toggleWidgetVisibility,
                child: Text('Toggle Widget Visibility'),
              ),
              Visibility(
                visible: isWidgetVisible,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Text(
                    'Widget 1',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Visibility(
                visible: !isWidgetVisible,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.green,
                  child: Text(
                    'Widget 2',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
