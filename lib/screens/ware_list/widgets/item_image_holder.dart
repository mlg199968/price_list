import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/constants/permission_handler.dart';

// ignore: must_be_immutable
class ItemImageHolder extends StatefulWidget {
  const ItemImageHolder({super.key, this.imagePath, required this.onSet});
  final String? imagePath;
  final Function(String? path) onSet;

  @override
  State<ItemImageHolder> createState() => _ItemImageHolderState();
}

class _ItemImageHolderState extends State<ItemImageHolder> {
  bool isLoading = false;

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
          InkWell(
            onTap: () async {
              if (widget.imagePath == null || widget.imagePath == "") {
                try {
                  await storagePermission(context, Allow.storage);
                  isLoading = true;
                  setState(() {});
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    debugPrint("Start resizing");
                    await reSizeImage(pickedFile.files.single.path!);
                    debugPrint("after resizing");
                    isLoading = false;
                    widget.onSet(pickedFile.files.single.path!);
                  }else{
                    isLoading=false;
                    setState(() {});
                  }
                } catch (e) {
                  ErrorHandler.errorManger(context, e,title: "ItemImageHolder widget error");
                }
              }
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                ),
                child: ClipRRect(
                  borderRadius:BorderRadius.circular(20) ,
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: (widget.imagePath == null || widget.imagePath == "")

                        ? const EmptyHolder(text: "افزودن تصویر", icon: Icons.add_photo_alternate_outlined,iconSize:70,fontSize: 13,)
                        : Image(
                      image: FileImage(File(widget.imagePath!)),
                      fit: BoxFit.cover,
                      errorBuilder: (context,error,trace){
                        ErrorHandler.errorManger(context, error,route: trace.toString(),title: "itemImageHolder widget imageDecoration error");
                        return const EmptyHolder(text: "بارگزاری تصویر با مشکل مواجه شده است", icon: Icons.image_not_supported_outlined);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          ///image setting like delete button
          if (widget.imagePath != null && widget.imagePath != "" )
            Row(
              children: [
                //delete button
                IconButton(
                  onPressed: () {
                    File(widget.imagePath!).delete(recursive: true);
                    widget.onSet(null);
                  },
                  icon:const Icon(
                    CupertinoIcons.trash_fill,
                    color: Colors.red,
                    size: 25,
                    shadows: [BoxShadow(blurRadius: 2,offset: Offset(2, 3),color: Colors.black45)],
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     FontAwesomeIcons.pencil,
                //     color: Colors.orange,
                //   ),
                // ),
              ],
            ),
        ],
      );
    }
  }
}
