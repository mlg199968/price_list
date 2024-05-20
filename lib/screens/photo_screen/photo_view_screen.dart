

import 'package:flutter/material.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({super.key, required this.imagePath});
 final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
        // child: PhotoView(
        //   imageProvider: AssetImage("assets/large-image.jpg"),
        // )
    );
  }
}
