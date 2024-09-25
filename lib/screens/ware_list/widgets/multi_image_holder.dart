import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/constants/permission_handler.dart';
import 'package:price_list/screens/photo_screen/photo_view_screen.dart';

class MultiImageHolder extends StatefulWidget {
  const MultiImageHolder(
      {super.key,
      this.imagePath,
      required this.onSet,
      this.otherImages = const []});

  final String? imagePath;
  final Function(String? path, List<String> pathes) onSet;
  final List<String>? otherImages;

  @override
  State<MultiImageHolder> createState() => _ItemImageHolderState();
}

class _ItemImageHolderState extends State<MultiImageHolder> {
  bool isLoading = false;

  chooseImageFunction({ImageSource imageSource = ImageSource.gallery}) async {
    if ((widget.otherImages?.length ?? 0) < 4) {
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
          print(path);
          widget.onSet(path, [...widget.otherImages ?? [], path]);
        } else {
          isLoading = false;
          setState(() {});
        }
      } catch (e, stacktrace) {
        isLoading = false;
        setState(() {});
        ErrorHandler.errorManger(context, e,
            stacktrace: stacktrace, title: "MultiImageHolder widget error");
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
          Gap(
            10,
          ),
          CText(
            "در حال پردازش تصویر",
            color: Colors.black38,
          ),
        ],
      );

      ///main Show image part
    } else {
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              ///top image with options
              Expanded(
                flex: 4,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    ///main pic
                    Expanded(
                      child: ImageFrame(
                        path: widget.imagePath,
                        emptyHolder: Column(
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
                        ),
                      ),
                    ),
                    ///image setting like delete button
                      Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54)),
                        child: BlurryContainer(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            textDirection: TextDirection.rtl,
                            children: [
                              ///camera button
                              if(Platform.isAndroid || Platform.isIOS)
                              ActionButton(
                                label: "دوربین",
                                bgColor: Colors.black12,
                                borderColor: Colors.blueAccent[100],
                                icon: Icons.add_a_photo_outlined,
                                iconColor: Colors.blueAccent[100],
                                borderRadius: 5,
                                onPress: () async {
                                  await chooseImageFunction(
                                      imageSource: ImageSource.camera);
                                },
                              ),
                              ///file button
                              ActionButton(
                                label: "فایل ها",
                                bgColor: Colors.black12,
                                borderColor: Colors.green,
                                icon: Icons.add_photo_alternate_outlined,
                                iconColor: Colors.green,
                                borderRadius: 5,
                                onPress: () async {
                                  await chooseImageFunction();
                                },
                              ),
                              Expanded(child: SizedBox()),
                              ///delete button
                              ActionButton(
                                label: "حذف",
                                icon:CupertinoIcons.trash_fill,
                                height: 20,
                                iconColor: Colors.red,
                                iconSize: 15,
                                bgColor: Colors.black12,
                                borderColor: Colors.red,
                                borderRadius: 5,
                                labelStyle: TextStyle(fontSize: 10,color: Colors.white),
                                onPress: () {
                                  File(widget.imagePath!).delete(recursive: true);
                                  widget.otherImages!.remove(widget.imagePath!);
                                  String? firstImage=(widget.otherImages?.length ?? 0)!=0?widget.otherImages?.first:null;
                                  widget.onSet(firstImage, widget.otherImages!);
                                },



                              ),

                              ///See pic button
                              ActionButton(
                                label: "نمایش",
                                icon: CupertinoIcons.eye,
                                  iconColor: Colors.orangeAccent,
                                height: 20,
                                iconSize: 15,
                                bgColor: Colors.black12,
                                borderColor: Colors.orangeAccent,
                                borderRadius: 5,
                                labelStyle: TextStyle(fontSize: 10,color: Colors.white),
                                onPress: () {
                                  Navigator.pushNamed(context, PhotoViewScreen.id,
                                      arguments: widget.imagePath);
                                },

                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ///bottom images list
              Flexible(
                child: SizedBox(
                  height:80,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        4,
                        (index) {
                          String? path=(widget.otherImages?.length ?? 0) > index ?widget.otherImages![index]:null;
                            return  ImageFrame(
                              selected: widget.imagePath == path,
                              path: path,
                              onTap: () {
                                if (path!=null)
                                  widget.onSet(widget.otherImages![index],
                                      widget.otherImages!);
                              },
                            );
                            }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class ImageFrame extends StatelessWidget {
  const ImageFrame(
      {super.key,
      this.path,
      this.onTap,
      this.emptyHolder,
      this.selected = false,
      this.borderRadius = 10});
  final String? path;
  final VoidCallback? onTap;
  final Widget? emptyHolder;
  final bool selected;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1/1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: selected ? kMainColor : Colors.black12),
            boxShadow: selected
                ? [BoxShadow(blurRadius: 2, color: kSecondaryColor)]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: path != null
                ? Image(
                    image: FileImage(File(path!)),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, trace) {
                      ErrorHandler.errorManger(context, error,
                          stacktrace: trace,
                          title:
                              "itemImageHolder widget imageDecoration error");
                      return const EmptyHolder(
                          text: "بارگزاری تصویر با مشکل مواجه شده است",
                          icon: Icons.image_not_supported_outlined);
                    },
                  )
                : emptyHolder != null
                    ? emptyHolder
                    : Icon(
                        Icons.image_sharp,
                        color: Colors.black12,
                      ),
          ),
        ),
      ),
    );
  }
}
