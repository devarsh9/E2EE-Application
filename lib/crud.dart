import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else
      return false;
  }

  Future<void> addData(chatData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('testcrud').add(chatData).catchError((e) {
        print(e);
      });
    } else
      print('you need to be logged in');
  }

  getChat() async {
    return await Firestore.instance.collection('Users').snapshots();
  }

  getPolls()async{
    return await Firestore.instance.collection('Polls').snapshots();
  }
  updateData(selectedDoc,) {
    Firestore.instance
        .collection('testcrud')
        .document(selectedDoc)
        .updateData({'unRead':"1"})
        .catchError((e) {
      print(e);
    });
  }
}
