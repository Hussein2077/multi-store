// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_store_app/providers/auht_repo.dart';
import 'package:multi_store_app/utilities/routes.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';
import 'package:multi_store_app/widgets/custom_text_field.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

import '../minor_screens/forgot_password.dart';
import '../on_boarding/color.dart';
import '../on_boarding/imageassets.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = true;
  bool sendEmailVerification = false;
  bool docExists = false;
  CollectionReference customers =
  FirebaseFirestore.instance.collection('customers');
  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;

      print(googleUser!.id);
      print(FirebaseAuth.instance.currentUser!.uid);
      print(googleUser);
      print(user);

      docExists = await checkIfDocExists(user.uid);

      docExists == false
          ? await customers.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'profileimage': user.photoURL,
        'phone': '',
        'address': '',
        'cid': user.uid
      }).then((value) => navigate())
          : navigate();
    });
  }
  void navigate() {
    //Get.to(AppRoutes.customerHomeScreen);
    Navigator.pushReplacementNamed(context, AppRoutes.supplierHomeScreen);
  }
  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);

        await AuthRepo.reloadUserData();
        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();

          await Future.delayed(const Duration(milliseconds: 100))
              .whenComplete(() {
            Navigator.of(context).pushReplacementNamed('/supplier_home');
          });
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please check your inbox');
          setState(() {
            processing = false;
            sendEmailVerification = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });

        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      logo(h * .2),
                      SizedBox(
                        height: h * .019,
                      ),

                      SizedBox(
                        height: 50,
                        child: sendEmailVerification == true
                            ? Center(
                                child: YellowButton(
                                    label: 'Resend Email Verification',
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance.currentUser!
                                            .sendEmailVerification();
                                      } catch (e) {
                                        print(e);
                                      }
                                      Future.delayed(const Duration(seconds: 3))
                                          .whenComplete(() {
                                        setState(() {
                                          sendEmailVerification = false;
                                        });
                                      });
                                    },
                                    width: 0.6),
                              )
                            : const SizedBox(),
                      ),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'login as a Supplier',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor1.grey,
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CustomTextField(
                                  hintText: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter your email ';
                                    } else if (value.isValidEmail() == false) {
                                      return 'invalid email';
                                    } else if (value.isValidEmail() == true) {
                                      return null;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    email = value;
                                  },
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CustomTextField(
                                  hintText: 'Enter your password',
                                  obscureText: passwordVisible,
                                  prefixIcon: Icon(Icons.lock_outline),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter your password';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: AppColor1.primaryColor,
                                      )),
                                )),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()));
                              },
                              child: const Text(
                                'Forget password ? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColor1.grey,
                                ),
                              ),
                            ),
                            HaveAccount(
                              haveAccount: 'Don\'t Have Account? ',
                              actionLabel: 'Sign Up',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/supplier_signup');
                              },
                            ),
                            processing == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.purple,
                                  ))
                                : AuthMainButton(
                                    mainButtonLabel: 'Log In',
                                    onPressed: () {
                                      logIn();
                                    },
                                  ),
                  SizedBox(
                    height: h * .054,
                  ),
                  const Text(
                    'or with',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: h * .023,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap:(){
                            signInWithGoogle();
                          },
                          child: Image.asset(
                              AppImageAsset.googleImage)),
                          ],
                        ),
                    ]  )
              )],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
