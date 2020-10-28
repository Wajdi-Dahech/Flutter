import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/component/shared_components.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/pages/primary.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_firebase.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File _image;
  final picker = ImagePicker();
  final textController = TextEditingController();
  StorageUploadTask uploadTask;
  FireBaseService fireBaseService;
  PostServiceImp postServiceImp;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  Future getGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  Future cropImage() async {
    File cropped = await ImageCropper.cropImage(sourcePath: _image.path);
    setState(() {
      _image = cropped ?? _image;
    });
  }

  onCreatePost() async {
    showSimpleCustomDialog(context);
    var response = await this.postServiceImp.registerPost("content", []);
    print(response.body);
  }

  void showSimpleCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Simpe Custom Modal Dialog....',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Okay',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel!',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  @override
  void initState() {
    super.initState();
    fireBaseService = getIt<FireBaseService>();
    postServiceImp = getIt<PostServiceImp>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Create Post",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              FlatButton(
                onPressed: onCreatePost,
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black87,
                    ),
                    child: FlatButton(
                      onPressed: () {
                        getImage();
                      },
                      child: FaIcon(FontAwesomeIcons.camera, size: 18),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black87,
                    ),
                    child: FlatButton(
                      onPressed: () {
                        getGallery();
                      },
                      child: FaIcon(FontAwesomeIcons.photoVideo, size: 18),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  getUploader()
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: CachedNetworkImage(
                      imageUrl: AVATAR_IMG,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
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
                          Image.asset('lib/assets/default_profile.jpg'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    USER_NAME,
                    style: textStyleBold,
                  )
                ],
              ),
              TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: false,
                decoration: InputDecoration(hintText: '  Write your comment'),
              ),
              SizedBox(height: 20),
              getImagePreview(),
            ],
          ),
        ));
  }

  getUploader() {
    if (uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progress =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Row(
            children: <Widget>[
              Stack(
                alignment: Alignment(0, 0),
                children: <Widget>[
                  CircularProgressIndicator(
                    value: progress,
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  )
                ],
              ),
              SizedBox(width: 10),
              if (uploadTask.isComplete) Text('Completed !!'),
              if (!uploadTask.isComplete) Text('Uploading ....')
            ],
          );
        },
      );
    } else {
      return FlatButton.icon(
        onPressed: startUpload,
        icon: Icon(Icons.cloud_upload),
        label: Text('Post'),
      );
    }
  }

  void startUpload() async {
    if (textController.text.trim().length == 0) {
      showToast("You have to Fill Description");
      return;
    }
    if (_image == null) {
      showToast("You have to add media");
      return;
    }
    String filePath = "images/${DateTime.now()}.png";
    setState(() {
      uploadTask =
          fireBaseService.getStorage().ref().child(filePath).putFile(_image);
    });
    var dowurl = await uploadTask.onComplete;
    var ref = await dowurl.ref.getDownloadURL();
    var url = ref.toString();
    completeDownlad(url);
  }

  void completeDownlad(String url) async {
    String content = textController.text.trim();
    List<String> medias = List();
    medias.add(url);
    var response = await this.postServiceImp.registerPost(content, medias);
    if (response != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    }
  }

  Widget getImagePreview() {
    if (_image == null) {
      return Center(child: Text('No image selected.'));
    }

    return Center(
      child: Stack(
        children: <Widget>[
          Image.file(_image),
          Positioned(
            top: 5,
            right: 10,
            child: Container(
              width: 50,
              child: FlatButton(
                onPressed: () {
                  cropImage();
                },
                child: FaIcon(FontAwesomeIcons.cropAlt, size: 18),
                textColor: Colors.white,
                color: Color.fromRGBO(20, 20, 20, 0.85),
              ),
            ),
          )
        ],
      ),
    );
  }
}
