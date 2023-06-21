import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../on_boarding/color.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final Color color ;
  final Color textColor ;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
 required   this.color,
   required this.textColor,
  }


  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: 55,
          width: 275,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
