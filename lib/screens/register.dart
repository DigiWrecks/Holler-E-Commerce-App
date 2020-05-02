import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:suckless/widgets/custom-text.dart';
import 'package:suckless/widgets/input-field.dart';
import 'package:suckless/widgets/toast.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController buildingNo = TextEditingController();
  TextEditingController aptNo = TextEditingController();
  TextEditingController crossSt = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  String referrd;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference collectionReference = Firestore.instance.collection('users');

  signUp() async {
    if(email.text!='' && password.text!='' && name.text!=''&& address.text!=''&& buildingNo.text!=''&& aptNo.text!=''&& crossSt.text!=''&& phone.text!=''&& referrd!='init'){
      try{
        AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        FirebaseUser user = result.user;
        print(user.uid);

        await collectionReference.document(email.text).setData({
          'name': name.text,
          'email': email.text,
          'buildingNo': buildingNo.text,
          'address': address.text,
          'aptNo': aptNo.text,
          'firstOrder': false,
          'crossSt': crossSt.text,
          'phone': phone.text,
          'refferd': referrd,
        });

        name.clear();
        address.clear();
        email.clear();
        buildingNo.clear();
        aptNo.clear();
        crossSt.clear();
        phone.clear();
        password.clear();
        ToastBar(color: Colors.green,text: 'Signed Up Successfully!').show();
      }
      catch(E){
        ToastBar(color: Colors.red,text: 'Something Went Wrong!').show();
        print(E);
      }
    }else{
      ToastBar(color: Colors.red,text: 'Please Fill all the Fields!').show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    referrd = 'init';
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
            //image: DecorationImage(image: AssetImage('images/mainback.png'),fit: BoxFit.fitHeight),
            color: Colors.white
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    width: ScreenUtil().setWidth(350),
                    height: ScreenUtil().setHeight(350),
                    child: Image.asset('images/logo.png')),
              ),


              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), 0, ScreenUtil().setWidth(35), ScreenUtil().setWidth(10)),
                child: CustomText(text: 'Sign Up',size: ScreenUtil().setSp(70),color: Colors.black),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Full Name',controller: name,),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Building Number',controller: buildingNo),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Address',controller: address),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Apt Number',controller: aptNo),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Cross Street',controller: crossSt),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Phone Number',controller: phone,type: TextInputType.phone,),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: Container(
                          height: ScreenUtil().setHeight(120),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffE5E5E5)
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                              child: DropdownButton(
                                isExpanded: true,
                                underline: Divider(color: Color(0xffE5E5E5),height: 0,thickness: 0,),
                                items: [
                                  DropdownMenuItem(child: CustomText(text:'Who reffered you to us?',color: Colors.grey,),value: 'init',),
                                  DropdownMenuItem(child: CustomText(text:'Search Engine',color: Colors.grey,),value: 'Search Engine',),
                                  DropdownMenuItem(child: CustomText(text:'News Paper',color: Colors.grey,),value: 'News Paper',),
                                  DropdownMenuItem(child: CustomText(text:'Social Media',color: Colors.grey,),value: 'Social Media',),
                                  DropdownMenuItem(child: CustomText(text:'Word of Month',color: Colors.grey,),value: 'Word of Month',),
                                  DropdownMenuItem(child: CustomText(text:'Others',color: Colors.grey,),value: 'Others',),
                                ],
                                onChanged:(newValue){
                                  setState(() {
                                    referrd = newValue;
                                  });
                                },
                                value: referrd,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Email',type: TextInputType.emailAddress,controller: email,),
                      ),

                      Padding(
                        padding:  EdgeInsets.fromLTRB(ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), ScreenUtil().setWidth(35), 0),
                        child: InputField(hint: 'Password',isPassword: true,controller: password,),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(70)),
                        child: GestureDetector(
                          onTap: ()=>signUp(),
                          child: Container(
                            height: ScreenUtil().setHeight(120),
                            width: ScreenUtil().setWidth(320),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CustomText(text: "Submit",size: ScreenUtil().setSp(40),),
                                    SizedBox(width: ScreenUtil().setWidth(20),),
                                    Icon(Icons.assignment_turned_in,color: Colors.white,size: 27,),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
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
