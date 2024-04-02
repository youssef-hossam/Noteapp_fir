import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Filtring extends StatefulWidget {
  const Filtring({super.key});

  @override
  State<Filtring> createState() => _FiltringState();
}

List data = [];

class _FiltringState extends State<Filtring> {
  // initaldata() async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   QuerySnapshot userdata = await users.get();
  //   userdata.docs.forEach((element) {
  //     data.add(element);
  //   });
  //   setState(() {});
  // }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   initaldata();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     CollectionReference users =
        //         FirebaseFirestore.instance.collection('users');
        //     DocumentReference doc1 =
        //         FirebaseFirestore.instance.collection('users').doc("1");
        //     DocumentReference doc2 =
        //         FirebaseFirestore.instance.collection('users').doc("2");

        //     WriteBatch batch = FirebaseFirestore.instance.batch();
        //     batch.set(doc1, {
        //       'name': 'youssef',
        //       'age': 20,
        //       'money': "100",
        //       'phone': '11111',
        //     });
        //     batch.set(doc2, {
        //       'name': 'hossam',
        //       'age': 40,
        //       'money': "200",
        //       'phone': '22222',
        //     });

        //     batch.commit();
        //   },
        // ),

        appBar: AppBar(
          title: Text("users"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(snapshot.data!.docs[index].id);

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(documentReference);
                        if (snapshot.exists) {
                          var snapshotdata = snapshot.data();
                          if (snapshotdata is Map<String, dynamic>) {
                            int newmoney = snapshotdata['money'] + 100;
                            transaction
                                .update(documentReference, {'money': newmoney});
                          }
                        }
                      });
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("${snapshot.data!.docs[index]['name']}"),
                        subtitle: Text("${snapshot.data!.docs[index]['age']}"),
                        trailing:
                            Text("${snapshot.data!.docs[index]['money']}"),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
    

// Card(
//               child: ListTile(
//                 subtitle: Text("age  :${data[index]['age']}"),
//                 title: Text("${data[index]['name']}"),
//                 trailing: Text("${data[index]['money']}"),
//               ),
//             ), 
// 
// 
// (ListView.builder(
      //   itemCount: data.length,
      //   itemBuilder: (context, index) {
      //     return InkWell(
      //       onTap: () {
      //         DocumentReference documentReference = FirebaseFirestore.instance
      //             .collection('users')
      //             .doc(data[index].id);

      //         FirebaseFirestore.instance.runTransaction((transaction) async {
      //           DocumentSnapshot snapshot =
      //               await transaction.get(documentReference);
      //           if (snapshot.exists) {
      //             var snapshotdata = snapshot.data();
      //             if (snapshotdata is Map<String, dynamic>) {
      //               int newmoney = snapshotdata['money'] + 100;
      //               transaction.update(documentReference, {'money': newmoney});
      //             }
      //           }
      //         }).then((value) => Navigator.pushReplacementNamed(
      //               context,
      //               'filtring',
      //             ));
      //       },
      //     );
      //   },
      // )),