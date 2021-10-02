import 'dart:async';

class StreamSocket {
  static List<String> messages = [];
  final _socketResponse = StreamController<String>();
  
  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
