import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';

/// The Pedometer measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = PedometerSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  PedometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = PedometerSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<PedometerData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = PedometerCard(sensor: sensor);
/// ```
class PedometerSensor extends AwareSensor {
  static const MethodChannel _pedometerMethod = const MethodChannel('awareframework_pedometer/method');
  // static const EventChannel  _pedometerStream  = const EventChannel('awareframework_pedometer/event');

  static const EventChannel  _onDataChangedStream = const EventChannel('awareframework_pedometer/event_on_data_changed');

  StreamController<PedometerData> onDataChangedStreamController = StreamController<PedometerData>();

  PedometerData latestData = PedometerData({});

  /// Init Pedometer Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = PedometerSensor.init(null);
  /// ```
  // PedometerSensor():super(null);

  /// Init Pedometer Sensor with PedometerSensorConfig
  ///
  /// ```dart
  /// var config =  PedometerSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = PedometerSensor.init(config);
  /// ```
  PedometerSensor.init(PedometerSensorConfig config) : super(config){
    super.setMethodChannel(_pedometerMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<PedometerData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  Stream<PedometerData> get onDataChanged{
    onDataChangedStreamController.close();
    onDataChangedStreamController = StreamController<PedometerData>();
    return onDataChangedStreamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream( _onDataChangedStream, "on_data_changed").map(
            (dynamic event) => PedometerData(Map<String,dynamic>.from(event))
    ).listen((event){
      latestData = event;
      if (!onDataChangedStreamController.isClosed){
        onDataChangedStreamController.add(event);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
  }
}


/// A configuration class of PedometerSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  PedometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class PedometerSensorConfig extends AwareSensorConfig{
  PedometerSensorConfig({this.interval = 10});

  int interval;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}


/// A data model of PedometerSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class PedometerData extends AwareData {

  int startDate= 0;
  int endDate  = 0;
  double frequencySpeed = 0.0;
  int numberOfSteps     = 0;
  double distance       = 0.0;
  double currentPace    = 0.0;
  double currentCadence = 0.0;
  int floorsAscended    = 0;
  int floorsDescended   = 0;
  double averageActivePace = 0.0;

  PedometerData(Map<String,dynamic>? data):super(data ?? {}){
    if (data != null) {
      startDate   = data["startDate"] ?? 0;
      endDate     = data["endDate"]   ?? 0;
      frequencySpeed = data["frequencySpeed"] ?? 0.0;
      numberOfSteps = data["numberOfSteps"] ?? 0;
      distance = data["distance"] ?? 0.0;
      currentPace = data["currentPace"] ?? 0.0;
      currentCadence = data["currentCadence"] ?? 0.0;
      floorsAscended = data["floorsAscended"] ?? 0;
      floorsDescended = data["floorsDescended"] ?? 0;
      averageActivePace = data["averageActivePace"] ?? 0.0;
      source = data;
    }
  }

  @override
  String toString() {
    if(source!=null){
      return source.toString();
    }
    return super.toString();
  }
}
