import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
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

    socketService.socket.on('active-bands', _handleActiveBands );

    super.initState();
    
  }

  _handleActiveBands( dynamic payload ){

    this.bands = (payload as List)
      .map( (band) => Band.fromMap(band) )
      .toList();

      //para que redibuje widget completo cuando se reciba un evento
      setState(() {});

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
      body: Column(
        children: <Widget>[

            _showGraph(),


            Expanded(
            child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (_, i) => _bandTile(bands[i]), 
                ),
            ),
        ],

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

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      // onDismissed: ( direction ){ 
      //   // otra forma de declarar direction si no lo utilizamos es _
      //   //print('direction: $direction');
      //   //print('id: ${band.id}');
        
      //   //emitir: delete-band
      //   //{'id': band.id}  
      //     socketService.emit('delete-band', {'id': band.id}); 
        
      // },
      onDismissed: ( _ ) => socketService.emit('delete-band', {'id': band.id}),
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
                // onTap: (){
                //   // print(band.id);
                //   socketService.socket.emit('vote-band', { 'id': band.id });
                // },
                onTap: () => socketService.socket.emit('vote-band', { 'id': band.id }),
              ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if ( Platform.isAndroid){
      //Android
    return showDialog(
      context: context,
       builder: ( _ ) => AlertDialog(
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
        )
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
      //this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ));
      //setState(() {});

      //emitir: add-band
      //{name: name}      

      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {

    Map<String, double> dataMap = new Map();
    // dataMap.putIfAbsent('Flutter', () => 5);
    bands.forEach((band) {
      dataMap.putIfAbsent( band.name, () => band.votes.toDouble() );
    });

    final List<Color> colorList = [
      Colors.blue[50] as Color,
      Colors.blue[200] as Color,
      Colors.pink[50] as Color,
      Colors.pink[200] as Color,
      Colors.yellow[50] as Color,
      Colors.yellow[200] as Color,
    ];

    return dataMap.isNotEmpty ? Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800), 
          colorList: colorList, 
          chartType: ChartType.ring,
      )
    ): LinearProgressIndicator();  
  }


}