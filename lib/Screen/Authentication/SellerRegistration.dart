import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Model/CategoryModel/categoryModel.dart';
import 'package:sellermultivendor/Model/ZipCodesModel/ZipCodeModel.dart';
import 'package:sellermultivendor/Model/city.dart';
import 'package:sellermultivendor/Provider/categoryProvider.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Provider/zipcodeProvider.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/security.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/overylay.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';

class SellerRegister extends StatefulWidget {
  const SellerRegister({Key? key}) : super(key: key);

  @override
  _SellerRegisterState createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister>
    with TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController storeUrlController = TextEditingController();
  TextEditingController storeDescriptionController = TextEditingController();
  TextEditingController taxNameController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  FocusNode? nameFocus,
      emailFocus,
      passFocus,
      confirmPassFocus,
      addressFocus,
      storeFocus,
      storeUrlFocus,
      storeDescriptionFocus,
      taxNameFocus,
      taxNumberFocus,
      panNumberFocus,
      accountNumberFocus,
      accountNameFocus,
      bankCodeFocus,
      bankNameFocus,
      monumberFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  ScrollController controller = new ScrollController();
  ScrollController controller1 = new ScrollController();

  final mobileController = TextEditingController();
  var addressProfFile,
      nationalIdentityCardFile,
      storeLogoFile,
      authorizedSignFile;
  String? mobile,
      name,
      email,
      password,
      confirmpassword,
      address,
      addressproof,
      authorizedSign,
      nationalidentitycard,
      storename,
      storelogo,
      storeurl,
      storedescription,
      taxname,
      taxnumber,
      pannumber,
      accountnumber,
      accountname,
      bankcode,
      bankname;
  List<ZipCodeModel> selectedZipcodeList = [];
  List<CityModel> selectedCities = [];
  Timer? _debounce;
  Timer? _debounce1;
  List<CategoryModel> selectedCategoriesList = [];
//==============================================================================
//============================= INIT Method ====================================

  _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (mounted) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          context.read<CityProvider>().getCities(isReload: false);
        } else {
          context.read<ZipcodeProvider>().setZipCode(ProductAction.signup);
        }
      }
    }
  }

  _scrollListener1() async {
    if (controller1.offset >= controller1.position.maxScrollExtent &&
        !controller1.position.outOfRange) {
      if (mounted) {
        context.read<CategoryProvider>().setCategoryList(isRefresh: false);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      controller.addListener(_scrollListener);

      if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
        context.read<CityProvider>().getCities();
      } else {
        context
            .read<ZipcodeProvider>()
            .setZipCode(ProductAction.signup, isRefresh: true);
      }
    });
    Future.delayed(Duration.zero, () {
      controller1.addListener(_scrollListener1);

      context.read<CategoryProvider>().setCategoryList(isRefresh: true);
    });
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

