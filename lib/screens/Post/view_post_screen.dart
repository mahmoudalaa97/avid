import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:avid/services/auth.dart';
import 'package:avid/services/database.dart';
import 'package:avid/utils/card_view_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ViewPostScreen extends StatefulWidget {
  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}


class _ViewPostScreenState extends State<ViewPostScreen> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _reference;
  DatabaseReference _referenceUser;
  String nodeNamePost = "Post";
  String nodeNameUser = "Users";
  List<Post> postsList = <Post>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reference = _database.reference().child(nodeNamePost);
    _referenceUser = _database.reference().child(nodeNameUser);
    _reference.onChildAdded.listen(_childAdded);
//    _referenceUser.onChildAdded.listen(_childAdded);
    _reference.onChildRemoved.listen(_childRemoves);
//    _referenceUser.onChildRemoved.listen(_childRemoves);
//    _referenceUser.onChildChanged.listen(_childChanged);
    _reference.onChildChanged.listen(_childChanged);
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostViewWidget();
  }

  Widget _buildPostViewWidget() {
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
              query: _reference,
              defaultChild: Center(
                child: CircularProgressIndicator(),
              ),
              itemBuilder: (_, DataSnapshot snap, Animation<double> animation,
                  int index) {
                if (postsList.isNotEmpty) {
                  return CardViewPost(
                    post: postsList[index],
                    index: index,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
  }

  _childAdded(Event event) {
    print(event.snapshot.value);
    setState(() {
      _referenceUser
          .child(event.snapshot.value['UserId'])
          .once()
          .then((snapshot) {
        print(snapshot.value);
        Post post = Post.fromSnapshotJson(event.snapshot);
        post.user = User.fromSnapshotJson(snapshot);
        postsList.add(post);
      });
    });
  }

  void _childRemoves(Event event) {
    var deletedPost = postsList.singleWhere((post) {
      return post.key == event.snapshot.key;
    });

    setState(() {
      postsList.removeAt(postsList.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    print(event.snapshot.value);
    var changedPost = postsList.singleWhere((post) {
      return post.key == event.snapshot.key;
    });

    setState(() {
      _referenceUser
          .child(event.snapshot.value['UserId'])
          .once()
          .then((snapshot) {
        print(snapshot.value);
        Post post = Post.fromSnapshotJson(event.snapshot);
        post.user = User.fromSnapshotJson(snapshot);
        postsList[postsList.indexOf(changedPost)] = post;
      });
    });
  }
}
