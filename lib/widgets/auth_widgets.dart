import 'package:flutter/material.dart';

import '../on_boarding/color.dart';

class AuthMainButton extends StatelessWidget {
  final String mainButtonLabel;
  final Function() onPressed;
  const AuthMainButton(
      {Key? key, required this.mainButtonLabel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      width: 282,
      decoration:  BoxDecoration(
        color: AppColor1.primaryColor,
        borderRadius: BorderRadius.circular(16),

      ),
      // padding: const EdgeInsets.symmetric(vertical: 30),
      child: MaterialButton(
          // minWidth: double.infinity,
          onPressed: onPressed,
          child: Text(
            mainButtonLabel,
            style: const TextStyle(
              fontSize: 16,
              color: AppColor1.backgroundColor,
              fontWeight: FontWeight.w600,
            ),
          )),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;
  const HaveAccount(
      {Key? key,
      required this.actionLabel,
      required this.haveAccount,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          haveAccount,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500),        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              actionLabel,
              style: const TextStyle(color: AppColor1.primaryColor),

            ))
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const AuthHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(
                Icons.home_work,
                size: 40,
              ))
        ],
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  prefixIcon: const Icon(Icons.email_outlined),
  prefixIconColor: AppColor1.primaryColor,
  suffixIconColor: AppColor1.primaryColor,
  hintText: 'Enter your full name',
  hintStyle:
  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.grey),
  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
  border: OutlineInputBorder(
    borderSide: const BorderSide(
        color: Colors.white,
        width: .15
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
        color: Colors.white,
        width: .15
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
        color: Colors.white,
        width: .15
    ),
    borderRadius: BorderRadius.circular(16),
  ),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}
