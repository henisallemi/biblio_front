import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent extends StatefulWidget {
  const ImagePickerComponent(
      {Key? key, required TextEditingController controller})
      : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  State<ImagePickerComponent> createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  File? _image;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _image = File(image?.path ?? "");
          if (_image != null) {
            widget._controller.text = _image!
                .path; // Update the TextEditingController with the selected image path
          }
        });
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[200],
          border: Border.all(
            color: Colors.green,
            width: 2.0,
          ),
        ),
        child: _image != null
            ? ClipOval(
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
                size: 70,
              ),
      ),
    );
  }
}
