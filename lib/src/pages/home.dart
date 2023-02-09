import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // new Band(id: '1', name: 'Metallica', votes: 5),
    // new Band(id: '2', name: 'Mystery', votes: 2),
    // new Band(id: '3', name: 'Bad Religion', votes: 3),
    // new Band(id: '4', name: 'Erra', votes: 6),
  ];

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false); //*false, no se necesita redibujar nada ya que estamos en el initState!

    socketService.socket.on('active-bands', (payload) {
      // print(payload);

      this.bands = (payload as List)
      .map( (band) => Band.fromMap(band) )
      .toList();

      //para que redibuje widget completo cuando se reciba un evento
      setState(() {});

    });

    super.initState();
    
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
            ? Icon( Icons.check_circle, color: Colors.blue[300])
            : Icon( Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, i) => _bandTile(bands[i]), 
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed:  
          addNewBand  ,
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ){
        print('dreiction: $direction');
        print('id: ${band.id}');
        
        //TODO: llamar el borrado del server
        
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle( color: Colors.white))
        ),
      ),
      child: ListTile(
                leading: CircleAvatar(
                  child: Text(band.name.substring(0,2)),
                  backgroundColor: Colors.blue[100],
                ),
                title: Text(band.name),
                trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
                onTap: (){
                  print(band.name);
                },
              ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if ( Platform.isAndroid){
      //Android
    return showDialog(
      context: context,
       builder: ( _ ) {
        return AlertDialog(
          title: Text('New band name:'),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList( textController.text) 
              )
          ],
        );
       }
      );


    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true ,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text),
              ),
            CupertinoDialogAction(
              isDestructiveAction: true ,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
              ),

          ]
        );
      });
   
    
  }

  void addBandToList(String name){
    if(name.length > 1){
      this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ));
      setState(() {});
    }

    Navigator.pop(context);
  }

}