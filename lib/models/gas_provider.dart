import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/gas_level.dart';

class GasProvider with ChangeNotifier {
  List<GasItem> _gas = [];

  List<GasItem> get gas {
    return [..._gas];
  }
// managing cart item...
  late Map<String, dynamic> _gasItems = {
 
  };

  Map<String, dynamic> get gasItems {
    return {..._gasItems};
  }
  // void gas(double gasLevel, double gasLeakage) {
  //   final url = 'https://gas-level-and-leakage-default-rtdb.firebaseio.com/';
  // }
  Future<Map<String, dynamic>> fetAndSetGasInfo() async {
    final url =
        'https://gas-level-and-leakage-default-rtdb.firebaseio.com/gasData.json';
    // // final response2 = await http.post(Uri.parse(url), body: json.encode({'gasLeakage': 44.0, 'gasLevel': 88.0}));
    final response = await http.get(Uri.parse(url));
    print('-----------> ${json.decode(response.body)['-N8jUmtTfSGdM0Z-6uhv']['gasLeakage']}');
    print('-----------> ${json.decode(response.body)['-N8jUmtTfSGdM0Z-6uhv']['gasLevel']}');
    final Map<String, dynamic> data =  json.decode(response.body)['-N8jUmtTfSGdM0Z-6uhv'];
    // print(data);
    _gasItems = data;
    print(_gasItems['gasLeakage']);
    

    return _gasItems;
    
    // final List<GasItem> loadedGasItem = [];
    // final Map<String, dynamic>? extractedData = json.decode(response.body);
    // if (extractedData == null) {
    //   return;
    // }
    // extractedData.forEach((key, value) {
    //   loadedGasItem.add(GasItem(id: key, gasLevel: value['gaslevel'] as double, gasLeakage: value['gasLeakage'] as double));
    // });
   
    // _gas = loadedGasItem;

    // notifyListeners();
  }

//   Future<GasItem> fetchGas() async {
//     final url = 'https://gas-level-and-leakage-default-rtdb.firebaseio.com/gasData.json';
//   final response = await http
//       .get(Uri.parse(url));
//       print(jsonDecode(response.body));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return GasItem.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load gas data');
//   }
// }
}

class GasItem {
  final String id;
  final double gasLevel;
  final double gasLeakage;

  GasItem({
    required this.id,
    required this.gasLevel,
    required this.gasLeakage,
  });
}
// class GasItem {
//   // final String id;
//   final double level;
//   final double leakage;

//   const GasItem({
//     required this.level,
//     required this.leakage,
//     // required this.id,
//   });

//   factory GasItem.fromJson(Map<String, dynamic> json) {
//     return GasItem(
//       // id: json['name'],
//       level: json['gasLevel'],
//       leakage: json['gasLeakage'],
//     );
//   }
// }
