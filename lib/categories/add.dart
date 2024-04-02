import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dproj/components/custombutton.dart';
import 'package:dproj/components/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController categoryname = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  Future addCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add({
          "name": categoryname.text,
          "id": FirebaseAuth.instance.currentUser!.uid
        });
        Navigator.of(context).pushNamedAndRemoveUntil(
          'homepage',
          (route) => false,
        );
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Adding category",
        ),
      ),
      body: Form(
        key: formstate,
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            CustomTextformAuth(
              text: "   Name",
              hinttext: "",
              controller: categoryname,
              validator: (val) {
                if (val == "") {
                  return "it cant be empty";
                }
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomButtonAuth(
                title: "Add",
                onpressed: () {
                  addCategory();
                })
          ],
        ),
      ),
    );
  }
}
