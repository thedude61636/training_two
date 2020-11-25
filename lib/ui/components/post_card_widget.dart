import 'package:flutter/material.dart';
import "package:training_two/data/models/post.dart";
import 'package:training_two/screens/post_screen.dart';

class PostCardWidget extends StatefulWidget {
  final Post post;

  const PostCardWidget({Key key, @required this.post}) : super(key: key);

  @override
  _PostCardWidgetState createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool liked;

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    if (liked == null) {
      cardColor = Colors.white;
    } else if (liked) {
      cardColor = Colors.blue;
    } else {
      cardColor = Colors.red;
    }

    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 8,
      child: InkWell(
        onTap: () async {
          // Navigator.push(context, route)
          var liked = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return PostScreen(
              post: widget.post,
            );
          }));
          setState(() {
            this.liked = liked;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.post?.title ?? "No title",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.black),
              ),
              Text(widget.post?.body ?? "No body"),
            ],
          ),
        ),
      ),
    );
  }
}
