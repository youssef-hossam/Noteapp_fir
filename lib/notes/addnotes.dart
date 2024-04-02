import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dproj/components/custombutton.dart';
import 'package:dproj/components/customtextfield.dart';
import 'package:dproj/notes/viewnotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key, required this.doc});
  final String doc;

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();

  Future addnote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.doc)
        .collection('notes');
    if (formstate.currentState!.validate()) {
      try {
        DocumentReference response = await notes.add({
          "note": note.text,
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewNotes(docid: widget.doc)),
        );
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Adding note",
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
              text: "   note",
              hinttext: "your note",
              controller: note,
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
                  addnote();
                })
          ],
        ),
      ),
    );
  }
}
