import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/Profile/Profile.dart';
import 'package:sellermultivendor/Widget/desing.dart';

class AuthSign extends StatelessWidget {
  final Function update;
  const AuthSign({
    Key? key,
    required this.update,
  }) : super(key: key);

  imageFromGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);
      profileProvider!.isLoading = false;
      profileProvider!.selectedAuthSign = image;
      profileProvider!.updateProfilePic(context, update);
      update();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return profileProvider!.authSign == null
        ? GestureDetector(
            child: Container(
                margin: EdgeInsetsDirectional.only(top: 15),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: black.withOpacity(0.3),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(DesignConfiguration.setNewSvgPath('Capa')),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: Text(
                        'Upload',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: lightBlack, fontSize: 11),
                      ),
                    ),
                  ],
                )),
            onTap: () {
              profileProvider!.authSign = null;
              imageFromGallery(context);
            })
        : Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(top: 15),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.network(
                      profileProvider!.authSign!,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 3,
                      fit: BoxFit.fill,
                    )),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: InkWell(
                      child: Icon(
                        Icons.close,
                        color: white,
                        size: 20,
                      ),
                      onTap: () {
                        profileProvider!.authSign = null;
                        update();
                      },
                    )),
              )
            ],
          );
  }
}
