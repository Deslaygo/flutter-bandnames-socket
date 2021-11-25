import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('se ejecuta clic');
          socketService.socket?.emit('emitir-mensaje', {
            'nombre': 'Flutter',
            'mensaje': 'Mensaje desde flutter',
          });
        },
        child: const Icon(Icons.message),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Server status: ${socketService.serverStatus}')
          ],
        ),
      ),
    );
  }
}
