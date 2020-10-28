import 'package:flutter/material.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutterapp/pages/profile_public.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterapp/config/custom_extensions.dart';

Widget userWidget(BuildContext context, UserModel userModel) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PublicProfilePage(userModel)));
    },
    child: Container(
      height: 85,
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(offset: Offset(0.2, 0.2), blurRadius: 0.2)],
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10),
            child: CachedNetworkImage(
              imageUrl: userModel.picture,
              imageBuilder: (context, imageProvider) => Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => AspectRatio(
                aspectRatio: 0.8,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Image.asset('lib/assets/notfound.png'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userModel.username.capitalize(),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 5),
                      Text('${userModel.state}, ${userModel.city}')
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      children: getStars(
                          userModel.rating.toDouble(), 15, Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

List<Widget> getStars(dynamic rate, double size, Color bg) {
  List<Widget> stars = List();
  int i = 1;
  for (i; i <= rate; i++) {
    stars.add(FaIcon(
      FontAwesomeIcons.solidStar,
      size: size,
      color: Colors.amber,
    ));
  }
  if (i - rate < 0.5) {
    stars.add(FaIcon(
      FontAwesomeIcons.starHalfAlt,
      size: size,
      color: Colors.amber,
    ));
    i++;
  }
  for (i; i <= 5; i++) {
    stars.add(FaIcon(
      FontAwesomeIcons.star,
      size: size,
      color: bg,
    ));
  }
  return stars;
}
