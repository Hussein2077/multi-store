
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store_app/on_boarding/static.dart';

import 'color.dart';
import 'onboarding_controller.dart';


class CustomDotControllerOnBoarding extends StatelessWidget {
  const CustomDotControllerOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingControllerImplement>(
        builder: (controller) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
                onBoardingList.length,
                    (index) => AnimatedContainer(
                  margin: const EdgeInsets.only(right: 5),
                  duration: const Duration(milliseconds: 900),
                  width: controller.currentPage == index ? 20 : 5,
                  height: 6,
                  decoration: BoxDecoration(
                      color: AppColor1.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ))
          ],
        ));
  }
}