

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  static const String id="/photo-view-screen";
  const PhotoViewScreen({super.key, required this.imagePath});
 final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: PhotoView(
            imageProvider:FileImage(File(imagePath)),
          )
      ),
    );
  }
}
