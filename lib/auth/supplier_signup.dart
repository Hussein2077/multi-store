// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/on_boarding/color.dart';
import 'package:multi_store_app/providers/auht_repo.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';
import 'package:multi_store_app/widgets/custom_text_field.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({Key? key}) : super(key: key);

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  late String storeName;
  late String email;
  late String password;
  late String storeLogo;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;
  dynamic _pickedImageError;

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await AuthRepo.singUpWithEmailAndPassword(email, password);

          AuthRepo.sendEmailVerification();

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('supp-images/$email.jpg');

          await ref.putFile(File(_imageFile!.path));
          _uid = AuthRepo.uid;

          storeLogo = await ref.getDownloadURL();

          AuthRepo.updateUserName(storeName);
          AuthRepo.updateProfileImage(storeLogo);

          await suppliers.doc(_uid).set({
            'storename': storeName,
            'email': email,
            'storelogo': storeLogo,
            'phone': '',
            'sid': _uid,
            'coverimage': '',
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          await Future.delayed(const Duration(milliseconds: 100))
              .whenComplete(() {
            Navigator.of(context).pushReplacementNamed('/supplier_login');
          });
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });

          MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());

          /*  setState(() {
            processing = false;
          });

          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exists for that email.');
          } */
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please pick image first');
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
                    children: [
                      logo(h*.15),

                      SizedBox(
                        height: h * .01,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColor1.grey,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColor1.grey,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImageFromCamera();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColor1.grey,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child:CustomTextField(
                          hintText: 'Enter your Full Name',
                            obscureText: false,
                            prefixIcon: const Icon(Icons.person),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your full name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            storeName = value;
                          },)
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child:CustomTextField(
                            hintText: 'Enter your Email',
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
                            keyboardType: TextInputType.emailAddress,
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child:CustomTextField(
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
                                    color: AppColor1.primaryColor)),

                            hintText: 'Enter your password',

                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: passwordVisible,
                          )
                      ),

                      HaveAccount(
                        haveAccount: 'already have account? ',
                        actionLabel: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_login');
                        },
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.purple,
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Sign Up',
                              onPressed: () {
                                signUp();
                              },
                            ),
                    ],
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
