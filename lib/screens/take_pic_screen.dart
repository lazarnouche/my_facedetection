
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:provider/provider.dart';
import '../models/picture.dart';
import '../providers/pictures.dart';
import './view_images.dart';

class TakePicScreen extends StatefulWidget {
  static const routeName = '/take-pic';

  @override
  _TakePicScreenState createState() => _TakePicScreenState();
}

class _TakePicScreenState extends State<TakePicScreen> {
  File _laurent;
  var _imageFileDecode;
  Future<void> _takePicture() async {
    try
    {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      print('no image');
      return;
    }


    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');
    final dd = await imageFile.readAsBytes();
    final imageFileDecode = await decodeImageFromList(dd);


    setState(() {
      _laurent = File(imageFile.path);
      _imageFileDecode = imageFileDecode;

    });


    print(_imageFileDecode);

    var _imageToStore = Picture(picName: savedImage);
    _storeImage() {
      Provider.of<Pictures>(context, listen: false).storeImage(_imageToStore);
    }

    _storeImage();
    // Navigator.pushNamed(context,ViewImages.routeName);
    }catch(e){
      print(e);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton.icon(
          icon: Icon(
            Icons.add,
            size: 100,
          ),
          label: Text(''),
          textColor: Theme.of(context).primaryColor,
          onPressed: _takePicture,
        ),
      ),
    );
  }
}