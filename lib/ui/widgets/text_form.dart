import 'package:flutter/material.dart';
typedef Valedator=String? Function(String? text);
class AppFormField extends StatelessWidget {
  final String title;
  final String label;
  Widget icon;
  final TextInputType inputType;
Valedator? validatior;
  bool isSecure;
  TextEditingController? controller=null;

  AppFormField({
    super.key,
    required this.title,
    required this.label,
    this.inputType = TextInputType.text,
    required this.icon,
    this.isSecure =false,
    this.validatior,
    this.controller
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: Theme.of(context).textTheme.titleSmall,),
        SizedBox(height: 15,),
        TextFormField(
          validator: validatior,

          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red,fontSize: 20),
suffixIcon: IconButton(onPressed: (){

},icon: icon,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

            ),
              filled: true,
            fillColor: Colors.white,
            label: Padding(
                padding: EdgeInsets.all(8),
                child: Text(label,style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),)),
            hintText: title,
            hintStyle: TextStyle(fontWeight: FontWeight.w500)

          ),
          keyboardType: inputType,
          obscureText: isSecure,
          controller: controller,
        )

      ],
    ) ;
  }
}
