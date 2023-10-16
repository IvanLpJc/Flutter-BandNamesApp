import 'dart:io';

import 'package:band_names_app/providers/socket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names_app/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    socketProvider.socket.on('active_bands', (payload) {
      _getActiveBands(payload);
    });
    super.initState();
  }

  _getActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.off('active_bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketProvider.serverStatus == ServerStatus.online
                ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.offline_bolt_outlined,
                    color: Colors.red,
                  ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: socketProvider.serverStatus == ServerStatus.connecting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bands.isEmpty
              ? const Center(
                  child: Text('No bands yet, tap the button bellow to add one'),
                )
              : Column(
                  children: [
                    if (bands.isNotEmpty) _showChart(),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: bands.length,
                        itemBuilder: (context, index) =>
                            _bandTile(bands[index]),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a new band here',
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketProvider.emit('remove_band', {"id": band.id}),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 10.0),
        child: const Align(
          alignment: Alignment.centerLeft,
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
          onTap: () => socketProvider.emit('increase_vote', {"id": band.id})),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
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
        ),
      );
    }
  }

  void addBandToList(String name) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    if (name.length > 1) {
      socketProvider.emit('add_band', {"name": name});
    }

    Navigator.pop(context);
  }

  _showChart() {
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      height: 200,
      width: double.infinity,
      child: PieChart(
        chartType: ChartType.ring,
        dataMap: dataMap,
      ),
    );
  }
}
