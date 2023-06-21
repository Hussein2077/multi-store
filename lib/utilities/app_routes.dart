
import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/customer_signup.dart';
import 'package:multi_store_app/auth/supplier_login.dart';
import 'package:multi_store_app/auth/supplier_signup.dart';
import 'package:multi_store_app/main_screens/customer_home.dart';
import 'package:multi_store_app/main_screens/supplier_home.dart';
import 'package:multi_store_app/main_screens/welcome_screen.dart';
import 'package:multi_store_app/on_boarding/on_boarding.dart';
import 'package:multi_store_app/utilities/routes.dart';
Map<String, Widget Function(BuildContext context)> routes = {
  //auth
  AppRoutes.welcomeScreen:(context)=>const WelcomeScreen(),
  AppRoutes.customerHomeScreen:(context)=>const CustomerHomeScreen(),
  AppRoutes.supplierHomeScreen:(context)=>const SupplierHomeScreen(),
  AppRoutes.customerRegister:(context)=>const CustomerRegister(),
  AppRoutes.customerLogin:(context)=>const CustomerRegister(),
  AppRoutes.supplierRegister:(context)=>const SupplierRegister(),
  AppRoutes.supplierLogin:(context)=>const SupplierLogin(),
  AppRoutes.onBoarding:(context)=>const OnBoarding(),

};
