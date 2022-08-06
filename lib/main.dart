import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/gas_provider.dart';
import '../screens/gas_screen.dart';

import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import './screens/screens.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './models/products_provider.dart';
import './models/orders.dart';
import './models/auth.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),
        // ChangeNotifierProxyProvider<Auth, ProductsProvider>(
        //   create: (_) => ProductsProvider(), 
        //   update: (_, auth, data) => ,
        // ),
        ChangeNotifierProvider<Orders>(
          create: (_) => Orders(),
        ),
        ChangeNotifierProvider<GasProvider>(create: (_) => GasProvider(),),
      ], // creates an obj that will be listened.
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          /*  theme: ThemeData().copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.deepOrange,
          
          ),
          primaryColor: 
          
        ), */
          theme: ThemeData(
              accentColor: Colors.deepOrange,
              primarySwatch: Colors.purple,
              fontFamily: 'Lato'),
          // home: auth.isToken ? ProductScreen() : AuthScreen(),
          home: GaugeScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserPorductsScreen.routeName: (context) => UserPorductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<Album> fetchAlbum() async {
//   final url = 'https://gas-level-and-leakage-default-rtdb.firebaseio.com/gasData.json';
//   final response = await http
//       .get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

// class Album {
//   final String id;
//   final double gasLevel;
//   final double gasLeakage;

//   const Album({
//     required this.id,
//     required this.gasLevel,
//     required this.gasLeakage,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id:  json['name'],
//       gasLevel: json['gasLevel'],
//       gasLeakage: json['gasLeakage'],
//     );
//   }
// }

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   // const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Future<Album> futureAlbum;

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<Album>(
//             future: futureAlbum,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data!.gasLevel.toString());
//               } else if (snapshot.hasError) {
//                 return Text('${snapshot.error}');
//               }

//               // By default, show a loading spinner.
//               return const CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