//==============================================================================
//============================= For API Call ==================================

  Future<void> sellerRegisterAPI() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", registerApi);
        request.headers.addAll(headers);
        request.fields[Name] = name!;
        request.fields[Mobile] = mobile!;
        request.fields[Password] = password!;
        request.fields[EmailText] = email!;
        request.fields[ConfirmPassword] = confirmpassword!;
        request.fields[Address] = address!;

        if (authorizedSignFile != null) {
          final mimeType = lookupMimeType(authorizedSignFile.path);
          var extension = mimeType!.split("/");
          var authSign = await http.MultipartFile.fromPath(
            AuthSign,
            authorizedSignFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(authSign);
        }
        request.fields['category_ids'] =
            selectedCategoriesList.map((e) => e.id).toList().join(',');
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          request.fields['serviceable_cities[]'] =
              selectedCities.map((e) => e.id).toList().join(',');
        } else {
          request.fields['serviceable_zipcodes[]'] =
              selectedZipcodeList.map((e) => e.id).toList().join(',');
        }
        if (storeLogoFile != null) {
          final mimeType = lookupMimeType(storeLogoFile.path);
          var extension = mimeType!.split("/");
          var storelogo = await http.MultipartFile.fromPath(
            "store_logo",
            storeLogoFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(storelogo);
        }

        if (storeurl != null) {
          request.fields[Storeurl] = storeurl!;
        }

        request.fields[StoreName] = storename!;

        request.fields[storeDescription] = storedescription!;
        request.fields[tax_name] = taxname!;
        request.fields[tax_number] = taxnumber!;
        print("Register seller--${request.fields}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String? msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          showMsgDialog(msg!, true);
        } else {
          print("api error: $msg");
          await buttonController!.reverse();
          showMsgDialog(msg!, false);
        }
      } on TimeoutException catch (_) {
        showOverlay(
          getTranslated(context, 'somethingMSg')!,
          context,
        );
      }
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  showMsgDialog(String msg, bool goBack) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            msg,
                            style: Theme.of(this.context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: fontColor),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (goBack == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

//==============================================================================
//============================= For Animation ==================================

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

//==============================================================================
//============================= Network Checking ===============================

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (selectedCities.isNotEmpty ||
          selectedZipcodeList.isNotEmpty ||
          selectedCategoriesList.isNotEmpty) {
        sellerRegisterAPI();
      } else {
        await buttonController!.reverse();
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          setSnackbar(
              getTranslated(context, 'SELECT_CITIES_REQUIRED_LBL')!, context);
        } else {
          setSnackbar(
              getTranslated(context, 'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT')!,
              context);
        }
      }
    } else {
      Future.delayed(
        const Duration(seconds: 2),
      ).then(
        (_) async {
          await buttonController!.reverse();
          setState(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

//==============================================================================
//============================= Dispose Method =================================

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

//==============================================================================
//============================= No Internet Widget =============================
  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: white,
        key: _scaffoldKey,
        body: isNetworkAvail
            ? getLoginContainer()
            : noInternet(
                context,
                setStateNoInternate,
                buttonSqueezeanimation,
                buttonController,
              ),
      ),
    );
  }

  signInTxt() {
    return Text(
      "Sign Up",
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: black,
            fontWeight: FontWeight.bold,
            fontSize: textFontSize20,
            letterSpacing: 0.8,
            fontFamily: 'ubuntu',
          ),
    );
  }

  signInSubTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 13.0,
      ),
      child: Text(
        'Join us and start selling effortlessly. Sign up now to launch your e-commerce business today!',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black,
              fontWeight: FontWeight.normal,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  detailText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 23.0,
      ),
      child: Text(
        'Owner Details',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: black,
            fontWeight: FontWeight.normal,
            fontFamily: 'ubuntu',
            fontSize: textFontSize16),
      ),
    );
  }

  storeText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 23.0,
      ),
      child: Text(
        'Store Details',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: black,
            fontWeight: FontWeight.normal,
            fontFamily: 'ubuntu',
            fontSize: textFontSize16),
      ),
    );
  }

  setHaveAcc() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account? ",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: black,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'ubuntu',
                ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Sign In',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'ubuntu',
                  ),
            ),
          )
        ],
      ),
    );
  }

