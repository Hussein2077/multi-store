import 'package:flutter/material.dart';
import 'package:multi_store_app/on_boarding/color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
   required this.onChanged,
    this.validator, this.keyboardType, this.suffixIcon,
  }) : super(key: key);
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.grey.withOpacity(.3),
      elevation: 10,
      child: SizedBox(
        
        height: 43,
        width: 314,
        child: TextFormField(

          keyboardType: keyboardType,
          onChanged: onChanged,
            validator: validator,

            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                color: AppColor1.primaryColor,
              ),
              suffixIconColor: AppColor1.primaryColor,
prefixIconColor: AppColor1.grey,
suffixIcon:suffixIcon ,
errorBorder: OutlineInputBorder(
  borderRadius:BorderRadius.circular(16),
  borderSide: const BorderSide(
    color: AppColor1.primaryColor,
    strokeAlign: BorderSide.strokeAlignCenter,
    style: BorderStyle.none

  ),
),
enabledBorder: OutlineInputBorder(
  borderSide: const BorderSide(
      color: Colors.white,

  ),
  borderRadius: BorderRadius.circular(16),
),
focusedBorder: OutlineInputBorder(
  borderSide: const BorderSide(
      color: Colors.white,
  ),
  borderRadius: BorderRadius.circular(16),
),

              hintText: hintText,
              hintTextDirection: TextDirection.ltr,

              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.grey),
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,

                ),
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: prefixIcon,
            )),
      ),
    );
  }
}
