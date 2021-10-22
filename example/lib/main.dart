import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_pedometer/awareframework_pedometer.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {

  PedometerData? data;

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PedometerSensor sensor;
  late PedometerSensorConfig config;


  @override
  void initState() {
    super.initState();
    config = PedometerSensorConfig()..debug = true;
    sensor = PedometerSensor.init(config);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body:Column(
          children: [
            widget.data == null ?
              Text(""):
              Text("Number of Steps: ${widget.data!.numberOfSteps}"),
            TextButton(
                onPressed: () {
                  sensor.start();
                  sensor.onDataChanged.listen((data) {
                    setState(() {
                      widget.data = data;
                    });
                  });
                },
                child: Text("Start")),
            TextButton(
                onPressed: () {
                  sensor.stop();
                },
                child: Text("Stop")),
            TextButton(
                onPressed: () {
                  sensor.sync();
                },
                child: Text("Sync")),
          ],
        ),
      ),
    );
  }
}
