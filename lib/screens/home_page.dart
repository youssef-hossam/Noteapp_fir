import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dproj/categories/edit.dart';
import 'package:dproj/notes/viewnotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.pushNamed(context, "addcategory");
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
      body: isloading
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewNotes(docid: data[index].id),
                        ));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'choose',
                      desc: 'what do you want to do',
                      btnCancelText: "edit",
                      btnCancelOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCategory(
                                  oldname: "${data[index]['name']}",
                                  docid: data[index].id),
                            ));
                      },
                      btnOkText: "delete",
                      btnOkOnPress: () {
                        FirebaseFirestore.instance
                            .collection('categories')
                            .doc(data[index].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("homepage");
                      },
                    ).show();
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(
                            "images/folder.png",
                            height: 100,
                          ),
                        ),
                        Text("${data[index]['name']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
