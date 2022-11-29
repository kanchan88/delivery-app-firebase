import 'package:flutter/material.dart';
import 'package:ykdelivery/models/OrderModel.dart';
import 'package:ykdelivery/screens/Orders.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {

  final OrderModel order;

  SignatureScreen(this.order);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signature"),
      ),
      body: Container(
        child: Column(
          children: [
            Signature(
              controller: _controller,
              height: MediaQuery.of(context).size.height*.82,
              backgroundColor: Colors.white,
            ),

            widget.order.payment=="Done"?
              Container(
                height: kToolbarHeight*0.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YkOrders(),));
                  },
                  child: Center(
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ):InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context)=>CollectCash(widget.order.payment),
                );
              },
              child: Container(
                height: kToolbarHeight*0.7,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(child: Text("Done",style: TextStyle(fontSize: 20.0, color: Colors.white) )),
              ),
            ),
          ],
        ),

      ),
    );
  }
}

class CollectCash extends StatelessWidget {

  final String cash;

  CollectCash(this.cash);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(6.0),
        width: double.infinity,
        height: 250.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          children: [
            SizedBox(height: 22.0,),

            Text("Cash Payment"),

            SizedBox(height: 22.0,),

            Divider(
              color: Colors.black54,
              height: 1.0,
            ),

            SizedBox(height: 16.0,),

            Text("Rs. $cash", style: TextStyle(fontSize: 50.0),),

            SizedBox(height: 16.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YkOrders(),));
                  },
                color: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Collect Cash", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                      Icon(Icons.attach_money, color: Colors.white, size: 26.0,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

