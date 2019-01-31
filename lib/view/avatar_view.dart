import 'package:flutter/material.dart';

class AvatarView extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  AvatarView({this.avatarUrl, this.userName});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.only(right: 10),
          child: Image.network(avatarUrl),
        ),
        Text(userName)
      ],
    );
  }
}
