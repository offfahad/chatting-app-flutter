import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Image Source',
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
              child: Text(
                'Camera',
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final pickedImage = await ImagePicker().getImage(
        source: source,
        imageQuality: 50,
        maxWidth: 150,
      );
      if (pickedImage != null && pickedImage.path != null) {
        setState(() {
          _pickedImage = File(pickedImage.path);
        });
      }
    }
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
