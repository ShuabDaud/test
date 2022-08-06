import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../widgets/gas_level.dart';
import '../widgets/gas_leakage.dart';
import '../models/gas_provider.dart';

class GaugeScreen extends StatefulWidget {
  @override
  State<GaugeScreen> createState() => _GaugeScreenState();
}

class _GaugeScreenState extends State<GaugeScreen> {
  // Map<String, double> _gasData = {
  //   'gasLevel': 0.0,
  //   'gasLeakage': 0.0,
  // };
  //  late Future<GasItem> futureGas;

  // @override
  // void initState() {
  //   super.initState();
  //   futureGas = Provider.of<GasProvider>(context).fetchGas();
  // }

  @override
  Widget build(BuildContext context) {
    final gasContainer = Provider.of<GasProvider>(context).fetAndSetGasInfo();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(title: Text('Gas Info')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GasLevel(gasLevel: 45), // server data should be here...
            ),
            Expanded(
              child: GasLeakage(gasLeakage: 55), // ...
            ),
          ],
        ),
      ),
    );
  }
}
