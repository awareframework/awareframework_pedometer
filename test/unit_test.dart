import 'package:test/test.dart';

import 'package:awareframework_pedometer/awareframework_pedometer.dart';

void main(){
  test("test sensor config", (){
    var config = PedometerSensorConfig();
    expect(config.debug, false);
  });
}