import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../Profile.dart';

class GetProfileImage extends StatelessWidget {
  final Function update;
  const GetProfileImage({
    Key? key,
    required this.update,
  }) : super(key: key);

  imageFromGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    print("result$result");
    if (result != null) {
      File image = File(result.files.single.path!);
      profileProvider!.isLoading = false;
      profileProvider!.selectedImageFromGellery = image;
      profileProvider!.storelogo = image.path;
      LOGO = image.path;
      profileProvider!.updateProfilePic(context, update);
      update();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 30.0, bottom: 10.0),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: primary,
        child: GestureDetector(
          onTap: () {
            imageFromGallery(context);
            update();
          },
          child: profileProvider!.storelogo != null
              ? Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius100),
                      border: Border.all(
                        color: primary,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(profileProvider!.storelogo!),
                      radius: 100,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            color: primary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: InkWell(
                          child: const Icon(
                            Icons.add,
                            color: white,
                            size: 20,
                          ),
                          onTap: () {
                            // profileProvider!.storelogo = null;
                            imageFromGallery(context);
                            update();
                          },
                        )),
                  )
                ])
              : Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius100),
                      border: Border.all(
                        color: primary,
                      ),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      size: 100,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            color: primary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: InkWell(
                          child: const Icon(
                            Icons.add,
                            color: white,
                            size: 20,
                          ),
                          onTap: () {
                            // profileProvider!.storelogo = null;
                            imageFromGallery(context);
                            update();
                          },
                        )),
                  )
                ]),
        ),
      ),
    );
  }
}
