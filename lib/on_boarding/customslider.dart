
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store_app/on_boarding/static.dart';

import 'onboarding_controller.dart';


class CustomSliderOnBoarding extends GetView<OnBoardingControllerImplement> {
  const CustomSliderOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: controller.pageController,
        onPageChanged: (val) {
          controller.onPageChanged(val);
        },
        itemCount: onBoardingList.length,
        itemBuilder: (context, i) => Column(
          children: [
            Image.asset(
              onBoardingList[i].image!,
              // width: ,
              // height: 230,
              // fit: BoxFit.fill,
            ),

            // const SizedBox(height: 15),
            Text(onBoardingList[i].title!,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(

                )),
             SizedBox(height: MediaQuery.of(context).size.height*.066),

            Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  onBoardingList[i].body!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ],
        ));
  }
}