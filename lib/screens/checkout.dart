import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:suckless/screens/thank-you.dart';
import 'package:suckless/widgets/button.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/profile-input-field.dart';
import 'package:suckless/widgets/toast.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  final double tot;
  final double tax;
  final int deliveryFee;
  final String deliiveryTime;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final bool isSavedCard;
  final String zipCode;
  const Checkout({Key key, this.tot, this.tax, this.deliveryFee, this.deliiveryTime, this.cardNumber, this.expiryDate, this.cardHolderName, this.zipCode, this.isSavedCard=false}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String cardNumber ='';
  String expiryDate='';
  String cardHolderName='';
  String cvvCode = '';
  TextEditingController zipCode = TextEditingController();
  bool isCvvFocused = false;
  bool isChecked = false;

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  List items = [];
  List prices = [];
  List quantity = [];
  var r;

  checkAvailiability() async {
    Random rnd = Random();
    r = 10000 + rnd.nextInt(99999 - 10000);
    var x = await Firestore.instance.collection('orders').where('code', isEqualTo: r.toString()).getDocuments();
    var availiable = x.documents;
    if(availiable.isEmpty){
      sendToFirestore(r.toString());
    }
    else{
      checkAvailiability();
    }
  }

  sendToFirestore(String code) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email');

      
      var sub = await Firestore.instance.collection('cart').document(email).collection('items').getDocuments();
      var data = sub.documents;
      
      for(int i=0;i<data.length;i++){
        items.add(data[i]['item']);
        prices.add(data[i]['price']);
        quantity.add(data[i]['quantity']);
      }
      
      Firestore.instance.collection('orders').add({
        'email': email,
        'total': widget.tot,
        'items': items,
        'prices': prices,
        'quantity': quantity,
        'tax': widget.tax,
        'deliveryTime': widget.deliiveryTime,
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'code': code,
        'deliveryFee': widget.deliveryFee
      });



    }
    catch(e){
      ToastBar(text: 'Something Went Wrong While Uploading Data!',color: Colors.red).show();
    }
  }

  saveCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    try{
      Firestore.instance.collection('cards').add({
        'cardNumber': cardNumber,
        'expdate': expiryDate,
        'cvv': cvvCode,
        'cardHolder': cardHolderName,
        'zip': zipCode.text,
        'email': email
      });
    }
    catch(e){
      ToastBar(text: 'Something Went Wrong While saving card!',color: Colors.red).show();
    }
  }

  sendMail() async {
    String username = 'hollerapp3@gmail.com';
    String password = 'Admin@holler';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');


      final smtpServer = gmail(username, password);
      // Create our message.
      final message = Message()
        ..from = Address(username, 'Holler')
        ..recipients.add(email)
        ..subject = 'Order Placed'
        ..text = 'You have successfully placed your order!\n'
            'Order ID - ${r.toString()}';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }



  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_synJJt6i1Iv9Djp6cmtdeQiS00vQUt7jk7",
        androidPayMode: 'test',
      ),
    );


    print(widget.cardNumber);
    print(widget.expiryDate);
    print(widget.cardHolderName);
    print(widget.zipCode);

    setState(() {
      cardNumber = widget.cardNumber;
      expiryDate = widget.expiryDate;
      cardHolderName = widget.cardHolderName;
      zipCode.text = widget.zipCode;
    });


  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    var f = new NumberFormat("###.00", "en_US");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Checkout',),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),

        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(40),),
            Container(
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(300),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(11)),
                  color: Theme.of(context).primaryColor
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomText(text: 'Total',size: ScreenUtil().setSp(40),color: Colors.black,),
                    CustomText(text: '\$${f.format(widget.tot)}',size: ScreenUtil().setSp(40)),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardWidget(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: isCvvFocused,
                    ),
                    CreditCardForm(
                      textColor: Colors.black,
                      themeColor: Colors.black,
                      cardHolderName: cardHolderName,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    ProfileInputField(
                      controller: zipCode,
                      hint: 'Zip Code',
                    ),
                    widget.isSavedCard==false?Row(
                      children: <Widget>[
                        Checkbox(
                          value: isChecked,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });},
                        ),
                        CustomText(text: 'Save My Card Details',color: Colors.black,),
                      ],
                    ):SizedBox.shrink(),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                      child: Button(
                        text: 'Buy',
                        icon: Icons.work,
                        onTap: (){
                          ToastBar(text: 'Please wait',color: Colors.orange).show();
                          try{
                            final CreditCard testCard = CreditCard(
                              number: cardNumber,
                              expMonth: int.parse(expiryDate[0]+expiryDate[1]),
                              expYear: int.parse(expiryDate[3]+expiryDate[4]),
                              cvc: cvvCode,
                            );

                            //print(int.parse(expiryDate[3]+expiryDate[4]));
                            StripePayment.createTokenWithCard(
                              testCard,
                            ).then((token) async {
                              try{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                bool firstOrder = prefs.getBool('firstOrder');
                                String email = prefs.getString('email');
                                var response = await http.post('https://api.stripe.com/v1/charges',
                                  body: {'amount': '${(widget.tot*100).round().toString()}','currency': 'usd',"source": token.tokenId},
                                  headers: {'Authorization': "Bearer sk_test_vTXA4GHwEBQdvAksITYhWUvd007cKf6Xw0"},
                                );
                                print('Response status: ${response.statusCode}');
                                print('Response body: ${response.body}');
                                
                                if(response.statusCode == 200){
                                  if(firstOrder==false){
                                    Firestore.instance.collection('users').document(email).updateData({
                                      'firstOrder': true
                                    });
                                  }
                                  if(isChecked==true){
                                    saveCard();
                                  }
                                 await checkAvailiability();
                                  await sendMail();


                                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                                    return ThankYou(
                                      email: email,
                                      orderNo: r.toString(),
                                      tax: widget.tax,
                                      deliveryFee: widget.deliveryFee,
                                      priceList: prices,
                                      productList: items,
                                      total: widget.tot,
                                      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                    );}));

                                }
                                else{
                                  ToastBar(text: 'Something went Wrong While Processing the Payment',color: Colors.red).show();
                                }
                                
                                
                                
                                
                              }
                              catch(e){
                                ToastBar(text: 'Something went Wrong While Processing the Payment',color: Colors.red).show();
                              }
                            });
                          }
                          catch(e){

                          }
                        },
                      ),
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
