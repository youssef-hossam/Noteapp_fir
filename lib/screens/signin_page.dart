import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/custombutton.dart';
import '../components/customtextfield.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool isloading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (googleUser == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formstate,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 75.h,
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
                        height: 40.h,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
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
                        height: 20.h,
                      ),
                      CustomTextformAuth(
                          validator: (val) {
                            if (val == "") {
                              return "can't be empty";
                            }
                          },
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
                              onPressed: () async {
                                if (email.text == "") {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'enter your email to resre',
                                    btnOkOnPress: () {},
                                  ).show();
                                } else {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: email.text);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'you have been sent a reset email',
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                              child: Text(
                                "Forget password ?",
                                style:
                                    GoogleFonts.rubik(color: Colors.grey[700]),
                              ))
                        ],
                      ),
                      CustomButtonAuth(
                        title: "Login",
                        onpressed: () async {
                          if (formstate.currentState!.validate()) {
                            try {
                              isloading = true;
                              setState(() {});
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              isloading = false;
                              setState(() {});
                              if (FirebaseAuth
                                  .instance.currentUser!.emailVerified) {
                                Navigator.pushReplacementNamed(
                                    context, 'homepage');
                              } else {
                                print("please vreified your email ");
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.message ==
                                  "The supplied auth credential is incorrect, malformed or has expired.") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Invalid email or password!"),
                                      content: const Text("Please try again."),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Ok")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          }
                          ;
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle();

                          Navigator.pushNamedAndRemoveUntil(
                              context, "homepage", (route) => false);
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Color(0xFFF4d5a68)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Login with Google",
                                  style: GoogleFonts.varelaRound(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 10.w,
                              ),
                              Image.asset(
                                "images/4.png",
                                height: 25.h,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              )),
                          SizedBox(
                            width: 2.w,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'registerpage');
                            },
                            child: Text(
                              "Register",
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
