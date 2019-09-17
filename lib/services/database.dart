import 'dart:io';
import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseDatabase {
  Future createUsers({File profilePicture, User user});

  Future createPost({
    Post post,
  });

  Future<DataSnapshot> getUser(String uid);

  Stream<QuerySnapshot> getPost();

  Stream<DocumentSnapshot> getUserOfPost(String userId);

  Future<List<String>> uploadPostPicture({List<File> picturesList});
}

class Database implements BaseDatabase {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Future<List<String>> uploadPostPicture({List<File> picturesList}) async {
    List<String> pathPicturesURL = List<String>();
    for (File picture in picturesList) {
      DateTime dateTime = DateTime.now();
      var pathPostPictures =
          'PostPictures/post${dateTime.hour}${dateTime.minute}${dateTime.second}${dateTime.millisecond}' +
              '.jpg';
      StorageReference reference =
          FirebaseStorage.instance.ref().child(pathPostPictures);
      final task = reference.putFile(picture);
      final taskSnapshot = await task.onComplete;
      String pathPicture = await taskSnapshot.ref.getDownloadURL();
      pathPicturesURL.add(pathPicture);
      print(pathPicture);
    }
    return pathPicturesURL;
  }

  Future<DataSnapshot> getUser(String uid) {
    return databaseReference.child("Users").child(uid).once();
  }

  @override
  Future createPost({Post post}) async {
    return Firestore.instance
        .collection("Post")
        .document()
        .setData(post.toJson());
  }

  @override
  Future createUsers({File profilePicture, User user}) async {
    var pathProfilePicture = 'UsersProfilePicture/${user.userUid}' + '.jpg';
    StorageReference reference =
    FirebaseStorage.instance.ref().child(pathProfilePicture);
    var task = reference.putFile(profilePicture);
    final taskSnapshot = await task.onComplete;
    String pathPicture = await taskSnapshot.ref.getDownloadURL();
    user.profilePicture = pathPicture;
    return Firestore.instance
        .collection("User")
        .document("${user.userUid}")
        .setData(user.toJson());
  }

  @override
  Stream<QuerySnapshot> getPost() {
    // TODO: implement getPost
    return Firestore.instance
        .collection('Post')
        .orderBy("DateTime", descending: true)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot> getUserOfPost(String userId) {
    // TODO: implement getUserOfPost
    return Firestore.instance
        .collection('User')
        .document(userId)
        .get().asStream();
  }
}
