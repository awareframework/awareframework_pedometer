import 'package:flutter/material.dart';

import 'package:awareframework_pedometer/awareframework_pedometer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PedometerSensor sensor;
  PedometerSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = PedometerSensorConfig()
      ..interval = 1
      ..debug = true;

    sensor = new PedometerSensor.init(config);

    sensor.start();

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new PedometerCard(sensor: sensor,)
      ),
    );
  }
}
