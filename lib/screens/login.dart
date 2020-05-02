import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/screens/register.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/input-field.dart';
import 'package:suckless/widgets/toast.dart';

import 'home.dart';

class LogIn extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReference = Firestore.instance.collection('users');

  signInWithEmail(BuildContext context) async {
    try{
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      FirebaseUser user = result.user;
      print(user.uid);

      var sub = await Firestore.instance.collection('users').where('email',isEqualTo: email.text).getDocuments();
      var logged = sub.documents;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', user.email);
      prefs.setBool('firstOrder', logged[0]['firstOrder']);
//      prefs.setString('location', logged[0]['location']);
//      prefs.setString('name', logged[0]['fname']+' '+logged[0]['lname']);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
        return Home();}));
    }
    catch(E){
      print(E);
      ToastBar(color: Colors.red,text: 'Something went Wrong').show();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              //image: DecorationImage(image: AssetImage('images/back.png'),fit: BoxFit.fitHeight),
              color: Colors.white
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context){
                            return Register();}));
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(150),
                          width: ScreenUtil().setWidth(250),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                          ),
                          child: Center(
                              child: CustomText(text: 'SIGN UP',size: ScreenUtil().setSp(40),)),
                        ),
                      ),
                    ),
//                    Align(
//                      alignment: Alignment.topRight,
//                      child: Container(
//                          width: ScreenUtil().setWidth(350),
//                          height: ScreenUtil().setHeight(350),
//                          child: Image.asset('images/logo.png')),
//                    ),
                  ],
                ),


                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(200), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35)),
                  child: CustomText(text: 'Log In',size: ScreenUtil().setSp(70),color: Colors.black),
                ),


                Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
                  child: InputField(hint: 'Email',type: TextInputType.emailAddress,controller: email,),
                ),

                Padding(
                  padding:  EdgeInsets.all(ScreenUtil().setWidth(35)),
                  child: InputField(hint: 'Password',isPassword: true,controller: password,),
                ),


                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(90)),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: ()=>signInWithEmail(context),
                      child: Container(
                        height: ScreenUtil().setHeight(120),
                        width: ScreenUtil().setWidth(420),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
                        ),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CustomText(text: "Let's Shop",size: ScreenUtil().setSp(40),),
                                SizedBox(width: ScreenUtil().setWidth(20),),
                                Icon(Icons.shopping_basket,color: Colors.white,size: 27,),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =await SharedPreferences.getInstance();
                        prefs.setString('email', null);
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                          return Home();}));
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(140),
                        width: ScreenUtil().setWidth(320),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
                        ),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CustomText(text: "Login as\nguest",size: ScreenUtil().setSp(40),),
                                SizedBox(width: ScreenUtil().setWidth(20),),
                                Icon(Icons.group,color: Colors.white,size: 27,),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                ),


                
              ],
            ),
            
          ),
      ),
    );
  }
}
