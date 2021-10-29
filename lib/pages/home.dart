import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//models
import '../models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Nirvana', votes: 2),
    Band(id: '2', name: 'Black sabbath', votes: 9),
    Band(id: '3', name: 'Red hot chilli peper', votes: 6),
    Band(id: '4', name: 'Queen', votes: 3),
  ];

  void addNewBand() {
    final nameTxtController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
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
            );
          });

      return;
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
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
                  onPressed: () {
                    addBandToList(nameTxtController.text);
                  },
                  isDefaultAction: true,
                  child: const Text('Add'),
                ),
              ],
            );
          });
      return;
    }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (ctx, i) => _bandTile(bands[i])),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        print('Id: ${band.id}');
        // TODO: llamar al borrado de la banda
      },
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
        onTap: () {},
      ),
    );
  }
}
