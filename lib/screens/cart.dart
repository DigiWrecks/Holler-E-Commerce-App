import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/screens/checkout.dart';
import 'package:suckless/widgets/button.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/toast.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String delivery;
  int deliveryFee;
  double total = 0;
  String totalShow = '0.00';
  final CollectionReference collectionReference  = Firestore.instance.collection("cart");
  List<DocumentSnapshot> dataList;
  var subscription;
  bool firstOrder;


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
  
  popUpCard(var finalTot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    var sub = await Firestore.instance.collection('cards').where('email',isEqualTo: email).getDocuments();
    var cards = sub.documents;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.black,
          title: CustomText(text: 'Select Payment Method',align: TextAlign.center,color: Color(0xff9E9E9E),),
          content: Container(
            height: ScreenUtil().setHeight(500),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  cards!=null?
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: cards.length,
                    itemBuilder: (context,i){
                      return Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (context){
                                return Checkout(tot: finalTot,deliiveryTime: delivery,deliveryFee: deliveryFee,tax: tax,
                                cardHolderName: cards[i]['cardHolder'],
                                cardNumber: cards[i]['cardNumber'],
                                expiryDate: cards[i]['expdate'],
                                zipCode: cards[i]['zip'],
                                  isSavedCard: true,
                                );}));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.credit_card,color: Color(0xff9E9E9E),),
                                SizedBox(width: ScreenUtil().setWidth(30),),
                                CustomText(text: 'XXXX XXXX XXXX ${cards[i]['cardNumber'].substring(cards[i]['cardNumber'].length - 5)}',
                                size: ScreenUtil().setSp(35),
                                  color: Color(0xff9E9E9E),
                                ),
                              ],
                            )),
                      );
                    },
                  ):
                  Center(child: CircularProgressIndicator(),),
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context){
                          return Checkout(tot: finalTot,deliiveryTime: delivery,deliveryFee: deliveryFee,tax: tax,
                            cardHolderName: '',
                            cardNumber: '',
                            expiryDate: '',
                            zipCode: '',
                          );}));
                      },

                      child: CustomText(text: '+ Add new Card',color: Color(0xff9E9E9E),size: ScreenUtil().setSp(40)))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    firstOrder = prefs.getBool('firstOrder');
    subscription = collectionReference.document(email).collection('items').snapshots().listen((datasnapshot){
      setState(() {
        dataList = datasnapshot.documents;
        calculateTotal();
      });
    });
  }
double tax;
  calculateTotal(){
    total = 0;
    for(int i=0;i<dataList.length;i++){
      print(dataList[i]['price']);
      total += dataList[i]['price'];
    }
    total += deliveryFee;
    tax = total*4/100;
    total += tax;
    var f = new NumberFormat("###.00", "en_US");
    totalShow = f.format(total);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delivery = '7 AM - 5 PM';
    deliveryFee = 10;
    getData();

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'My Bag',),
      ),


      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),
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

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: dataList!=null?ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (context,i){
                          String name = dataList[i]['item'];
                          String image = dataList[i]['image'];
                          String email = dataList[i]['email'];
                          String docID = dataList[i].documentID;
                          int price = dataList[i]['price'];
                          int unitPrice = dataList[i]['unitPrice'];
                          int quantity = dataList[i]['quantity'];


                          return Padding(
                            padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                            child: Container(
                              width: ScreenUtil.screenWidth,
                              height: ScreenUtil().setHeight(225),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 12,
                                    child: Container(
                                      height: ScreenUtil().setHeight(225),
                                      decoration: BoxDecoration(
                                          color: Color(0xffB2B2B2),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                              height: ScreenUtil().setHeight(200),
                                              width: ScreenUtil().setWidth(120),
                                              child: Image.network(image)
                                          ),

                                          Container(
                                            width: ScreenUtil().setWidth(90),
                                            height: ScreenUtil().setHeight(90),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            child: Center(child: CustomText(text: '${quantity}x',color: Theme.of(context).primaryColor,size: ScreenUtil().setSp(40),)),
                                          ),


                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                                              child: Container(
                                                height: ScreenUtil().setHeight(180),
                                                child: Center(
                                                  child: Text(
                                                    name,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),


                                          Container(
                                            width: ScreenUtil().setWidth(90),
                                            height: ScreenUtil().setHeight(90),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            child: Center(child: CustomText(text: '\$$price',color: Theme.of(context).primaryColor,size: ScreenUtil().setSp(35),)),
                                          ),

                                          SizedBox(width: ScreenUtil().setWidth(20),)



                                        ],
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(icon: Icon(Icons.add,color: Colors.white,), onPressed: (){
                                          int newQuantity = quantity+1;
                                          Firestore.instance.collection('cart').document(email).collection('items').document(docID).updateData({
                                            'quantity': newQuantity,
                                            'price': newQuantity*unitPrice
                                          });
                                        }),
                                        Divider(color: Colors.white,thickness: 2,endIndent: 5,indent: 5,),
                                        IconButton(icon: Icon(Icons.remove,color: Colors.white,), onPressed: (){
                                          int newQuantity = quantity-1;
                                          if(newQuantity>=1){
                                            Firestore.instance.collection('cart').document(email).collection('items').document(docID).updateData({
                                            'quantity': newQuantity,
                                            'price': newQuantity*unitPrice
                                          });
                                          }
                                        }
                                        ),
                                      ],
                                    ),
                                  ),



                                ],
                              ),

                            ),
                          );
                        },
                      ):Center(child: CircularProgressIndicator(),),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CustomText(
                          text: 'Delivery fee',
                          size: ScreenUtil().setSp(40),
                            color: Colors.black
                        ),
                        Container(
                          height: ScreenUtil().setHeight(70),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Theme.of(context).primaryColor
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                            child: DropdownButton(
                              underline: Divider(color: Theme.of(context).primaryColor,height: 0,thickness: 0,),
                              items: [
                                DropdownMenuItem(child: CustomText(text:'7 AM - 5 PM',color: Colors.black,),value: '7 AM - 5 PM',),
                                DropdownMenuItem(child: CustomText(text:'5 PM - 7 AM',color: Colors.black,),value: '5 PM - 7 AM',),
                              ],
                              onChanged:(newValue){
                                setState(() {
                                  delivery = newValue;
                                  if(delivery=='7 AM - 5 PM'){
                                    deliveryFee = 10;
                                  }
                                  else{
                                    deliveryFee = 15;
                                  }
                                  calculateTotal();
                                });
                              },
                              value: delivery,
                            ),
                          ),
                        ),
                        CustomText(
                          text: '\$$deliveryFee',
                          size: ScreenUtil().setSp(40),
                            color: Colors.black
                        ),

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                      child: Divider(color: Colors.black,thickness: 3,indent: ScreenUtil().setWidth(100),endIndent: ScreenUtil().setWidth(100),),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(
                          text: 'Total(Including Tax)',
                          size: ScreenUtil().setSp(40),
                            color: Colors.black
                        ),
                        CustomText(
                          text: '\$$totalShow',
                          size: ScreenUtil().setSp(40),
                            color: Colors.black
                        ),

                      ],
                    ),

                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Button(
                      icon: Icons.credit_card,
                      onTap: (){



                        var finalTot;
                          if(firstOrder==false){
                            finalTot = total - 10;
                          }
                          else{
                            finalTot = total;
                          }

                          if(total<35){
                            ToastBar(text: 'You should buy at least \$35',color: Colors.red).show();
                          }
                          else{
                            popUpCard(finalTot);
                          }

                      },
                      text: 'Checkout',
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),

      ),


    );
  }
}
