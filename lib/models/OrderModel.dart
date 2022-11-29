

class OrderModel{
  String orderNumber="";
  String deliveryTime="";
  String location="";
  String googleMap="";
  List<dynamic> contact = [];
  List<dynamic> orderItems =[];
  String senderDetails = "";
  String payment = "";
  String key = "";
  String status = "";

  OrderModel({required this.orderNumber, required this.deliveryTime, required this.contact, required this.googleMap, required this.location, required this.orderItems, required this.payment, required this.senderDetails, required this.key, required this.status});

}