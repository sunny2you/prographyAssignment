import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Controller {
  final BehaviorSubject<void> _eventXStreamController = BehaviorSubject<void>();

  // Retrieve event from stream
  Stream<dynamic> get eventXStream {
    return _eventXStreamController.stream;
  }

  // Add event to stream
  Function(Null) get triggerEventX => _eventXStreamController.sink.add;

  void dispose() {
    _eventXStreamController.close();
  }
}

// Create an instance of the Controller
final controller = Controller();
