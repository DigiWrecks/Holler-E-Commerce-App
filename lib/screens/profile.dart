import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/widgets/button.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/profile-input-field.dart';
import 'package:suckless/widgets/toast.dart';

import 'login.dart';

class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController name = TextEditingController();
  TextEditingController buildingNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController aptNo = TextEditingController();
  TextEditingController crossSt = TextEditingController();
  TextEditingController phone = TextEditingController();
  String email;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    var sub =  await Firestore.instance.collection('users').where('email',isEqualTo: email).getDocuments();
    var list = sub.documents;

    setState(() {
      name.text = list[0]['name'];
      buildingNo.text = list[0]['buildingNo'];
      address.text = list[0]['address'];
      aptNo.text = list[0]['aptNo'];
      crossSt.text = list[0]['crossSt'];
      phone.text = list[0]['phone'];
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Profile',),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(40),),
              ProfileInputField(hint: 'Name',controller: name,),
              ProfileInputField(hint: 'Building Number',controller: buildingNo,),
              ProfileInputField(hint: 'Address',controller: address,),
              ProfileInputField(hint: 'Apt Number',controller: aptNo,),
              ProfileInputField(hint: 'Cross Street',controller: crossSt,),
              ProfileInputField(hint: 'Phone Number',type: TextInputType.phone,controller: phone,),
              SizedBox(height: ScreenUtil().setHeight(20),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: Button(text: 'Update',onTap: (){
                  try{
                    Firestore.instance.collection('users').document(email).updateData({
                        'name': name.text,
                        'buildingNo': buildingNo.text,
                        'address': address.text,
                        'aptNo': aptNo.text,
                        'crossSt': crossSt.text,
                        'phone': phone.text
                    });
                    getData();
                    ToastBar(text: 'Data Updated!',color: Colors.green).show();
                  }
                  catch(e){
                    ToastBar(text: 'Something went wrong',color: Colors.red).show();
                  }
                },icon: Icons.update,),
              ),
              SizedBox(height: ScreenUtil().setHeight(20),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: Button(text: 'Log Out',onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('email', null);
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                    return LogIn();}));
                },icon: Icons.exit_to_app,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
