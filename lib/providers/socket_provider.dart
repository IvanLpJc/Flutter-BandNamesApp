import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, connecting }

class SocketProvider with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  SocketProvider() {
    _initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;

  Function get emit => _socket.emit;
  Function get off => _socket.off;

  set serverStatus(ServerStatus status) {
    _serverStatus = status;
    notifyListeners();
  }

  Socket get socket => _socket;

  void _initConfig() {
    _socket = io(
        // 'https://band-names-api.onrender.com', // Connection to the server hosted on render
        'http://192.168.1.176:3000', // Connection to the server locally
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect() // optional
            .build());

    socket.onConnect((_) {
      debugPrint(
        'Flutter connected to server',
      );
      serverStatus = ServerStatus.online;
    });
    socket.onDisconnect(
      (_) {
        debugPrint(
          'Flutter disconnected from server',
        );
        serverStatus = ServerStatus.offline;
      },
    );
    // socket.on('new_message', (payload) {
    //   print("New message from server");
    // });
  }
}
