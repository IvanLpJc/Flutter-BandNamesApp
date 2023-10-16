import 'package:band_names_app/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServerStatusPage extends StatelessWidget {
  static const String route = 'server_status';
  const ServerStatusPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Server Status: ${socketProvider.serverStatus}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketProvider.emit('emited_message',
              {"device": "phone", "nombre": "Iván", "msg": "Hola"});
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
