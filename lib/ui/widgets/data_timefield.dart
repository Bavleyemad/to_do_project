import 'package:flutter/material.dart';

class DataTimeField extends StatelessWidget {
  int lines;
  final TextInputType inputType;
  TextEditingController? controller=null;
  String title;
  String hint;
  VoidCallback? onclick;
  bool editable;
 DataTimeField({super.key,required this.title,required this.hint,
   this.inputType = TextInputType.text,
   this.controller,
   this.lines=1,
   this.onclick,
   this.editable=true
 });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blue)),
        SizedBox(height: 10,),
        TextFormField(
          onTap: (){
            onclick?.call();
          },
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red,fontSize: 20),
              hintStyle: TextStyle(fontWeight: FontWeight.w500),
              labelText: hint,
              floatingLabelBehavior: FloatingLabelBehavior.auto
          ),
          keyboardType: inputType,
         // obscureText: isSecure,
          controller: controller,
          maxLines:lines ,
          minLines: lines,
          enableInteractiveSelection: editable,
        )
      ],
    );
  }
}
