import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:training_two/data/models/post.dart';
import 'package:training_two/links.dart';
import 'package:training_two/ui/components/post_card_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          AnimatedCrossFade(
            firstChild: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
            secondChild: ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                return PostCardWidget(
                  post: posts[index],
                  key: ValueKey(posts[index].id),
                );
              },
            ),
            duration: Duration(milliseconds: 500),
            crossFadeState: isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
          // if (isLoading) LinearProgressIndicator(),
          // if (!isLoading)
          //   ListView.builder(
          //     itemCount: posts.length,
          //     shrinkWrap: true,
          //     primary: false,
          //     itemBuilder: (BuildContext context, int index) {
          //       return PostCardWidget(
          //         post: posts[index],
          //       );
          //     },
          //   )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchFromApi();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future fetchFromApi() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await get(postsLink);
      await Future.delayed(Duration(milliseconds: 1000));

      // print(response.body);
      var responseJson = jsonDecode(response.body);

      // var firstPost = responseJson[0];
      // print(firstPost.runtimeType);
      // print(firstPost["title"]);
      //
      // setState(() {
      //   posts.add(Post(firstPost['id'].toString(), firstPost["userId"].toString(),
      //       firstPost["title"], firstPost["body"]));
      // });

      // posts = [];
      // (responseJson as List).forEach((element) {
      //   var post = Post(element["id"].toString(), element["userId"].toString(),
      //       element["title"], element["body"]);
      //
      //   setState(() {
      //     posts.add(post);
      //   });
      // });

      posts = (responseJson as List).map((element) {
        Post postFactoried = Post.fromJson(element);
        // var post = Post(element["id"].toString(), element["userId"].toString(),
        //     element["title"], element["body"]);
        return postFactoried;
      }).toList();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          );
        },
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
