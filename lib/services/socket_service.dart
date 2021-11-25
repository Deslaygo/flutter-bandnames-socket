import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket? get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    print('Se conecta al servicio');
    // Dart client
    _socket = IO.io('http://192.168.0.111:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.connect();

    _serverStatus = ServerStatus.online;
    notifyListeners();

    _socket!.on('nuevo-mensaje', (payload) {
      print("Nuevo mensaje de ${payload['nombre']}");
      print(payload['mensaje']);
      print(payload['mensaje2'] ?? 'no hay');
    });

    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
