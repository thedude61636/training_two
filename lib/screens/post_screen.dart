import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:training_two/data/models/post.dart';
import 'package:training_two/links.dart';
import 'package:training_two/data/models/user.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({Key key, @required this.post}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int counter = 0;

  Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.post.body),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.thumb_down,
                    color: Colors.red,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                )
              ],
            ),
            FutureBuilder<User>(
              future: _userFuture,
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                //
                // if (snapshot.hasError) {
                //   return Card(
                //     child: Column(
                //       children: [
                //         Text(
                //           "Error",
                //           style: Theme.of(context).textTheme.headline3,
                //         ),
                //         Text(snapshot.error.toString())
                //       ],
                //     ),
                //   );
                // }
                // var user = snapshot.data;
                // return Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: [
                //         Text(
                //           user.name,
                //           style: Theme.of(context).textTheme.headline4,
                //         ),
                //         Text(
                //           user.email,
                //         ),
                //       ],
                //     ),
                //   ),
                // );

                return AsyncSnapshotBuilder<User>(
                  snapshot: snapshot,
                  function: (log) {
                    print(log + " something something");
                  },
                  onData: (context, user) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            FlatButton(
                              child: Text(
                                user.email,
                                style: TextStyle(letterSpacing: 4),
                              ),
                              onPressed: () {
                                launcher.launch(
                                    "mailto:${user.email}?subject=News&body=New%20plugin");
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Text("counter $counter"),
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  counter++;
                });

                if (counter > 25) {
                  _userFuture = fetchUser();
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        onPressed: () {
          // Navigator.of(context).pop();
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<User> fetchUser() async {
    await Future.delayed(Duration(seconds: 2));
    var link = usersLink + "/${widget.post.userId}";
    var response = await get(link);
    var user = User.fromRawJson(response.body);

    return user;
  }
}

typedef Widget ValueBuilder<T>(BuildContext context, T value);
typedef void Logger(String log);

class AsyncSnapshotBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;

  final ValueBuilder<T> onData;
  final Logger function;

  const AsyncSnapshotBuilder(
      {Key key, this.snapshot, this.onData, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      function("ERROR");

      return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Column(
        children: [
          Text(
            "Error",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(snapshot.error)
        ],
      );
    }
    return onData.call(context, snapshot.data);
    return Container();
  }
}
