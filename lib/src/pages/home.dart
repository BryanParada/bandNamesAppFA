import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    new Band(id: '1', name: 'Metallica', votes: 5),
    new Band(id: '2', name: 'Mystery', votes: 2),
    new Band(id: '3', name: 'Bad Religion', votes: 3),
    new Band(id: '4', name: 'Erra', votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1
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

  ListTile _bandTile(Band band) {
    return ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
            onTap: (){
              print(band.name);
            },
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