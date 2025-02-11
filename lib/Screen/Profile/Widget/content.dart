import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/Map/map.dart';
import 'package:sellermultivendor/Screen/Profile/Profile.dart';
import 'package:sellermultivendor/Screen/Profile/Widget/commonfield.dart';
import 'package:sellermultivendor/Widget/validation.dart';

class Content extends StatelessWidget {
  final Function setStateNow;
  const Content({
    Key? key,
    required this.setStateNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: profileProvider!.formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: getTranslated(context, "NAME_LBL")!),
          CommonField(
            controller: profileProvider!.nameC,
            labelText: getTranslated(context, "NAME_LBL")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateUserName(val, context),
          ),
          CommonText(text: getTranslated(context, "MOBILEHINT_LBL")!),
          CommonField(
            controller: profileProvider!.mobileC,
            labelText: getTranslated(context, "MOBILEHINT_LBL")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateMob(val, context),
          ),
          CommonText(text: getTranslated(context, "Email")!),
          CommonField(
            controller: profileProvider!.emailC,
            labelText: getTranslated(context, "Email")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateMob(val, context),
          ),
          CommonText(text: getTranslated(context, "Addresh")!),
          CommonField(
            controller: profileProvider!.addressC,
            labelText: getTranslated(context, "Addresh")!,
            isObscureText: false,
            maxlines: 3,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "StoreName")!),
          CommonField(
            controller: profileProvider!.storenameC,
            labelText: getTranslated(context, "StoreName")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "StoreURL")!),
          CommonField(
            controller: profileProvider!.storeurlC,
            labelText: getTranslated(context, "StoreURL")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "Description")!),
          CommonField(
            controller: profileProvider!.storeDescC,
            labelText: getTranslated(context, "Description")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "Latitude")!),
          CommonField(
            controller: profileProvider!.latitututeC,
            labelText: getTranslated(context, "Latitude")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
            suffixIcon: IconButton(
                onPressed: () async {
                  LocationPermission permission;
                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }
                  Position position = await Geolocator.getCurrentPosition(
                    locationSettings:
                        const LocationSettings(accuracy: LocationAccuracy.high),
                  );
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MapScreen(
                        latitude: position.latitude,
                        longitude: position.longitude,
                        from: true,
                      ),
                    ),
                  ).then(
                    (value) {
                      profileProvider!.latitututeC!.text =
                          profileProvider!.latitutute!;
                      profileProvider!.longituteC!.text =
                          profileProvider!.longitude!;
                      setStateNow;
                    },
                  );
                },
                icon: const Icon(
                  Icons.my_location,
                  color: red,
                )),
          ),
          CommonText(text: getTranslated(context, "Longitude")!),
          CommonField(
            controller: profileProvider!.longituteC,
            labelText: getTranslated(context, "Longitude")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "TaxName")!),
          CommonField(
            controller: profileProvider!.taxnameC,
            labelText: getTranslated(context, "TaxName")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "TaxNumber")!),
          CommonField(
            controller: profileProvider!.taxnumberC,
            labelText: getTranslated(context, "TaxNumber")!,
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: getTranslated(context, "Authorized Signature")!),
        ],
      ),
    );
  }
}
