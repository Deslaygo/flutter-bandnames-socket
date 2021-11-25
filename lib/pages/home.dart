import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

//models
import '../models/band.dart';
//providers
import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('active-bands', _handleActiveBands);
    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.off('active-bands');
    super.dispose();
  }

  void addNewBand() {
    final nameTxtController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Add new band'),
                content: TextField(
                  controller: nameTxtController,
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      addBandToList(nameTxtController.text);
                    },
                    textColor: Colors.red,
                    elevation: 5,
                    child: const Text('Add'),
                  )
                ],
              ));

      return;
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: const Text('Add new Band'),
                content: CupertinoTextField(
                  controller: nameTxtController,
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context),
                    isDestructiveAction: true,
                    child: const Text('Dismiss'),
                  ),
                  CupertinoDialogAction(
                    onPressed: () => addBandToList(nameTxtController.text),
                    isDefaultAction: true,
                    child: const Text('Add'),
                  ),
                ],
              ));
      return;
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.isNotEmpty) {
      socketService.socket?.emit('add-band', {'name': name.toString()});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 2,
          title: const Center(
            child: Text(
              'Band names',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                socketService.serverStatus == ServerStatus.online
                    ? Icons.online_prediction
                    : Icons.error,
                color: Colors.white,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewBand,
          elevation: 2,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            _showGraph(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (ctx, i) => _bandTile(bands[i])),
            ),
          ],
        ));
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket?.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: const [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[200],
          child: Text(
            band.name.substring(0, 2),
            style: const TextStyle(color: Colors.red),
          ),
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.socket?.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  Widget _showGraph() {
    final Map<String, double> dataMap = {};

    for (final band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    final gradientList = <List<Color>>[
      [
        const Color.fromRGBO(223, 250, 92, 1),
        const Color.fromRGBO(129, 250, 112, 1),
      ],
      [
        const Color.fromRGBO(129, 182, 205, 1),
        const Color.fromRGBO(91, 253, 199, 1),
      ],
      [
        const Color.fromRGBO(175, 63, 62, 1.0),
        const Color.fromRGBO(254, 154, 92, 1),
      ]
    ];

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 500),
        chartLegendSpacing: 32,
        gradientList: gradientList,
        centerText: 'BANDS',
        chartValuesOptions: const ChartValuesOptions(
          decimalPlaces: 2,
          showChartValuesInPercentage: true,
        ),
        emptyColorGradient: const [
          Color(0xff6c5ce7),
          Colors.blue,
        ],
      ),
    );
  }
}
