import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterapp/config/global_variables.dart';

class FireBaseService {
  FirebaseStorage storage;
  FirebaseApp app;

  FireBaseService() {}

  init() async {
    app = await FirebaseApp.configure(
      name: 'test',
      options: FirebaseOptions(
        googleAppID: (Platform.isIOS || Platform.isMacOS)
            ? '1:884874123729:android:ed38fcc49b68b193ffe8f0'
            : '1:884874123729:android:ed38fcc49b68b193ffe8f0',
        apiKey: 'AIzaSyDcB0HFJCdssH1wJXk3OkkQ-K_WbQO9JPA',
        projectID: 'heyya-edbfb',
      ),
    );
    storage = FirebaseStorage(app: app, storageBucket: FIRESTORAGE);
  }

  FirebaseStorage getStorage() {
    if (storage == null) {
      storage = FirebaseStorage(app: app, storageBucket: FIRESTORAGE);
      return storage;
    } else {
      return storage;
    }
  }

  updateFireBaseUser(int userID) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: userID)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance.collection('users').document("${userID}").setData({
        'nickname': USER_NAME,
        'photoUrl': AVATAR_IMG,
        'id': userID,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      });
    } else {
      if (documents[0].data['nickname'] != USER_NAME ||
          (AVATAR_IMG != null && documents[0].data['photoUrl'] != AVATAR_IMG)) {
        Firestore.instance
            .collection('users')
            .document("${userID}")
            .updateData({
          'nickname': USER_NAME,
          'photoUrl': AVATAR_IMG,
        });
      } else {
        print('no change');
      }
    }
  }
}
