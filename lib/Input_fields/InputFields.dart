import 'package:flutter/material.dart';

class Inputfields extends StatelessWidget {
  final String label ;
  final String hint ;
  final TextEditingController controller ;
  final TextInputType keyboardType ;
  final Function(String)? onSubmitted;


  const Inputfields({
    super.key ,
    required this.onSubmitted ,
    required this.label ,
    required this.controller  ,
    this.hint = '' ,
    this.keyboardType = TextInputType.text ,

  }) ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:  controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmitted,

      decoration: InputDecoration(
        labelText: label ,
        labelStyle: TextStyle(color: Colors.black)  ,
        hintText: hint ,
        hintStyle: TextStyle(color: Colors.black) ,
        suffixIcon: InkWell(child: Icon(Icons.search)) ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0) ,
              borderSide: const BorderSide(color: Colors.grey) ,
        ) ,

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:  Colors.grey),
          borderRadius: BorderRadius.circular(12.0) ,
        ) ,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0) ,
          borderSide: BorderSide(color:Colors.blue)
        )
      ),
    );
  }
}