//==============================================================================
//============================= Login Container widget =========================

  getLoginContainer() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 23),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DesignConfiguration.backButton(context),
                  signInTxt(),
                  signInSubTxt(),
                  detailText(),
                  setName(),
                  setEmail(),
                  setMobileNo(),
                  setPass(),
                  confirmPassword(),
                  storeText(),
                  storeName(),
                  storeUrl(),
                  setStoreCategories(),
                  getZipCodeOrCityContainer(),
                  warningMessage(),
                  SizedBox(height: 6),
                  setStoreDescription(),
                  setaddress(),
                  taxName(),
                  taxNumber(),
                  uploadStoreLogo(getTranslated(context, "Store Logo")!),
                  selectedMainImageShow(
                      storeLogoFile, getTranslated(context, "Store Logo")!, 1),
                  uploadStoreLogo(
                      getTranslated(context, "Authorized Signature")!),
                  selectedMainImageShow(authorizedSignFile,
                      getTranslated(context, "Authorized Signature")!, 4),
                  loginBtn(),
                  setHaveAcc()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  warningMessage() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5),
      child: AppSettingsRepository.appSettings.isCityWiseDeliveribility
          ? selectedCities.isNotEmpty
              ? SizedBox.shrink()
              : Text(
                  getTranslated(context, 'SELECT_CITIES_REQUIRED_LBL')!,
                  style: TextStyle(color: Colors.red, fontSize: 11),
                )
          : selectedZipcodeList.isNotEmpty
              ? SizedBox.shrink()
              : Text(
                  getTranslated(context, 'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT')!,
                  style: TextStyle(color: Colors.red, fontSize: 11),
                ),
    );
  }

  uploadStoreLogo(String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: black,
            fontWeight: FontWeight.normal,
            fontFamily: 'ubuntu',
            fontSize: textFontSize16),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       title,
      //     ),
      //     InkWell(
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: primary,
      //           borderRadius: BorderRadius.circular(circularBorderRadius5),
      //         ),
      //         width: 90,
      //         height: 40,
      //         child: Center(
      //           child: Text(
      //             getTranslated(context, "Upload")!,
      //             style: const TextStyle(
      //               color: white,
      //             ),
      //           ),
      //         ),
      //       ),
      //       onTap: () {
      //         mainImageFromGallery(number);
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  mainImageFromGallery(int number) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);

      setState(
        () {
          if (number == 1) {
            storeLogoFile = image;
          }
          if (number == 2) {
            nationalIdentityCardFile = image;
          }
          if (number == 3) {
            addressProfFile = image;
          }
          if (number == 4) {
            authorizedSignFile = image;
          }
        },
      );
    } else {
      // User canceled the picker
      return 'Required this filed';
    }
  }

  selectedMainImageShow(File? name, String title, int number) {
    return name == null
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
                        'Enter Your $title Here',
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
              mainImageFromGallery(number);
            })
        : Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(top: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.file(
                    name,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 3,
                    fit: BoxFit.fill,
                  ),
                ),
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
                        setState(() {
                          if (number == 1) {
                            storeLogoFile = null;
                            selectedMainImageShow(storeLogoFile, title, number);
                          } else if (number == 4) {
                            authorizedSignFile = null;
                            selectedMainImageShow(
                                authorizedSignFile, title, number);
                          }
                        });
                      },
                    )),
              )
            ],
          );
  }

  Widget setSignInLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          getTranslated(context, "Seller Registration")!,
          style: const TextStyle(
            color: primary,
            fontSize: textFontSize30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  setName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nameFocus);
        },
        keyboardType: TextInputType.text,
        controller: nameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: nameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          name = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('Profile'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "Name")!,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  taxName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(taxNameFocus);
        },
        keyboardType: TextInputType.text,
        controller: taxNameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: taxNameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          taxname = value;
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.person,
            color: lightBlack2,
            size: 20,
          ),
          fillColor: lightWhite.withOpacity(0.4),
          hintText: getTranslated(context, "TaxName"),
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
        ),
      ),
    );
  }

  taxNumber() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(taxNumberFocus);
        },
        keyboardType: TextInputType.text,
        controller: taxNumberController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: taxNameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          taxnumber = value;
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.format_list_numbered_outlined,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "TaxNumber")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: lightWhite.withOpacity(0.4),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
        ),
      ),
    );
  }

  setStoreDescription() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeDescriptionFocus);
        },
        keyboardType: TextInputType.multiline,
        controller: storeDescriptionController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storeDescriptionFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          storedescription = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('Description'),
              // fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "Store Description")!,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            hintTextDirection: TextDirection.ltr,
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget setStoreCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
            border: Border.all(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
            color: lightWhite.withOpacity(0.5)),
        child: ListTile(
          title: selectedCategoriesList.isNotEmpty
              ? Text(
                  selectedCategoriesList.map((e) => e.name).toList().join(', '),
                )
              : Text(
                  getTranslated(context, 'Select Category')!,
                  style: TextStyle(fontSize: 13, color: black.withOpacity(0.4)),
                ),
          trailing: const Icon(Icons.chevron_right),
          // Prevent text entry
          onTap: () async {
            final categoriesProvider =
                Provider.of<CategoryProvider>(context, listen: false);
            if (categoriesProvider.searchString.isNotEmpty) {
              categoriesProvider.searchString = "";
              context.read<CategoryProvider>().setCategoryList(isRefresh: true);
            } else if (categoriesProvider.categoryList.isEmpty) {
              context
                  .read<CategoryProvider>()
                  .setCategoryList(isRefresh: false);
            }
            // await categoriesDialog(context); // Open the bottom sheet
            await showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                    scrollable: true,
                    content: Consumer<CategoryProvider>(
                      builder: (context, data, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTranslated(context, 'Select Category')!,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: primary),
                            ),
                            const Divider(color: lightBlack),
                            Flexible(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: SingleChildScrollView(
                                  // physics: AlwaysScrollableScrollPhysics(),
                                  controller: controller1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  circularBorderRadius5)),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: blarColor,
                                              offset: Offset(0, 0),
                                              blurRadius: 4,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                          color: white,
                                        ),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            filled: true,
                                            isDense: true,
                                            fillColor: white,
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minWidth: 40,
                                              maxHeight: 20,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            hintText: getTranslated(
                                                context, "SEARCH"),
                                            hintStyle: TextStyle(
                                                color: black.withOpacity(0.3),
                                                fontWeight: FontWeight.normal),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (_debounce1?.isActive ?? false)
                                              _debounce1?.cancel();
                                            data.searchString = value;
                                            //auto search after 1 second of typing
                                            _debounce1 = Timer(
                                                const Duration(
                                                    milliseconds: 1000), () {
                                              context
                                                  .read<CategoryProvider>()
                                                  .setCategoryList();
                                            });
                                          },
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          StatefulBuilder(
                                              builder: (context, setstater) {
                                            print(
                                                "category list length--->${data.categoryList.length}}");
                                            return (data
                                                    .categoryList.isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: () {
                                                      return data.categoryList
                                                          .asMap()
                                                          .map((index,
                                                                  element) =>
                                                              MapEntry(
                                                                index,
                                                                CheckboxListTile(
                                                                  title: Text(
                                                                      element
                                                                          .name!),
                                                                  value: selectedCategoriesList.any((selected) =>
                                                                      selected
                                                                          .id ==
                                                                      element
                                                                          .id),
                                                                  onChanged:
                                                                      (isSelected) {
                                                                    if (isSelected ==
                                                                        true) {
                                                                      if (!selectedCategoriesList.any((selected) =>
                                                                          selected
                                                                              .id ==
                                                                          element
                                                                              .id)) {
                                                                        selectedCategoriesList
                                                                            .add(element);
                                                                      }
                                                                    } else {
                                                                      selectedCategoriesList.removeWhere((selected) =>
                                                                          selected
                                                                              .id ==
                                                                          element
                                                                              .id);
                                                                    }
                                                                    setState(
                                                                        () {}); // Update UI
                                                                    setstater(
                                                                        () {}); // Update dialog state
                                                                  },
                                                                ),
                                                              ))
                                                          .values
                                                          .toList();
                                                    }(),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20.0),
                                                    child: Text(getTranslated(
                                                        context,
                                                        'CATEGORY_IS_NOT_AVAIL_LBL')!),
                                                  );
                                          }),
                                          DesignConfiguration
                                              .showCircularProgress(
                                            false,
                                            primary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  getTranslated(context, 'DONE')!,
                                  style: Theme.of(this.context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: primary),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ));
              },
            );
          },
        ),
      ),
    );
  }

  Widget getZipCodeOrCityContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
            border: Border.all(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
            color: lightWhite.withOpacity(0.5)),
        child: ListTile(
          title: AppSettingsRepository.appSettings.isCityWiseDeliveribility
              ? selectedCities.isNotEmpty
                  ? Text(
                      selectedCities.map((e) => e.name).toList().join(', '),
                    )
                  : Text(
                      getTranslated(context, 'SELECT_CITIES_LBL')!,
                      style: TextStyle(
                          fontSize: 13, color: black.withOpacity(0.4)),
                    )
              : selectedZipcodeList.isNotEmpty
                  ? Text(
                      selectedZipcodeList
                          .map((e) => e.zipcode)
                          .toList()
                          .join(', '),
                    )
                  : Text(
                      getTranslated(context, 'SELECT_ZIPCODE_LBL')!,
                      style: TextStyle(
                          fontSize: 13, color: black.withOpacity(0.4)),
                    ),
          trailing: Icon(Icons.chevron_right),
          onTap: () async {
            if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
              final cityProvider =
                  Provider.of<CityProvider>(context, listen: false);
              if (cityProvider.searchString.isNotEmpty) {
                cityProvider.searchString = "";
                context.read<CityProvider>().getCities();
              } else if (cityProvider.cityList.isEmpty) {
                context.read<CityProvider>().getCities();
              }
            } else {
              final zipcodeProvider =
                  Provider.of<ZipcodeProvider>(context, listen: false);
              if (zipcodeProvider.searchString.isNotEmpty) {
                zipcodeProvider.searchString = "";
                context
                    .read<ZipcodeProvider>()
                    .setZipCode(ProductAction.signup, isRefresh: true);
              } else if (zipcodeProvider.zipcodeList.isEmpty) {
                context
                    .read<ZipcodeProvider>()
                    .setZipCode(ProductAction.signup, isRefresh: false);
              }
            }
            await showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  scrollable: true,
                  content: Consumer<CityProvider>(
                    builder: (context, cityData, child) {
                      return Consumer<ZipcodeProvider>(
                        builder: (context, data, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                getTranslated(
                                    context,
                                    AppSettingsRepository.appSettings
                                            .isCityWiseDeliveribility
                                        ? 'SELECT_CITIES_LBL'
                                        : 'SELECT_SERVICEABLE_ZIPCODE_LBL')!,
                                style: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: primary),
                              ),
                              const Divider(color: lightBlack),
                              Flexible(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: SingleChildScrollView(
                                    // physics: AlwaysScrollableScrollPhysics(),
                                    controller: controller,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    circularBorderRadius5)),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: blarColor,
                                                offset: Offset(0, 0),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                            color: white,
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              isDense: true,
                                              fillColor: white,
                                              prefixIconConstraints:
                                                  const BoxConstraints(
                                                minWidth: 40,
                                                maxHeight: 20,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                              hintText: getTranslated(
                                                  context, "SEARCH"),
                                              hintStyle: TextStyle(
                                                  color: black.withOpacity(0.3),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              if (_debounce?.isActive ?? false)
                                                _debounce?.cancel();
                                              data.searchString = value;
                                              cityData.searchString = value;
                                              //auto search after 1 second of typing
                                              _debounce = Timer(
                                                  const Duration(
                                                      milliseconds: 1000), () {
                                                if (AppSettingsRepository
                                                    .appSettings
                                                    .isCityWiseDeliveribility) {
                                                  context
                                                      .read<CityProvider>()
                                                      .getCities();
                                                } else {
                                                  context
                                                      .read<ZipcodeProvider>()
                                                      .setZipCode(
                                                          ProductAction.signup);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        (AppSettingsRepository.appSettings
                                                    .isCityWiseDeliveribility
                                                ? cityData.isLoading
                                                : false)
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 50.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  (AppSettingsRepository
                                                              .appSettings
                                                              .isCityWiseDeliveribility
                                                          ? cityData.cityList
                                                              .isNotEmpty
                                                          : data.zipcodeList
                                                              .isNotEmpty)
                                                      ? StatefulBuilder(builder:
                                                          (context, setstater) {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: () {
                                                              if (AppSettingsRepository
                                                                  .appSettings
                                                                  .isCityWiseDeliveribility) {
                                                                return cityData
                                                                    .cityList
                                                                    .asMap()
                                                                    .map((index,
                                                                            element) =>
                                                                        MapEntry(
                                                                            index,
                                                                            CheckboxListTile(
                                                                              title: Text(element.name),
                                                                              value: selectedCities.any((selected) => selected.id == element.id),
                                                                              // selectedCities.contains(element),
                                                                              onChanged: (isSelected) {
                                                                                if (isSelected == true) {
                                                                                  if (!selectedCities.any((selected) => selected.id == element.id)) {
                                                                                    selectedCities.add(element);
                                                                                  }
                                                                                } else {
                                                                                  selectedCities.removeWhere((selected) => selected.id == element.id);
                                                                                }
                                                                                setState(() {}); // Update UI
                                                                                setstater(() {}); // Update dialog state
                                                                              },
                                                                              //   onChanged: (_) {
                                                                              //     if (selectedCities.contains(element)) {
                                                                              //       selectedCities.remove(element);
                                                                              //     } else {
                                                                              //       selectedCities.add(element);
                                                                              //     }
                                                                              //     setState(() {});
                                                                              //     setstater(() {});
                                                                              //   },
                                                                            )))
                                                                    .values
                                                                    .toList();
                                                              }
                                                              return data
                                                                  .zipcodeList
                                                                  .asMap()
                                                                  .map((index,
                                                                          element) =>
                                                                      MapEntry(
                                                                          index,
                                                                          CheckboxListTile(
                                                                            title:
                                                                                Text(element.zipcode!),
                                                                            value: selectedZipcodeList.any((selected) =>
                                                                                selected.id ==
                                                                                element.id),
                                                                            // selectedZipcodeList.contains(element),
                                                                            //value: true,
                                                                            onChanged:
                                                                                (isSelected) {
                                                                              if (isSelected == true) {
                                                                                if (!selectedZipcodeList.any((selected) => selected.id == element.id)) {
                                                                                  selectedZipcodeList.add(element);
                                                                                }
                                                                              } else {
                                                                                selectedZipcodeList.removeWhere((selected) => selected.id == element.id);
                                                                              }
                                                                              setState(() {}); // Update UI
                                                                              setstater(() {}); // Update dialog state
                                                                            },
                                                                            //   onChanged:
                                                                            //       (_) {
                                                                            //     if (selectedZipcodeList.contains(element)) {
                                                                            //       selectedZipcodeList.remove(element);
                                                                            //     } else {
                                                                            //       selectedZipcodeList.add(element);
                                                                            //     }
                                                                            //     setState(() {});
                                                                            //     setstater(() {});
                                                                            //   },
                                                                          )))
                                                                  .values
                                                                  .toList();
                                                            }(),
                                                          );
                                                        })
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      20.0),
                                                          child: Text(getTranslated(
                                                              context,
                                                              AppSettingsRepository
                                                                      .appSettings
                                                                      .isCityWiseDeliveribility
                                                                  ? 'CITY_IS_NOT_AVAIL_LBL'
                                                                  : 'ZIPCODE_IS_NOT_AVAIL_LBL')!),
                                                        ),
                                                  DesignConfiguration
                                                      .showCircularProgress(
                                                    AppSettingsRepository
                                                            .appSettings
                                                            .isCityWiseDeliveribility
                                                        ? cityData.isLoadingmore
                                                        : false,
                                                    primary,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    getTranslated(context, 'DONE')!,
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: primary),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  storeUrl() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeUrlFocus);
        },
        keyboardType: TextInputType.text,
        controller: storeUrlController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storeUrlFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          storeurl = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('StoreURL'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "StoreURL")!,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  storeName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeFocus);
        },
        keyboardType: TextInputType.text,
        controller: storeController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storeFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          storename = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('StoreName'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "StoreName")!,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  setaddress() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(addressFocus);
        },
        keyboardType: TextInputType.text,
        controller: addressController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: addressFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          address = value;
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          border: InputBorder.none,
          prefixIcon: SvgPicture.asset(
            DesignConfiguration.setNewSvgPath('Address'),
            fit: BoxFit.scaleDown,
            colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
          ),
          hintText: getTranslated(context, "Addresh")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: lightWhite.withOpacity(0.4),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
        ),
      ),
    );
  }

  setEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(emailFocus);
        },
        keyboardType: TextInputType.text,
        controller: emailController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: emailFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) => StringValidation.validateEmail(val!, context),
        onSaved: (String? value) {
          email = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('Email'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "E-mail")!,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  setMobileNo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        maxLength: 16,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(monumberFocus);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: mobileController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: monumberFocus,
        textInputAction: TextInputAction.next,
        //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) => StringValidation.validateMob(val!, context),
        onSaved: (String? value) {
          mobile = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('MobileNumber'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "MobileNumber")!,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withOpacity(0.3).withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  setPass() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        focusNode: passFocus,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            StringValidation.validatePass(val!, context, onlyRequired: false),
        onSaved: (String? value) {
          password = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('Password'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "PASSHINT_LBL"),
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: lightBlack2, fontWeight: FontWeight.normal),
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            errorMaxLines: 3,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, maxHeight: 20),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 40, maxHeight: 20),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  confirmPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(confirmPassFocus);
        },
        keyboardType: TextInputType.text,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        obscureText: true,
        controller: confirmPasswordController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: confirmPassFocus,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            StringValidation.validatePass(val!, context, onlyRequired: true),
        onSaved: (String? value) {
          confirmpassword = value;
        },
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath('Password'),
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
            ),
            hintText: getTranslated(context, "CONFIRMPASSHINT_LBL")!,
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: lightBlack2, fontWeight: FontWeight.normal),
            filled: true,
            fillColor: lightWhite.withOpacity(0.4),
            errorMaxLines: 3,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // suffixIconConstraints:
            //     const BoxConstraints(minWidth: 40, maxHeight: 20),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 40, maxHeight: 20),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
      ),
    );
  }

  loginBtn() {
    return AppBtn(
      title: getTranslated(context, "Apply Now")!,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }
}
