import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/constants/permission_handler.dart';
import 'package:price_list/screens/photo_screen/photo_view_screen.dart';

class ItemImageHolder extends StatefulWidget {
  const ItemImageHolder(
      {super.key, this.imagePath, required this.onSet, this.otherImages});
  final String? imagePath;
  final Function(String? path) onSet;
  final List<String>? otherImages;

  @override
  State<ItemImageHolder> createState() => _ItemImageHolderState();
}

class _ItemImageHolderState extends State<ItemImageHolder> {
  bool isLoading = false;
  chooseImageFunction({ImageSource imageSource = ImageSource.gallery}) async {
    if (widget.imagePath == null || widget.imagePath == "") {
      try {
        await storagePermission(context, Allow.storage);
        isLoading = true;
        setState(() {});
        String? path;
        FilePickerResult? pickedFile;

        ///if platform is android or ios use image picker package else use file
        if (Platform.isAndroid || Platform.isIOS) {
          final ImagePicker picker = ImagePicker();
          final XFile? photo = await picker.pickImage(source: imageSource);
          path = photo?.path;
        } else {
          pickedFile = await FilePicker.platform.pickFiles();
          path = pickedFile?.files.single.path;
        }
        if (path != null) {
          debugPrint("Start resizing");
          await reSizeImage(path);
          debugPrint("after resizing");
          isLoading = false;
          widget.onSet(path);
        } else {
          isLoading = false;
          setState(() {});
        }
      } catch (e) {
        ErrorHandler.errorManger(context, e,
            title: "ItemImageHolder widget error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ///condition for,if is image processing show circle indicator
    if (isLoading) {
      ///circle indicator part
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: kMainColor,
            semanticsLabel: "در حال پردازش تصویر",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "در حال پردازش تصویر",
            style: TextStyle(color: Colors.black38),
          ),
        ],
      );

      ///main Show image part
    } else {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black26),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: (widget.imagePath == null || widget.imagePath == "")
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CText(
                            "افزودن تصویر",
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              EmptyHolder(
                                height: null,
                                text: "فایل ها",
                                icon: FontAwesomeIcons.images,
                                iconSize: 50,
                                fontSize: 11,
                                onTap: () async {
                                  await chooseImageFunction();
                                },
                              ),
                              if (Platform.isIOS || Platform.isAndroid)
                                EmptyHolder(
                                  height: null,
                                  text: "دوربین",
                                  icon: FontAwesomeIcons.cameraRetro,
                                  iconSize: 50,
                                  fontSize: 11,
                                  onTap: () async {
                                    await chooseImageFunction(
                                        imageSource: ImageSource.camera);
                                  },
                                ),
                            ],
                          ),
                        ],
                      )
                    : Image(
                        image: FileImage(File(widget.imagePath!)),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, trace) {
                          ErrorHandler.errorManger(context, error,
                              route: trace.toString(),
                              title:
                                  "itemImageHolder widget imageDecoration error");
                          return const EmptyHolder(
                              text: "بارگزاری تصویر با مشکل مواجه شده است",
                              icon: Icons.image_not_supported_outlined);
                        },
                      ),
              ),
            ),
          ),

          ///image setting like delete button
          if (widget.imagePath != null && widget.imagePath != "")
            Row(
              children: [
                ///delete button
                IconButton(
                  onPressed: () {
                    File(widget.imagePath!).delete(recursive: true);
                    widget.onSet(null);
                  },
                  icon: const Icon(
                    CupertinoIcons.trash_fill,
                    color: Colors.red,
                    size: 25,
                    shadows: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(2, 3),
                          color: Colors.black45)
                    ],
                  ),
                ),

                ///See pic button
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PhotoViewScreen.id,
                        arguments: widget.imagePath);
                  },
                  icon: const Icon(
                    CupertinoIcons.eye,
                    color: Colors.orangeAccent,
                    size: 25,
                    shadows: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(2, 3),
                          color: Colors.black45)
                    ],
                  ),
                ),
              ],
            ),
        ],
      );
    }
  }
}
