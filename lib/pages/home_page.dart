import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudtutorial/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore use to perform operations in direct firebase
  final FireStoreService firestoreService = FireStoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  //open dialog box when user click add button
  void openNoteBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                //button to save
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      //add a new note
                      if (docId == null) {
                        firestoreService.addNote(textController.text);
                      } else {
                        firestoreService.updateNote(docId, textController.text);
                      }

                      //clear the text controller for the new note
                      textController.clear();

                      //close the  box
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Add note",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            openNoteBox();
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStream(),
        builder: (context, snapshot) {
          //if we have data, get all the notes
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //get each individual docs
                DocumentSnapshot document = notesList[index];
                String docId = document.id;

                //get note from each docs
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                //display a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => openNoteBox(docId: docId),
                          icon: const Icon(Icons.settings)),
                      IconButton(
                          onPressed: () {
                            firestoreService.deleteNote(docId);
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No Notes!!!!!");
          }
        },
      ),
    );
  }
}
