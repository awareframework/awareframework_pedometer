import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_pedometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkPedometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, PedometerObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.pedometerSensor = PedometerSensor.init(PedometerSensor.Config(json))
            }else{
                self.pedometerSensor = PedometerSensor.init(PedometerSensor.Config())
            }
            self.pedometerSensor?.CONFIG.sensorObserver = self
            return self.pedometerSensor
        }else{
            return nil
        }
    }

    var pedometerSensor:PedometerSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkPedometerPlugin(),
                          methodChannelName: "awareframework_pedometer/method",
                          eventChannelName: "awareframework_pedometer/event")

    }


    public func onPedometerChanged(data: PedometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }

}
