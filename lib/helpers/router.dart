import 'package:flutter/material.dart';
import 'package:haumea/models/post.dart';
import 'package:haumea/screens/detail.dart';

class DeepRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var slug = settings.name;

    print("generateRoute $settings");

    return MaterialPageRoute(builder: (context) {
      // return AlertDialog(
      //   title: Text('AlertDialog Title'),
      //   content: SingleChildScrollView(
      //     child: ListBody(
      //       children: <Widget>[
      //         Text(settings.toString()),
      //         Text('Would you like to approve of this message?'),
      //       ],
      //     ),
      //   ),
      //   actions: <Widget>[
      //     TextButton(
      //       child: Text('Approve'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // );

      return FutureBuilder(
        future: PostModel.getFromSlug(slug),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return DetailPage(post: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }
}
