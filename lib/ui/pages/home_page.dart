import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names_app/models/band.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Héroes del Silencio', votes: 4),
    Band(id: '4', name: 'Bon Jovi', votes: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        bands.removeWhere((element) => element.id == widget.key.toString());
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 10.0),
        child: const Align(
          alignment: Alignment.centerLeft,
          // child: Text(
          //   'Delete band',
          //   style: TextStyle(color: Colors.white),
          // ),

          child: Icon(Icons.delete_outlined),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            band.name.substring(0, 2),
          ),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => print(band.name),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band'),
            content: TextField(controller: textController),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text(
                  'Dismiss',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              MaterialButton(
                onPressed: () => addBandToList(textController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New Band'),
            content: CupertinoTextField(controller: textController),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Dismiss'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => addBandToList(textController.text),
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      setState(() {
        bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      });
    }

    Navigator.pop(context);
  }
}
