import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/screens/login.dart';
import 'package:suckless/widgets/button.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/toast.dart';

class ProductDescription extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final List priceList;
  final List sizeList;

  const ProductDescription({Key key, this.name, this.image, this.description, this.priceList, this.sizeList}) : super(key: key);


  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String size;
  String price;
  List<DropdownMenuItem<String>> itemsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    size=widget.sizeList[0];
    price = widget.priceList[0];
    for(int i=0;i<widget.sizeList.length;i++){
     setState(() {
       itemsList.add(
           DropdownMenuItem(child: CustomText(text: widget.sizeList[i],color: Colors.black,),value: widget.sizeList[i],)
       );
     });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: widget.name,),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),

        ),

        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
              child: Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setHeight(600),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xffB2B2B2),
                    border: Border.all(color: Colors.black,width: 2)
                ),

                child: Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setWidth(20)),
                  child: Image.network(widget.image),
                ),
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(100),
                  width: ScreenUtil().setWidth(360),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(11))
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomText(text: 'Size',size: ScreenUtil().setSp(45),color: Colors.black,),
                      SizedBox(width: ScreenUtil().setWidth(20),),
                      Container(
                        height: ScreenUtil().setHeight(70),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(11)),
                            color: Color(0xffB2B2B2)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                          child: DropdownButton(
                            underline: Divider(color: Color(0xffB2B2B2),height: 0,thickness: 0,),
                            items: itemsList,
                            onChanged:(newValue){
                            setState(() {
                              size = newValue;
                              var index = widget.sizeList.indexOf(newValue);
                              price = widget.priceList[index];
                            });
                          },
                            value: size,
                          ),
                        ),
                      ),
                    ],
                  ),


                ),

                Container(
                  height: ScreenUtil().setHeight(100),
                  width: ScreenUtil().setWidth(200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(11))
                  ),

                  child: Center(
                      child: CustomText(text: '\$$price',size: ScreenUtil().setSp(45),color: Colors.black,)),


                ),
              ],
            ),


            SizedBox(height: ScreenUtil().setHeight(60),),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffB2B2B2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50))
                ),

                child: Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(50),ScreenUtil().setWidth(50),ScreenUtil().setWidth(50),ScreenUtil().setWidth(10)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                            child: CustomText(text: widget.description,color: Colors.black,)),
                      ),

                      Button(
                        text: 'Add to Cart',
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String email = prefs.getString('email');
                          if(email!=null) {
                            try {
                              Firestore.instance.collection('cart').document(
                                  email).collection('items').add({
                                'item': widget.name,
                                'size': size,
                                'quantity': 1,
                                'unitPrice': int.parse(price),
                                'image': widget.image,
                                'price': int.parse(price),
                                'email': email
                              });
                              ToastBar(text: 'Item Added to the cart!', color: Colors.green).show();
                            }
                            catch (e) {
                              ToastBar(text: 'Something went wrong', color: Colors.red).show();
                            }
                          }else{
                            ToastBar(text: 'Sign in before adding to cart!', color: Colors.red).show();
                            Navigator.push(context, CupertinoPageRoute(builder: (context){
                              return LogIn();}));
                          }
                        },
                        icon: Icons.shopping_cart,
                      ),


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
