import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';
import '../../MediaUpload/Media.dart';
import '../Add_Product.dart';

selectedMainImageShow() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(circularBorderRadius10),
    child: Image.network(
      addProvider!.productImageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    ),
  );
}

//------------------------------------------------------------------------------
//========================= Main Image =========================================

videoUpload(
  BuildContext context,
  Function setState,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTranslated(context, "Video * ")!,
        ),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(circularBorderRadius5),
            ),
            width: 90,
            height: 40,
            child: Center(
              child: Text(
                getTranslated(context, "Upload")!,
                style: const TextStyle(
                  color: white,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const Media(
                  from: "video",
                  pos: 0,
                  type: "add",
                ),
              ),
            ).then((value) => setState());
          },
        ),
      ],
    ),
  );
}

selectedVideoShow() {
  return addProvider!.uploadedVideoName == ''
      ? Container()
      : SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    addProvider!.uploadedVideoName,
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
}

//------------------------------------------------------------------------------
//========================= Other Image ========================================

otherImages(String from, int pos, BuildContext context, Function setState) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: black.withOpacity(0.3),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(DesignConfiguration.setNewSvgPath('Capa')),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: Text(
                      'Enter Your Upload Here',
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
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Media(
                  from: from,
                  pos: pos,
                  type: "add",
                ),
              ),
            ).then(
              (value) => setState(),
            );
          },
        ),
      ],
    ),
  );
}

variantOtherImageShow(int pos, Function setState, BuildContext context) {
  return addProvider!.variationList.length == pos ||
          addProvider!.variationList[pos].imagesUrl == null
      ? otherImages("variant", pos, context, setState)
      : SizedBox(
          width: double.infinity,
          height: 130,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addProvider!.variationList[pos].imagesUrl!.length + 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              if (i == 0) {
                return otherImages("variant", pos, context, setState);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 8.0,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(circularBorderRadius10),
                        child: Image.network(
                          addProvider!.variationList[pos].imagesUrl![i - 1],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        addProvider!.variationList[pos].imagesUrl!
                            .removeAt(i - 1);
                        setState();
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                        child: const Icon(
                          Icons.clear,
                          size: 15,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
}
