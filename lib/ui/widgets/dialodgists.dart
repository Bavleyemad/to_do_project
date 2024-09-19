import 'package:flutter/material.dart';

void showMessageDialog(BuildContext context,String message
    ,{required String posButtonTitle,
    required VoidCallback posButtonAction,bool isCancled=false
}){
showDialog(context: context, builder: (buildcontext){
  return AlertDialog(
    content: Text(message),
    actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
        posButtonAction.call();

      }, child: Text(posButtonTitle))
    ],
  );
},barrierDismissible: isCancled);
}
void showLoadingDialog(BuildContext context,{required String message,bool isCancled=true}){
  showDialog(context: context, builder: (buildcontext) {
    return AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10,),
          Text(message),
        ],
      ),

    );
  },
  barrierDismissible: isCancled);
}