import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
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
  List<Post> postsList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postsList.clear();
    _reference = _database.reference().child(nodeNamePost);
    _referenceUser = _database.reference().child(nodeNameUser);
    _reference.onChildAdded.listen(_childAdded);
    _reference.onChildRemoved.listen(_childRemoves);
    _reference.onChildChanged.listen(_childChanged);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostViewWidget();
  }

  Widget _buildPostViewWidget() {
    return Column(
      children: <Widget>[
        Flexible(
          child: postsList.isNotEmpty ? FirebaseAnimatedList(
              query: _reference,
              itemBuilder: (_, DataSnapshot snap, Animation<double> animation,
                  int index) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: CardViewPost(
                    post: postsList[(postsList.length - 1) - index],
                    index: index,
                  ),
                );
              }) : Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }

  _childAdded(Event event) {
    _referenceUser
        .child(event.snapshot.value['UserId'])
        .once()
        .then((snapshot) {
      setState(() {
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


    _referenceUser
          .child(event.snapshot.value['UserId'])
          .once()
          .then((snapshot) {
        print(snapshot.value);
        setState(() {
          Post post = Post.fromSnapshotJson(event.snapshot);
          post.user = User.fromSnapshotJson(snapshot);
          postsList[postsList.indexOf(changedPost)] = post;
        });

      });
  }
}
