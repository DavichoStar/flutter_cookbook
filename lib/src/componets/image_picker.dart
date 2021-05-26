import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(PickedFile imageFile);

class ImagePickerWidget extends StatelessWidget {
  final PickedFile imageFile;
  final OnImageSelected onImageSelected;
  final ImagePicker _picker = ImagePicker();

  ImagePickerWidget({@required this.imageFile, @required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      height: mediaQuery.size.height * 0.30,
      padding: EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.cyan[300], Colors.cyan[800]]),
        image: imageFile != null
            ? DecorationImage(
                image: FileImage(File(imageFile.path)), fit: BoxFit.cover)
            : null,
      ),
      child: IconButton(
        icon: Icon(Icons.camera_alt),
        onPressed: () => _showPickerOptions(context),
        iconSize: mediaQuery.size.height * 0.1,
        color: Colors.white,
      ),
    );
  }

  _showPickerOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _showPickerImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image_outlined),
              title: Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _showPickerImage(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPickerImage(
      BuildContext context, ImageSource camera) async {
    var image = await _picker.getImage(source: camera);
    this.onImageSelected(image);
  }
}
