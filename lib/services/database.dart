import 'dart:io';

import 'package:avid/model/Post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseDatabase {
  Future<void> createUsers(
      {File profilePicture,
      String userUid,
      String username,
      String fullName,
      String yourCity,
      String yourState,
      String email});

  Future createPost({
    Post post,
  });

  Future<List<String>> uploadPostPicture({List<File> picturesList});
}

class Database implements BaseDatabase {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Future<void> createUsers(
      {File profilePicture,
      String userUid,
      String username,
      String fullName,
      String yourCity,
      String yourState,
      String email}) async {
    if (profilePicture != null) {
      var pathProfilePicture = 'UsersProfilePicture/$userUid' + '.jpg';
      StorageReference reference =
          FirebaseStorage.instance.ref().child(pathProfilePicture);
      reference.putFile(profilePicture);
      //TODO check for image upload or not Using #task
      var nameOfPicture =
          profilePicture == null ? 'default.png' : userUid + '.jpg';
      var fullPathProfilePicture =
          'https://firebasestorage.googleapis.com/v0/b/avid-d7792.appspot.com/o/UsersProfilePicture%2F$nameOfPicture?alt=media';
      return databaseReference.child("Users").child("$userUid").set({
        'Username': '$username',
        'FullName': '$fullName',
        'YourLocation': {'City': '$yourCity', 'State': '$yourState'},
        'eamil': '$email',
        'profilePiture': '$fullPathProfilePicture'
      });
    }
  }

  @override
  createPost({Post post, List<File> picturesList}) async {
    return databaseReference.child("Post").push().set(post.toJson());
  }

  @override
  Future<List<String>> uploadPostPicture({List<File> picturesList}) async {
    List<String> pathPicturesURL = List<String>();
    for (File picture in picturesList) {
      DateTime dateTime = DateTime.now();
      var pathPostPictures =
          'PostPictures/post${dateTime.hour}${dateTime.minute}${dateTime.second}${dateTime.millisecond}' +
              '.jpg';
      print("${dateTime.day}/${dateTime.month}/${dateTime.year}");
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
}
