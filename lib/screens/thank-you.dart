import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/screens/home.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/toast.dart';

class ThankYou extends StatefulWidget {
  final String orderNo;
  final String date;
  final String email;
  final double total;
  final List productList;
  final List priceList;
  final double tax;
  final int deliveryFee;

  const ThankYou({Key key, this.orderNo, this.date, this.email, this.total, this.productList, this.priceList, this.tax, this.deliveryFee}) : super(key: key);

  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {


  List<Widget> orders = [];
  clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    print(email);
    try{
      Firestore.instance.collection('cart').document(email).collection('items').getDocuments().then((snapshot){
        for(DocumentSnapshot ds in snapshot.documents){
          ds.reference.delete();
        }
      });
    }
    catch(e){
      ToastBar(text: 'Error',color: Colors.red).show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0;i<widget.productList.length;i++){
      orders.add(
          Padding(
            padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Container(
              width: ScreenUtil.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      width: ScreenUtil().setWidth(500),
                      child: CustomText(
                          text: widget.productList[i],
                          size: ScreenUtil().setSp(40),
                          color: Colors.black
                      )
                  ),
                  CustomText(text: '\$${widget.priceList[i]}',size: ScreenUtil().setSp(40),color: Colors.black),
                ],
              ),
            ),
          )
      );
    }
    Timer(Duration(seconds: 1), clearCart);

    print('lenght is ${orders.length}');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    var f = new NumberFormat("####.00", "en_US");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.home), onPressed: (){
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
            return Home();}));
        }),
        title: CustomText(text: 'Thank You',),
      ),

      body: Container(
        width: double.infinity,
        height: ScreenUtil.screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),
        ),

        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(60),),
                    CustomText(text: 'Thank You',size: ScreenUtil().setSp(60),color: Colors.black,),
                    CustomText(text: 'Your order has been recieved',size: ScreenUtil().setSp(30),color: Colors.black),
                    SizedBox(height: ScreenUtil().setHeight(60),),
                    CustomText(text: 'You will recieve a\nconformation email shortly',size: ScreenUtil().setSp(30),color: Colors.black),
                    SizedBox(height: ScreenUtil().setHeight(80),),
                    CustomText(text: 'Order Number : ${widget.orderNo}',size: ScreenUtil().setSp(40),color: Colors.black),
                    CustomText(text: 'Date : ${widget.date}',size: ScreenUtil().setSp(40),color: Colors.black),
                    CustomText(text: 'Email : ${widget.email}',size: ScreenUtil().setSp(40),color: Colors.black),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Color(0xffC4C4C4),
                height: ScreenUtil().setHeight(100),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                  child: Center(child: CustomText(text: 'Order Details',size: ScreenUtil().setSp(50),color: Theme.of(context).primaryColor,)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(20),),
                   Column(
                     children: orders,
                   ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(text: 'Tax',size: ScreenUtil().setSp(40),color: Colors.black),
                        CustomText(text: '\$${f.format(widget.tax)}',size: ScreenUtil().setSp(40),color: Colors.black),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(text: 'Delivery Fee',size: ScreenUtil().setSp(40),color: Colors.black),
                        CustomText(text: '\$${widget.deliveryFee}',size: ScreenUtil().setSp(40),color: Colors.black),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(text: 'Total',size: ScreenUtil().setSp(40),color: Colors.black),
                        CustomText(text: '\$${f.format(widget.total)}',size: ScreenUtil().setSp(40),color: Colors.black),
                      ],
                    )
                  ],
                ),
              ),

            ],
          ),
        ),

      ),

    );
  }
}
