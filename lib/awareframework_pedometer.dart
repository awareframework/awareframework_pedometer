import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class PedometerSensor extends AwareSensorCore {
  static const MethodChannel _pedometerMethod = const MethodChannel('awareframework_pedometer/method');
  static const EventChannel  _pedometerStream  = const EventChannel('awareframework_pedometer/event');

  /// Init Pedometer Sensor with PedometerSensorConfig
  PedometerSensor(PedometerSensorConfig config):this.convenience(config);
  PedometerSensor.convenience(config) : super(config){
    super.setMethodChannel(_pedometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged{
     return super.getBroadcastStream(_pedometerStream,"on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }
}

class PedometerSensorConfig extends AwareSensorConfig{
  PedometerSensorConfig({Key key, this.interval = 10});

  int interval;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class PedometerCard extends StatefulWidget {
  PedometerCard({Key key, @required this.sensor}) : super(key: key);

  final PedometerSensor sensor;

  @override
  PedometerCardState createState() => new PedometerCardState();

  String steps = "Steps: ";
}


class PedometerCardState extends State<PedometerCard> {

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          widget.steps = "Steps: ${event.toString()}";
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
          child: new Text(widget.steps),
        ),
      title: "Pedometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
