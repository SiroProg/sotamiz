import '../constants/api_constants.dart';
import 'db_service.dart';
import '../utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initSocket(BuildContext context) {
    socket = IO.io('${ApiConstants.baseUrl}/---------/', {
      'transports': ['websocket'],
      'query': {
        'token': DBService.token,
      }
    });

    socket.onConnect((_) {
      info('Socket -> connect');
    });

    socket.onError((error) {
      info('Socket -> error: $error');
    });

    socket.onDisconnect((_) {
      info('Socket -> disconnect');
    });

    socket.connect();
  }

  void dispose() {
    socket.disconnect();
    info('Socket -> dispose');
  }
}

SocketService $socketService = SocketService();
