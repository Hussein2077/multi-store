
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';

import '../minor_screens/forgot_password.dart';
import '../on_boarding/color.dart';
import '../providers/auht_repo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/snackbar.dart';

class CustomerLogInScreen extends StatefulWidget {
  const CustomerLogInScreen({Key? key}) : super(key: key);

  @override
  State<CustomerLogInScreen> createState() => _CustomerLogInScreenState();
}

class _CustomerLogInScreenState extends State<CustomerLogInScreen> {
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

  bool docExists = false;

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

  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = true;

  void navigate() {
    Navigator.pushReplacementNamed(context, '/customer_home');
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

          navigate();
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please check your inbox');
          setState(() {
            processing = false;
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
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: h * .13,
                ),
                //logo
                SizedBox(
                  height: h * .016,
                ),
                const Text(
                  'your beauty is priceless',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: h * .0627,
                ),
                const Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: h * .0142,
                ),
                Column(
                  children: [
                    CustomTextField(
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
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Email',
                      obscureText: false,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      hintText: 'Password',
                      obscureText: true,
                      prefixIcon: Icon(Icons.lock_outline),
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Row(
                    children: [

                      const SizedBox(
                        width: 30,
                      ),
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
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * .0177,
                ),
                processing == true
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColor1.primaryColor
                    ))
                    : AuthMainButton(
                  mainButtonLabel: 'Log In',
                  onPressed: () {
                    logIn();
                  },
                ),
                SizedBox(
                  height: h * .0177,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 96),
                  child: Row(
                    children: [
                      const Text(
                        'Don’t have account? ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/customer_signup');
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: AppColor1.primaryColor),
                          ))
                    ],
                  ),
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
                Padding(
                  padding: EdgeInsets.only(left: w * .34),
                  child: const Row(
                    children: [
                      // Image.asset(AppImageAsset.googleImage),
                      // Image.asset(AppImageAsset.facebookImage),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
