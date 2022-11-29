import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ykdelivery/main.dart';
import 'package:ykdelivery/models/OrderModel.dart';
import 'package:ykdelivery/screens/CompletedOrders.dart';
import 'package:ykdelivery/screens/SingleOrder.dart';

class YkOrders extends StatefulWidget {
  @override
  _YkOrdersState createState() => _YkOrdersState();
}

class _YkOrdersState extends State<YkOrders> {

  List<OrderModel> orders = [];

  int _selectedIndex = 0;
  int page1=0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orders: 28th March - PENDING"),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompletedOrders(),));
            }, icon: Icon(Icons.done_all))
          ],
        ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: ordersRef.onValue,
            builder: (BuildContext context, snapshot) {

              if (snapshot.hasData) {
                final myMessages = Map<dynamic, dynamic>.from(
                    (snapshot.data! as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
                myMessages.forEach((key, value) {
                  final currentMessage = Map<String, dynamic>.from(value);
                  print(key);
                  if(currentMessage['status'] != "done"){

                    orders.add(OrderModel(
                        orderNumber: currentMessage['orderNumber'],
                        deliveryTime: currentMessage['deliveryTime'],
                        contact: currentMessage['contact'],
                        googleMap: currentMessage['googleMap'],
                        location: currentMessage['location'],
                        orderItems: currentMessage['orderItems'],
                        payment: currentMessage['payment'],
                        senderDetails: currentMessage['senderDetails'],
                        key: key,
                        status: currentMessage['status']
                    ),
                    );
                  }
                },
                );

                return Container(
                  height: double.infinity,
                  child: orders.length == 0 ? Container(
                    child: Center(
                      child: Text("No Orders Pending"),
                    ),
                  ):ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return OrderInfo(orders[index], orders);
                    },
                  ),
                );
              }

              else if(snapshot.hasError){
                return Container(
                  child: Center(
                    child: Text("Opps! Something is wrong"),
                  ),
                );
              }

              else{
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


class OrderInfo extends StatelessWidget {
  final OrderModel singleOrder;
  final List<OrderModel> orders;

  OrderInfo(this.singleOrder, this.orders);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          orders.clear();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleOrder(singleOrder),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * .12,
          width: double.infinity,
          child: Container(
            child: Column(
              children: [
                // first row
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: Colors.pink,
                          ),
                          Text("Order #${singleOrder.orderNumber.toString()}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.pink,
                          ),
                          Text(singleOrder.deliveryTime.toString()),
                        ],
                      )
                    ],
                  ),
                ),

                // second row
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.pink,
                          ),
                          Text(singleOrder.contact[0].toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.pink,
                          ),
                          Text(singleOrder.location.toString()),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
