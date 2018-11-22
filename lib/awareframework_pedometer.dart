import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class PedometerSensor extends AwareSensorCore {
  static const MethodChannel _pedometerMethod = const MethodChannel('awareframework_pedometer/method');
  static const EventChannel  _pedometerStream  = const EventChannel('awareframework_pedometer/event');

  /// Init Pedometer Sensor with PedometerSensorConfig
  PedometerSensor(PedometerSensorConfig config):this.convenience(config);
  PedometerSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_pedometerMethod, _pedometerStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class PedometerSensorConfig extends AwareSensorConfig{
  PedometerSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class PedometerCard extends StatefulWidget {
  PedometerCard({Key key, @required this.sensor}) : super(key: key);

  PedometerSensor sensor;

  @override
  PedometerCardState createState() => new PedometerCardState();
}


class PedometerCardState extends State<PedometerCard> {

  String steps = "Steps: ";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          steps = "Steps: ${event.toString()}";
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text(steps),
        ),
      title: "Pedometer",
      sensor: widget.sensor
    );
  }

}
