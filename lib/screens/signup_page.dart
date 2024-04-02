import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/custombutton.dart';
import '../components/customtextfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formstate,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70.r),
                        color: Colors.grey[200],
                      ),
                      child: Image.asset(
                        'images/logo.png',
                        width: 50.w,
                        height: 70.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                CustomTextformAuth(
                    validator: (val) {
                      if (val == "") {
                        return "can't be empty";
                      }
                    },
                    text: "Username",
                    hinttext: "Enter your name",
                    controller: username),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextformAuth(
                  validator: (val) {
                    if (val == "") {
                      return "can't be empty";
                    }
                  },
                  text: "Email",
                  hinttext: "Enter your email",
                  controller: email,
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextformAuth(
                    text: "password",
                    hinttext: "Enter password",
                    controller: password,
                    suffixicon: const Icon(
                      Icons.remove_red_eye_outlined,
                    )),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forget password ?",
                          style: GoogleFonts.rubik(color: Colors.grey[700]),
                        ))
                  ],
                ),
                CustomButtonAuth(
                  title: "Register",
                  onpressed: () async {
                    if (formstate.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        Navigator.pushReplacementNamed(context, 'loginpage');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          // print('The password provided is too weak.');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'The password provided is too weak.',
                            btnOkOnPress: () {},
                          ).show();
                        } else if (e.code == 'email-already-in-use') {
                          // print('The account already exists for that email.');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'The account already exists for that email.',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("already have an account ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, "loginpage");
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
