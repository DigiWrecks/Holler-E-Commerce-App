import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/screens/cart.dart';
import 'package:suckless/screens/product-description.dart';
import 'package:suckless/screens/profile.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/toast.dart';

import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference collectionReference  = Firestore.instance.collection("products");
  List<DocumentSnapshot> dataList;
  var subscription;
  bool firstOrder;
  String appbarName = 'Lube and Lotions';

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.pop(context);},
    );
    AlertDialog alert = AlertDialog(
      title: Text("Holler and Covid19"),
      content: Text("We love our customers. Our mission is to keep you satisfied and healthy. so we remain 24/7 OPEN to provide our service. We may experience little bit of delays. However We are closely monitoring the impact of COVID-19. In addition to ensure the safety and support of our customers, communities, and employees during this difficult time. . Thank you for choosing us. Keep positive, stay healthy, and contact us with any questions! We will get through this challenging time.",
        textAlign: TextAlign.justify,
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    var sub = await Firestore.instance.collection('users').where('email',isEqualTo: email).getDocuments();
    var logged = sub.documents;
    prefs.setBool('firstOrder', logged[0]['firstOrder']);
    setState(() {
      firstOrder = logged[0]['firstOrder'];
    });

  }

  refreshProducts(String filter){
    subscription = collectionReference.where('category',isEqualTo: filter).snapshots().listen((datasnapshot){
      setState(() {
        dataList = datasnapshot.documents;
      });
    });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    refreshProducts('lotions');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String email = prefs.getString('email');
              if(email!=null) {
                Navigator.push(context, CupertinoPageRoute(builder: (context){
                  return Cart();}));
              }
              else{
                ToastBar(text: 'Please sign in!', color: Colors.red).show();
                Navigator.push(context, CupertinoPageRoute(builder: (context){
                  return LogIn();}));
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            child: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String email = prefs.getString('email');
                if(email!=null) {
                  Navigator.push(context, CupertinoPageRoute(builder: (context){
                    return Profile();}));
                }
                else{
                  ToastBar(text: 'Please sign in!', color: Colors.red).show();
                  Navigator.push(context, CupertinoPageRoute(builder: (context){
                    return LogIn();}));
                }
              },
            ),
          )
        ],
        elevation: 0,
        title: CustomText(text: appbarName,),
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(50),),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          child: CustomText(text: 'Categories',size: ScreenUtil().setSp(50),),
                        ),
                      ),

                    SizedBox(height: ScreenUtil().setHeight(10),),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: (){
                          refreshProducts('lotions');
                          Navigator.pop(context);
                          appbarName = 'Lube and lotions';
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                              child: Image.asset('images/hand.png'),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Lube and lotions',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: (){
                          refreshProducts('leather');
                          Navigator.pop(context);
                          appbarName = 'Leather Cleaner';
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                              child: Image.asset('images/hand.png'),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Leather Cleaner',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: (){
                          refreshProducts('rings');
                          Navigator.pop(context);
                          appbarName = 'Cock Rings';
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                              child: Image.asset('images/hand.png'),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Cock Rings',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: (){
                          refreshProducts('supplements');
                          Navigator.pop(context);
                          appbarName = 'Supplement';
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                              child: Image.asset('images/hand.png'),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Supplement',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: (){
                          refreshProducts('condoms');
                          Navigator.pop(context);
                          appbarName = 'Condoms';
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                              child: Image.asset('images/hand.png'),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Condoms',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: CustomText(text: 'Sex Toys',size: ScreenUtil().setSp(50),),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: ()=>print('clicked'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
//                        SizedBox(
//                          width: ScreenUtil().setWidth(60),
//                          height: ScreenUtil().setHeight(60),
//                          child: Image.asset('images/hand.png'),
//                        ),
//                        SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Coming soon',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),



                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: CustomText(text: 'Unisex merchendise',size: ScreenUtil().setSp(50),),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(50),ScreenUtil().setHeight(40),0,0),
                      child: GestureDetector(
                        onTap: ()=>print('clicked'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
//                        SizedBox(
//                          width: ScreenUtil().setWidth(60),
//                          height: ScreenUtil().setHeight(60),
//                          child: Image.asset('images/hand.png'),
//                        ),
//                        SizedBox(width: ScreenUtil().setWidth(25),),
                            CustomText(text: 'Coming soon',size: ScreenUtil().setSp(40),color: Colors.black,)
                          ],
                        ),
                      ),
                    ),



                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: CustomText(text: 'About Us',size: ScreenUtil().setSp(50),),
                      ),
                    ),


                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: CustomText(text: 'Contact Us',size: ScreenUtil().setSp(50),),
                      ),
                    ),




                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Container(
        width: ScreenUtil.screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),
            //color: Colors.white
        ),

        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(100),
              color: Color(0xffFEF8D4),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                  child: GestureDetector(
                    onTap: ()=>showAlertDialog(context),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Holler and Covid19 - ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                          TextSpan(text: 'We love our customers. our mission is to keep you satisfied and healthy ',style: TextStyle(color: Colors.black)),
                          TextSpan(text: 'Read More',style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ),
            firstOrder==false ||firstOrder==null?Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),ScreenUtil().setWidth(20),ScreenUtil().setWidth(20),0),
                child: Container(
                  width: ScreenUtil().setWidth(450),
                  height: ScreenUtil().setHeight(80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black,width: 2)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomText(text: '\$10 off your first order',color: Colors.black,size: ScreenUtil().setSp(30),),
                      SizedBox(width: ScreenUtil().setWidth(30),),
                      SizedBox(
                        width: ScreenUtil().setWidth(50),
                        height: ScreenUtil().setHeight(50),
                        child: Image.asset('images/gift.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ):SizedBox.shrink(),
            Expanded(
              child: dataList!=null?GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
                padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                itemCount: dataList.length,
                itemBuilder: (context,i){
                  String name = dataList[i]['name'];
                  String image = dataList[i]['image'];
                  String price = dataList[i]['price'][0];
                  String description = dataList[i]['description'];
                  List sizeList = dataList[i]['size'];
                  List priceList = dataList[i]['price'];

                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context){
                        return ProductDescription(name: name,image: image,description: description,priceList: priceList,sizeList: sizeList,);}));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff9E9E9E),
                          border: Border.all(color: Colors.black,width: 2)
                      ),

                      child: Padding(
                        padding:  EdgeInsets.all(ScreenUtil().setWidth(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: CustomText(text: '\$$price',color: Color(0xffD62C6A),size: ScreenUtil().setSp(50),)),
                            Container(
                                height: ScreenUtil().setHeight(155),
                                child: Image.network(image,fit: BoxFit.contain,)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Color(0xffD62C6A),
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(30)
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(Icons.play_circle_filled,color: Colors.black,size: 25,)
                              ],
                            ),
                          ],
                        ),
                      ),

                    ),
                  );
                },
              ):Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
      ),
    );
  }
}
