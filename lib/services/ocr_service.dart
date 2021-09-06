import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_service_app/services/TextRecognition.dart';

class OCR_Service extends StatefulWidget {
  @override
  _OCR_ServiceState createState() => _OCR_ServiceState();
}

class _OCR_ServiceState extends State<OCR_Service> {
  bool _scanning = false;
  String _extractText = '';
  PickedFile _pickedImage;
  dynamic imageResult;
  final _picker = ImagePicker();

  void _imgFromCamera(BuildContext context) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    TextRecognition textRecognition = new TextRecognition(
        language: "eng+vie", imageInput: image, optionImageProcessing: 'grayscale');
    await textRecognition.ImageProcessing();
    await textRecognition.extractText();
    print('fish extracted');
    setState(() {
      _pickedImage = image;
      imageResult = textRecognition.preProcessing;
      _extractText = textRecognition.textResult;
      _scanning = false;
    });
    Navigator.of(context).pop();
  }

  void _imgFromGallery(BuildContext context) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    TextRecognition textRecognition = new TextRecognition(
        language: "eng", imageInput: image, optionImageProcessing: 'grayscale');
    await textRecognition.ImageProcessing();
    await textRecognition.extractText();
    print('fish extracted');
    setState(() {
      _pickedImage = image;
      imageResult = textRecognition.preProcessing;
      _extractText = textRecognition.textResult;
      _scanning = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              // title: Text("where do you want to take the photo?"),
              content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new ListTile(
                    leading:
                        new Icon(Icons.photo_library, color: Colors.blue[200]),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery(context);
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                    child: new ListTile(
                  leading:
                      new Icon(Icons.photo_camera, color: Colors.blue[200]),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera(context);
                  },
                ))
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Text Recognition'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 100),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                          image: MemoryImage(imageResult),
                          // https://stackoverflow.com/questions/49835623/how-to-load-images-with-image-file
                          // image: AssetImage(imageResult),
                          fit: BoxFit.fill)),
                ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FlatButton(
              color: Colors.green,
              child: Text(
                'Choose a image for extract text',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _showSelectionDialog(context);
                print(_scanning);
                setState(() {
                  _scanning = true;
                });
                // _showPicker(context);
                // print(_pickedImage.path);
              },
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
                  Icons.done,
                  size: 40,
                  color: Colors.green,
                ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
