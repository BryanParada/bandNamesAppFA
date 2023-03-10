 
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  //funcion solo para emitir
  Function get emit => this._socket.emit;

  SocketService(){
    this._initconfig();
  }

  void _initconfig() {
 
      // Dart client
      this._socket = IO.io('http://10.0.2.2:3000',{
        'transports': ['websocket'],
        'autoConnect': true
      });

      this._socket.onConnect((_) { 
        this._serverStatus = ServerStatus.Online;
        notifyListeners();
      }); 

      this._socket.onDisconnect((_) {

        this._serverStatus = ServerStatus.Offline;
        notifyListeners();
 
      }); 

      // socket.on('nuevo-mensaje', (payload){
      //   //Probar en consola de navegador con socket.emit('emitir-mensaje',{name: 'bry', message:'hola'});
      //   print('nuevo-mensaje!: ');
      //   print('name:' + payload['name']);
      //   print('mesage:' + payload['message']);
      //   print(payload.containsKey('message2') ? payload['message2']: 'no hay message2');
         
      // });

      // socket.off('nuevo-meensaje');


  }


}