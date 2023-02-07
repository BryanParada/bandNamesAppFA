 
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  get serverStatus => this._serverStatus;

  SocketService(){
    this._initconfig();
  }

  void _initconfig() {
 
      // Dart client
      IO.Socket socket = IO.io('http://10.0.2.2:3000',{
        'transports': ['websocket'],
        'autoConnect': true
      });

      socket.onConnect((_) { 
        this._serverStatus = ServerStatus.Online;
        notifyListeners();
      }); 

      socket.onDisconnect((_) {

        this._serverStatus = ServerStatus.Offline;
        notifyListeners();
 
      }); 


  }


}