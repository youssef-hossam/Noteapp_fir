import 'package:dproj/categories/add.dart';
import 'package:dproj/screens/home_page.dart';
import 'package:dproj/screens/imge_picker.dart';
import 'package:dproj/screens/signin_page.dart';
import 'package:dproj/screens/signup_page.dart';
import 'package:dproj/screens/usersfiltring.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'categories/edit.dart';
import 'firebase_options.dart';
import 'notes/viewnotes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        splitScreenMode: true,
        minTextAdapt: true,
        designSize: Size(360, 690),
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(color: Colors.orange),
                  backgroundColor: Colors.grey[50],
                  actionsIconTheme: IconThemeData(
                    color: Colors.orange,
                  )),
            ),
            routes: {
              "loginpage": (context) => const SigninPage(),
              "registerpage": (context) => const SignUpPage(),
              "homepage": (context) => const HomePage(),
              "addcategory": (context) => const AddCategory(),
              "filtring": (context) => const Filtring(),
            },
            debugShowCheckedModeBanner: false,
            home: FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified
                ? HomePage()
                : SigninPage(),
          );
        });
  }
}
