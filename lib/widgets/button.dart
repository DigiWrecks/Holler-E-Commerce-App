import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'custom-text.dart';

class Button extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const Button({Key key, this.text, this.icon, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1520,allowFontScaling: false);
    return RaisedButton(
      onPressed: onTap,
      color: Theme.of(context).primaryColor,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomText(text: text,),
          SizedBox(width: ScreenUtil().setWidth(30),),
          Icon(icon,color: Colors.white,)
        ],
      ),
    );
  }
}
