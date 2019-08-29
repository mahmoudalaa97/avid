import 'package:flutter/material.dart';

class CardCreatePost extends StatelessWidget {
  final VoidCallback onClick;
  final String title;
  final Widget content;
  final bool error;
  final String errorMessage;

  CardCreatePost(
      {@required this.onClick, this.title="", this.content, this.error = false ,this.errorMessage=""});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$title",
                      style: TextStyle(color: Color(0xff24253D)),
                    )),
                error
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {},
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          alignment: Alignment.topRight,
                          icon: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.all(0),
                          tooltip: "$errorMessage",
                        ))
                    : Container(),
              ],
            ),
            content != null ? content : Container()
          ],
        ),
      ),
    );
  }
}
