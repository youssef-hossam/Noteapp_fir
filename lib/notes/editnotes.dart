import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dproj/components/custombutton.dart';
import 'package:dproj/components/customtextfield.dart';
import 'package:dproj/notes/viewnotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditNotes extends StatefulWidget {
  const EditNotes(
      {super.key,
      required this.categorydoc,
      required this.notedocid,
      required this.oldnote});
  final String categorydoc;
  final notedocid;
  final String oldnote;

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();

  Future addnote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categorydoc)
        .collection('notes');
    if (formstate.currentState!.validate()) {
      try {
        await notes.doc(widget.notedocid).update({"note": note.text});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewNotes(docid: widget.categorydoc)),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    note.text = widget.oldnote;
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
                title: "Edit",
                onpressed: () {
                  addnote();
                })
          ],
        ),
      ),
    );
  }
}
