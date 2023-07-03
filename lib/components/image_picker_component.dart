import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent extends StatefulWidget {
  String? imagePath;
  final TextEditingController _controller;
  ImagePickerComponent(
      {Key? key, required TextEditingController controller, this.imagePath})
      : _controller = controller,
        super(key: key);

  @override
  State<ImagePickerComponent> createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  File? _image;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    print("ImagePath is : ${widget.imagePath ?? 'no'}");
    return GestureDetector(
      onTap: () async {
        XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _image = image != null ? File(image.path) : null;
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
        child: _image != null || widget.imagePath != null
            ? ClipOval(
                child: _image != null
                    ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "http://localhost:4000/${widget.imagePath!.isNotEmpty ? widget.imagePath : 'uploads/avatar.jpg'}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                        return Image.asset("images/avatar.jpg");
                      }),
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
