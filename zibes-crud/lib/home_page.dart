import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/read%20data/get_user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!;

// document IDs
List<String> docIDs = [];

// get docIDs
Future getDocId() async {
  await FirebaseFirestore.instance.collection('users').get().then(
    (snapshot) => snapshot.docs.forEach((document){
    print(document.reference);
    docIDs.add(document.reference.id);
  }),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16), 
        ),
        actions: [
          GestureDetector(
            onTap: (){
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.logout),),
          ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Signed In as: ${user?.email}",
            style: const TextStyle(fontSize: 30),
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: const Color.fromARGB(255, 9, 83, 11),
            child: const Text('Sign out'),
          ),
          Expanded(
            child: FutureBuilder(
              future: getDocId(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: GetUserName(documentId: docIDs[index]),
                      tileColor: Colors.green[200],
                    );
                  },
                );
              },
            ),
              
            
        ),

        ],
      )),
    );
  }
}