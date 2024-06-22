import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  //create: add a new note
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //read: get notes from the database
  Stream<QuerySnapshot> getNoteStream() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }

  //update: update notes given a doc id
  Future<void> updateNote(String docId, String newNote) {
    return notes
        .doc(docId)
        .update({'note': newNote, 'timestamp': Timestamp.now()});
  }

  //delete: delete notes given a doc id
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
