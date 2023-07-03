// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_store_app/minor_screens/forgot_password.dart';
import 'package:multi_store_app/on_boarding/color.dart';
import 'package:multi_store_app/providers/auht_repo.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

import '../on_boarding/imageassets.dart';
import '../widgets/custom_text_field.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const AuthHeaderLabel(headerLabel: 'Log In'),
                        // const SizedBox(
                        //   height: 50,
                        // ),

                        Center(
                          child: Column(
                            children: [
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
                                prefixIcon: const Icon(Icons.lock_outline),
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
                                    color: AppColor1.grey,
                                  ),
                                ),
                              ),
                              HaveAccount(
                                haveAccount: 'Don\'t Have Account? ',
                                actionLabel: 'Sign Up',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/customer_signup');
                                },
                              ),
                              processing == true
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColor1.primaryColor))
                                  : AuthMainButton(
                                      mainButtonLabel: 'Login',
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
                                    onTap:(){},
                                      child: Image.asset(
                                          AppImageAsset.googleImage)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            '  Or  ',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget googleLogInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
      child: Material(
        elevation: 3,
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
        child: MaterialButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                Text(
                  'Sign In With Google',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                )
              ]),
        ),
      ),
    );
  }
}
// Padding(
//   padding: const EdgeInsets.symmetric(vertical: 10),
//   child: Material(
//     shadowColor: Colors.grey.withOpacity(.3),
//     elevation: 10,
//     child: SizedBox(
//       height: 43,
//       width: 314,
//       child: TextFormField(
//
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'please enter your email ';
//           } else if (value.isValidEmail() == false) {
//             return 'invalid email';
//           } else if (value.isValidEmail() == true) {
//             return null;
//           }
//           return null;
//         },
//         onChanged: (value) {
//           email = value;
//         },
//
//         keyboardType: TextInputType.emailAddress,
//         decoration: textFormDecoration.copyWith(
//           hintText: 'Enter your email',
//
//         ),
//       ),
//     ),
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.symmetric(vertical: 10),
//   child: Material(
//     shadowColor: Colors.grey.withOpacity(.3),
//     elevation: 10,
//     child: TextFormField(
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'please enter your password';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         password = value;
//       },
//       obscureText: passwordVisible,
//       decoration: textFormDecoration.copyWith(
//         suffixIcon: IconButton(
//             onPressed: () {
//               setState(() {
//                 passwordVisible = !passwordVisible;
//               });
//             },
//             icon: Icon(
//               passwordVisible
//                   ? Icons.visibility
//                   : Icons.visibility_off,
//               color: AppColor1.primaryColor,
//             )),
//         labelText: 'Password',
//         hintText: 'Enter your password',
//       ),
//     ),
//   ),
// ),
