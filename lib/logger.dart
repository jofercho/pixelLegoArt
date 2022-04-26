import 'package:logging/logging.dart';

class MyLogger{
  static init(){
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    // ignore: avoid_print
    print('${event.level.name}: ${event.time}: ${event.message}');
  },);
}
}