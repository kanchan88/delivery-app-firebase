import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ykdelivery/screens/Orders.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child("orders");


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Map myData = {
    "orderNumber": "23771",
    "deliveryTime": "10AM - 12PM",
    "contact": [9843613265],
    "googleMap": "https://google.com/maps",
    "location": "Balaju",
    "orderItems": ["Cakes"],
    "payment": "950",
    "senderDetails": "Bhoh Katai",
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YK RIDE',
      theme: ThemeData(
        fontFamily: "Brand-Bold",
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        body: Container(
          child: Builder(
            builder:(context)=> InkWell(
              onTap: (){
//                ordersRef.push().set(myData);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YkOrders(),));
              },
              child: Center(
                child: Text("LOGIN TO CONTINUE"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}