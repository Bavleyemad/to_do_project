import 'package:flutter/material.dart';

typedef Valedator=String? Function(String? text);
class AddTaskSheet extends StatelessWidget {
  final String title;
int lines;

  final TextInputType inputType;
  Valedator? validatior;
  bool isSecure;
  TextEditingController? controller=null;

   AddTaskSheet({super.key,
    required this.title,

    this.inputType = TextInputType.text,

    this.isSecure =false,
    this.validatior,
    this.controller,
   this.lines=1});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: validatior,

              decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red,fontSize: 20),


                  hintStyle: TextStyle(fontWeight: FontWeight.w500),
                labelText: title,
                floatingLabelBehavior: FloatingLabelBehavior.auto

              ),
              keyboardType: inputType,
              obscureText: isSecure,
              controller: controller,
              maxLines:lines ,
              minLines: lines,
            ),

          ],
        ),
      ) ,
    );
  }
}
