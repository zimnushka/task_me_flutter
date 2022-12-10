import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AuthPoster extends StatefulWidget {
  const AuthPoster();

  @override
  State<AuthPoster> createState() => AuthPosterState();
}

class AuthPosterState extends State<AuthPoster> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: rootBundle.loadString('README.md'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.data!,
              );
            }

            return Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(color: Theme.of(context).primaryColor),
            );
          }),
    );
  }
}
