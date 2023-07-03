
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'CustomDotControllerOnBoarding.dart';
import 'color.dart';
import 'custombotton.dart';
import 'customslider.dart';
import 'onboarding_controller.dart';


class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImplement()) ;
    return Scaffold(
        backgroundColor: AppColor1.backgroundColor,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*.98,
            child: Column(children: [
              const Expanded(
                flex: 4,
                child: CustomSliderOnBoarding(),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: const [
                      CustomDotControllerOnBoarding(),
                      Spacer(flex: 2),
                      CustomButtonOnBoarding()
                    ],
                  ))
            ]),
          ),
        ));
  }
}