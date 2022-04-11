import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_alert_dialog.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker({required this.imagePickFn});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File file = File('-1');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: file.path != '-1' ? FileImage(file) : null,
        ),
        TextButton.icon(
          onPressed: _selectImage,
          icon: const Icon(Icons.image),
          label: const Text(
            'Add Image',
          ),
        ),
      ],
    );
  }

  void _selectImage() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          selectImageFromGallery: selectImageFromGallery,
          selectImageFromCamera: selectImageFromCamera,
        );
      },
    );
  }

  void selectImageFromGallery() async {
    print('gallery');
    bool status = await selectImageFunction(ImageSource.gallery);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  void selectImageFromCamera() async {
    bool status = await selectImageFunction(ImageSource.camera);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  Future<bool> selectImageFunction(ImageSource source) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final XFile pickedImage =
          await imagePicker.pickImage(source: source) ?? XFile('-1');
      print('---------------------------------------');
      print(pickedImage);
      print(pickedImage.path);
      print(pickedImage.name);
      if (pickedImage.path == '-1') {
        return false;
      }
      setState(() {
        file = File(pickedImage.path);
      });
      widget.imagePickFn(file);
      return true;
    } //
    catch (e) {
      print(e);
      return false;
    }
  }
}
