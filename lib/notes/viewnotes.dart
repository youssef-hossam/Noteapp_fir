import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dproj/categories/edit.dart';
import 'package:dproj/notes/addnotes.dart';
import 'package:dproj/notes/editnotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewNotes extends StatefulWidget {
  ViewNotes({super.key, required this.docid});
  var docid;
  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  bool isloading = true;

  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("notes")
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotes(doc: widget.docid),
                ));
          },
          child: Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
          title: const Text(
            "HomePage",
            style: TextStyle(color: Colors.orange),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();

                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, "loginpage");
                },
                icon: const Icon(
                  Icons.logout,
                ))
          ],
        ),
        body: WillPopScope(
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 160,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'DELETE',
                          desc: 'are you sure to delete',
                          btnCancelText: "NO",
                          btnCancelOnPress: () {},
                          btnOkText: "yes",
                          btnOkOnPress: () {
                            FirebaseFirestore.instance
                                .collection('categories')
                                .doc(widget.docid)
                                .collection("notes")
                                .doc(data[index].id)
                                .delete();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) =>
                                  ViewNotes(docid: widget.docid),
                            ));
                          },
                        ).show();
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNotes(
                                    categorydoc: widget.docid,
                                    notedocid: data[index].id,
                                    oldnote: "${data[index]['note']}"),
                              ));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                // child: Image.asset(
                                //   "images/folder.png",
                                //   height: 100,
                                // ),
                                //
                                child: Text("${data[index]['note']}"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('homepage', (route) => false);
            return Future.value(false);
          },
        ));
  }
}
