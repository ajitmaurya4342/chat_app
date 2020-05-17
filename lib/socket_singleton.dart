import 'package:web_socket_channel/io.dart';

class SocketSingleton {
  static final SocketSingleton _singleton = SocketSingleton._internal();
   IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://192.168.0.105:5000/");

  String name = "Anant";

  factory SocketSingleton() {
    return _singleton;
  }

  SocketSingleton._internal();


}