import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dproj/components/custombutton.dart';
import 'package:dproj/components/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditCategory extends StatefulWidget {
  String oldname;
  var docid;
  EditCategory({super.key, required this.oldname, required this.docid});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController categoryname = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  Future editCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        categories.doc(widget.docid).update({
          "name": categoryname.text,
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
  void initState() {
    // TODO: implement initState
    categoryname.text = widget.oldname;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryname.dispose();
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
                title: "Edit",
                onpressed: () {
                  editCategory();
                })
          ],
        ),
      ),
    );
  }
}
        //update
        //if docid exist
        //else
        // create new

        // .set({
        //   "name": categoryname.text,
        // }, SetOptions(merge: true));