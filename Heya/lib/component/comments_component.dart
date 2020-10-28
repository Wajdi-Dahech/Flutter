import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/global.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Widget> getComments(BuildContext context, List<CommentModel> comments,
    Function onDeleteComment) {
  List<Widget> commentsWdiget = [];
  if (comments == null) {
    return commentsWdiget;
  }
  DateTime now = DateTime.now();
  for (int i = 0; i < comments.length; i++) {
    CommentModel comment = comments[i];
    if (comment.user != null)
      commentsWdiget.add(
        new Container(
          // height: 45,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                        ),
                        comment.user == null
                            ? CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage(
                                    'lib/assets/default_profile.jpg'),
                              )
                            : CachedNetworkImage(
                                imageUrl: comment.user.picture,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          '${comment.user.firstname}  ${comment.user.lastname}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 5),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(
                          comment.content,
                          style: whiteText,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 0, top: 5),
                        child: Text(
                          formattingDate(comment.createdAt),
                          style: textStyleLigthGrey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              USER_ID == comment.user.id
                  ? IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.times,
                        color: Colors.grey[300],
                        size: 16,
                      ),
                      onPressed: () {
                        onDeleteComment(comment.id);
                      },
                    )
                  : SizedBox()
            ],
          ),
        ),
      );
  }
  return commentsWdiget;
}
