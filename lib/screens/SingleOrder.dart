import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ykdelivery/main.dart';
import 'package:ykdelivery/models/OrderModel.dart';
import 'package:ykdelivery/screens/Orders.dart';
import 'package:ykdelivery/screens/SignatureScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleOrder extends StatefulWidget {

  final OrderModel orderModel;

  SingleOrder(this.orderModel);

  @override
  _SingleOrderState createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {

  String status = "start";

  @override
  void initState() {
    print(ordersRef.child(widget.orderModel.key).child("status").once());
    ordersRef.child(widget.orderModel.key).child("status").once().then((snapshot) {
      status = snapshot.snapshot.value.toString();
      if(status=="done"){
        status="Change to Pending";
      }
    });
    super.initState();
  }

  bool _getAllItems = false;

  void _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  handleStatus() async {

    final event = await ordersRef.child(widget.orderModel.key).once(DatabaseEventType.value);
    final evstatus = event.snapshot.value as Map;

    if(evstatus['status'] == "pending"){
      setState(() {
        ordersRef.child(widget.orderModel.key).child("status").set("on-delivery");
        status = "on-delivery";
      });
    }

    else if(evstatus['status'] == "on-delivery"){
      setState(() {
        ordersRef.child(widget.orderModel.key).child("status").set("completed");
        status = "completed";
      });
    }
    
    else if(evstatus['status'] == "completed"){
      ordersRef.child(widget.orderModel.key).child("status").set("done");
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignatureScreen(widget.orderModel),));
    }

    else if(evstatus['status'] == "done"){
      ordersRef.child(widget.orderModel.key).child("status").set("pending");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YkOrders(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${widget.orderModel.orderNumber}"),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text("Delivery Time: ", style: TextStyle(fontSize: 18.0, color: Colors.black54),),
                    Text("${widget.orderModel.deliveryTime}", style: TextStyle(fontSize: 18.0),)
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text("Location: ", style: TextStyle(fontSize: 18.0, color: Colors.black54,),),
                    Text("${widget.orderModel.location}", style: TextStyle(fontSize: 18.0),)
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text("Map: ", style: TextStyle(fontSize: 18.0, color: Colors.black54,),),
                    Flexible(
                        child: InkWell(
                          onTap:()=> _launchURL(widget.orderModel.googleMap),
                          child: Text("${widget.orderModel.googleMap}",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18.0),)))
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone: ",style: TextStyle(fontSize: 18.0, color: Colors.black54),),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      height: 50.0,
                      child: ListView.builder(
                        itemCount: widget.orderModel.contact.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: ()=> _launchURL("tel://${widget.orderModel.contact[index]}"),
                              child: Text("${index+1}. ${widget.orderModel.contact[index]}", style: TextStyle(fontSize: 18.0,)));
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text("Sender: ",style: TextStyle(fontSize: 18.0, color: Colors.black54),),
                    Text("${widget.orderModel.senderDetails}", style: TextStyle(fontSize: 18.0),)
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text("Payment: ",style: TextStyle(fontSize: 18.0, color: Colors.black54),),
                    Text("${widget.orderModel.payment}", style: TextStyle(fontSize: 18.0),)
                  ],
                ),
              ),

              CheckboxListTile(
                title: const Text('Order Items', style: TextStyle(fontSize: 18.0, color: Colors.black54),),
                value: _getAllItems,
                activeColor: Colors.green,
                checkColor: Colors.white,
                selected: _getAllItems,
                onChanged: (value) {
                  setState(() {
                    _getAllItems = value!;
                  });
                },
              ),

              Container(
                height: 2.0,
                color: Colors.black54,
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                height: 100.0,
                child: ListView.builder(
                  itemCount: widget.orderModel.orderItems.length,
                  itemBuilder: (context, index) {
                    return Text("${index+1}. ${widget.orderModel.orderItems[index]}", style: TextStyle(fontSize: 18.0,));
                },
                ),
              ),

              SizedBox(height: 30.0,),

              _getAllItems==true?InkWell(
                onTap: (){
                  handleStatus();
                },
                child: Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(child: Text(status,style: TextStyle(fontSize: 18.0, color: Colors.white) )),
                ),
              ):Text("Get All Products to process order!")
            ],
          ),
        ),
      ),
    );
  }
}
