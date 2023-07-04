import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_store_app/on_boarding/static.dart';
import 'package:multi_store_app/utilities/routes.dart';

abstract class OnBoardingController extends GetxController {
  next();

  onPageChanged(int i);
}

class OnBoardingControllerImplement extends OnBoardingController {
  late PageController pageController;

  int currentPage = 0;

  @override
  next() {
    currentPage++;

    if (currentPage > onBoardingList.length - 1) {
      Get.offAllNamed(AppRoutes.welcomeScreen);
    } else {
      pageController.animateToPage(currentPage,
          duration: const Duration(microseconds: 800),
          curve: Curves.easeInCubic);
    }
  }

  @override
  onPageChanged(int i) {
    currentPage = i;
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
}
