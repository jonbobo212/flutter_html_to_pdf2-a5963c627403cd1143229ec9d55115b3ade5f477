// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sellermultivendor/Model/order/consignment_model.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.mobile,
    required this.total,
    required this.deliveryCharge,
    required this.isDeliveryChargeReturnable,
    required this.walletBalance,
    required this.promoCode,
    required this.promoDiscount,
    required this.discount,
    required this.totalPayable,
    required this.finalTotal,
    required this.paymentMethod,
    required this.isCodCollected,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.deliveryTime,
    required this.status,
    required this.deliveryDate,
    required this.dateAdded,
    required this.otp,
    required this.email,
    required this.notes,
    required this.attachments,
    required this.isPosOrder,
    required this.isShiprocketOrder,
    required this.username,
    required this.countryCode,
    required this.name,
    required this.type,
    required this.downloadAllowed,
    required this.pickupLocation,
    required this.orderRecipientPerson,
    required this.specialPrice,
    required this.price,
    required this.sellerDeliveryCharge,
    required this.sellerPromoDicount,
    required this.courierAgency,
    required this.trackingId,
    required this.url,
    required this.isReturnable,
    required this.isCancelable,
    required this.isAlreadyReturned,
    required this.isAlreadyCancelled,
    required this.returnRequestSubmitted,
    required this.totalTaxPercent,
    required this.totalTaxAmount,
    required this.invoiceHtml,
    required this.orderItems,
    required this.userProfilePicture,
    required this.orderattachments,
  });

  String? id;
  String? userId;
  String? addressId;
  String? mobile;
  String? total;
  String? deliveryCharge;
  String? isDeliveryChargeReturnable;
  String? walletBalance;
  String? promoCode;
  String? promoDiscount;
  String? discount;
  String? totalPayable;
  String? finalTotal;
  String? paymentMethod;
  String? isCodCollected;
  String? latitude;
  String? longitude;
  String? address;
  String? deliveryTime;
  String? status;
  String? deliveryDate;
  String? dateAdded;
  String? otp;
  String? email;
  String? notes;
  List<dynamic> attachments;
  String? isPosOrder;
  String? isShiprocketOrder;
  String? username;
  String? countryCode;
  String? name;
  String? type;
  String? downloadAllowed;
  String? pickupLocation;
  String? orderRecipientPerson;
  String? specialPrice;
  String? price;
  String? sellerDeliveryCharge;
  String? sellerPromoDicount;
  String? courierAgency;
  String? trackingId;
  String? url;
  String? isReturnable;
  String? isCancelable;
  String? isAlreadyReturned;
  String? isAlreadyCancelled;
  String? returnRequestSubmitted;
  String? totalTaxPercent;
  String? totalTaxAmount;
  String? invoiceHtml;
  List<OrderItem> orderItems;
  String userProfilePicture;
  List<String>? orderattachments;

  //for updating in multiple screens
  void changeValues(OrderModel order) {
    id = order.id;
    userId = order.userId;
    addressId = order.addressId;
    mobile = order.mobile;
    total = order.total;
    deliveryCharge = order.deliveryCharge;
    isDeliveryChargeReturnable = order.isDeliveryChargeReturnable;
    walletBalance = order.walletBalance;
    promoCode = order.promoCode;
    promoDiscount = order.promoDiscount;
    discount = order.discount;
    totalPayable = order.totalPayable;
    finalTotal = order.finalTotal;
    paymentMethod = order.paymentMethod;
    isCodCollected = order.isCodCollected;
    latitude = order.latitude;
    longitude = order.longitude;
    address = order.address;
    deliveryTime = order.deliveryTime;
    status = order.status;
    deliveryDate = order.deliveryDate;
    dateAdded = order.dateAdded;
    otp = order.otp;
    email = order.email;
    notes = order.notes;
    attachments = order.attachments;
    isPosOrder = order.isPosOrder;
    isShiprocketOrder = order.isShiprocketOrder;
    username = order.username;
    countryCode = order.countryCode;
    name = order.name;
    type = order.type;
    downloadAllowed = order.downloadAllowed;
    pickupLocation = order.pickupLocation;
    orderRecipientPerson = order.orderRecipientPerson;
    specialPrice = order.specialPrice;
    price = order.price;
    sellerDeliveryCharge = order.sellerDeliveryCharge;
    sellerPromoDicount = order.sellerPromoDicount;
    courierAgency = order.courierAgency;
    trackingId = order.trackingId;
    url = order.url;
    isReturnable = order.isReturnable;
    isCancelable = order.isCancelable;
    isAlreadyReturned = order.isAlreadyReturned;
    isAlreadyCancelled = order.isAlreadyCancelled;
    returnRequestSubmitted = order.returnRequestSubmitted;
    totalTaxPercent = order.totalTaxPercent;
    totalTaxAmount = order.totalTaxAmount;
    invoiceHtml = order.invoiceHtml;
    orderItems = order.orderItems;
    orderattachments = order.orderattachments;
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? addressId,
    String? mobile,
    String? total,
    String? deliveryCharge,
    String? isDeliveryChargeReturnable,
    String? walletBalance,
    String? promoCode,
    String? promoDiscount,
    String? discount,
    String? totalPayable,
    String? finalTotal,
    String? paymentMethod,
    String? isCodCollected,
    String? latitude,
    String? longitude,
    String? address,
    String? deliveryTime,
    String? status,
    String? deliveryDate,
    String? dateAdded,
    String? otp,
    String? email,
    String? notes,
    List<dynamic>? attachments,
    String? isPosOrder,
    String? isShiprocketOrder,
    String? username,
    String? countryCode,
    String? name,
    String? type,
    String? downloadAllowed,
    String? pickupLocation,
    String? orderRecipientPerson,
    String? specialPrice,
    String? price,
    String? sellerDeliveryCharge,
    String? sellerPromoDicount,
    String? courierAgency,
    String? trackingId,
    String? url,
    String? isReturnable,
    String? isCancelable,
    String? isAlreadyReturned,
    String? isAlreadyCancelled,
    String? returnRequestSubmitted,
    String? totalTaxPercent,
    String? totalTaxAmount,
    String? invoiceHtml,
    List<OrderItem>? orderItems,
    List<String>? orderattachments,
  }) {
    return OrderModel(
      userProfilePicture: '',
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      mobile: mobile ?? this.mobile,
      total: total ?? this.total,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      isDeliveryChargeReturnable:
          isDeliveryChargeReturnable ?? this.isDeliveryChargeReturnable,
      walletBalance: walletBalance ?? this.walletBalance,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
      discount: discount ?? this.discount,
      totalPayable: totalPayable ?? this.totalPayable,
      finalTotal: finalTotal ?? this.finalTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isCodCollected: isCodCollected ?? this.isCodCollected,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      status: status ?? this.status,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      dateAdded: dateAdded ?? this.dateAdded,
      otp: otp ?? this.otp,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      isPosOrder: isPosOrder ?? this.isPosOrder,
      isShiprocketOrder: isShiprocketOrder ?? this.isShiprocketOrder,
      username: username ?? this.username,
      countryCode: countryCode ?? this.countryCode,
      name: name ?? this.name,
      type: type ?? this.type,
      downloadAllowed: downloadAllowed ?? this.downloadAllowed,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      orderRecipientPerson: orderRecipientPerson ?? this.orderRecipientPerson,
      specialPrice: specialPrice ?? this.specialPrice,
      price: price ?? this.price,
      sellerDeliveryCharge: sellerDeliveryCharge ?? this.sellerDeliveryCharge,
      sellerPromoDicount: sellerPromoDicount ?? this.sellerPromoDicount,
      courierAgency: courierAgency ?? this.courierAgency,
      trackingId: trackingId ?? this.trackingId,
      url: url ?? this.url,
      isReturnable: isReturnable ?? this.isReturnable,
      isCancelable: isCancelable ?? this.isCancelable,
      isAlreadyReturned: isAlreadyReturned ?? this.isAlreadyReturned,
      isAlreadyCancelled: isAlreadyCancelled ?? this.isAlreadyCancelled,
      returnRequestSubmitted:
          returnRequestSubmitted ?? this.returnRequestSubmitted,
      totalTaxPercent: totalTaxPercent ?? this.totalTaxPercent,
      totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
      invoiceHtml: invoiceHtml ?? this.invoiceHtml,
      orderItems: orderItems ?? this.orderItems,
      orderattachments: orderattachments ?? this.orderattachments,
    );
  }

//GETTERS
  bool get isAllItemsConsignmentCreated =>
      orderItems.every((element) => element.isConsignmentCreated == '1')
          ? true
          : false;

  bool get isDigitalOrder => type == 'digital_product';
  bool get isShiprocketOrderBool => isShiprocketOrder == '1';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userProfilePicture: json['user_profile'],
      userId: json["user_id"],
      addressId: json["address_id"],
      mobile: json["mobile"],
      total: json["total"],
      deliveryCharge: json["delivery_charge"],
      isDeliveryChargeReturnable: json["is_delivery_charge_returnable"],
      walletBalance: json["wallet_balance"],
      promoCode: json["promo_code"],
      promoDiscount: json["promo_discount"],
      discount: json["discount"],
      totalPayable: json["total_payable"],
      finalTotal: json["final_total"],
      paymentMethod: json["payment_method"],
      isCodCollected: json["is_cod_collected"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      address: json["address"],
      deliveryTime: json["delivery_time"],
      status: json["status"],
      deliveryDate: json["delivery_date"],
      dateAdded: json["date_added"],
      otp: json["otp"],
      email: json["email"],
      notes: json["notes"],
      attachments: json["attachments"] == null
          ? []
          : List<dynamic>.from(json["attachments"]!.map((x) => x)),
      isPosOrder: json["is_pos_order"],
      isShiprocketOrder: json["is_shiprocket_order"]?.toString() ?? '',
      username: json["username"],
      countryCode: json["country_code"],
      name: json["name"],
      type: json["type"],
      downloadAllowed: json["download_allowed"],
      pickupLocation: json["pickup_location"],
      orderRecipientPerson: json["order_recipient_person"],
      specialPrice: json["special_price"],
      price: json["price"],
      sellerDeliveryCharge: json["seller_delivery_charge"],
      sellerPromoDicount: json["seller_promo_dicount"],
      courierAgency: json["courier_agency"],
      trackingId: json["tracking_id"],
      url: json["url"],
      isReturnable: json["is_returnable"],
      isCancelable: json["is_cancelable"],
      isAlreadyReturned: json["is_already_returned"],
      isAlreadyCancelled: json["is_already_cancelled"],
      returnRequestSubmitted: json["return_request_submitted"],
      totalTaxPercent: json["total_tax_percent"],
      totalTaxAmount: json["total_tax_amount"],
      invoiceHtml: json["invoice_html"] ?? '',
      orderItems: json["order_items"] == null
          ? []
          : List<OrderItem>.from(
              json["order_items"]!.map((x) => OrderItem.fromJson(x))),
      orderattachments: json["order_prescription_attachments"] == null
          ? []
          : List<String>.from(
              json["order_prescription_attachments"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address_id": addressId,
        "mobile": mobile,
        "total": total,
        "delivery_charge": deliveryCharge,
        "is_delivery_charge_returnable": isDeliveryChargeReturnable,
        "wallet_balance": walletBalance,
        "promo_code": promoCode,
        "promo_discount": promoDiscount,
        "discount": discount,
        "total_payable": totalPayable,
        "final_total": finalTotal,
        "payment_method": paymentMethod,
        "is_cod_collected": isCodCollected,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "delivery_time": deliveryTime,
        "status": status,
        "delivery_date": "$deliveryDate",
        "date_added": dateAdded,
        "otp": otp,
        "email": email,
        "notes": notes,
        "attachments": attachments.map((x) => x).toList(),
        "is_pos_order": isPosOrder,
        "is_shiprocket_order": isShiprocketOrder,
        "username": username,
        "country_code": countryCode,
        "name": name,
        "type": type,
        "download_allowed": downloadAllowed,
        "pickup_location": pickupLocation,
        "order_recipient_person": orderRecipientPerson,
        "special_price": specialPrice,
        "price": price,
        "seller_delivery_charge": sellerDeliveryCharge,
        "seller_promo_dicount": sellerPromoDicount,
        "courier_agency": courierAgency,
        "tracking_id": trackingId,
        "url": url,
        "is_returnable": isReturnable,
        "is_cancelable": isCancelable,
        "is_already_returned": isAlreadyReturned,
        "is_already_cancelled": isAlreadyCancelled,
        "return_request_submitted": returnRequestSubmitted,
        "total_tax_percent": totalTaxPercent,
        "total_tax_amount": totalTaxAmount,
        "invoice_html": invoiceHtml,
        "order_items": orderItems.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$id, $userId, $addressId, $mobile, $total, $deliveryCharge, $isDeliveryChargeReturnable, $walletBalance, $promoCode, $promoDiscount, $discount, $totalPayable, $finalTotal, $paymentMethod, $isCodCollected, $latitude, $longitude, $address, $deliveryTime, $status, $deliveryDate, $dateAdded, $otp, $email, $notes, $attachments, $isPosOrder, $isShiprocketOrder, $username, $countryCode, $name, $type, $downloadAllowed, $pickupLocation, $orderRecipientPerson, $specialPrice, $price, $sellerDeliveryCharge, $sellerPromoDicount, $courierAgency, $trackingId, $url, $isReturnable, $isCancelable, $isAlreadyReturned, $isAlreadyCancelled, $returnRequestSubmitted, $totalTaxPercent, $totalTaxAmount, $invoiceHtml, $orderItems, $orderattachments ";
  }
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.deliveryBoyId,
    required this.sellerId,
    required this.isCredited,
    required this.otp,
    required this.productName,
    required this.variantName,
    required this.productVariantId,
    required this.quantity,
    required this.price,
    required this.discountedPrice,
    required this.taxIds,
    required this.taxPercent,
    required this.taxAmount,
    required this.discount,
    required this.subTotal,
    required this.deliverBy,
    required this.updatedBy,
    required this.status,
    required this.adminCommissionAmount,
    required this.sellerCommissionAmount,
    required this.activeStatus,
    required this.hashLink,
    required this.isSent,
    required this.dateAdded,
    required this.deliveredQuantity,
    required this.productId,
    required this.isCancelable,
    required this.isPricesInclusiveTax,
    required this.cancelableTill,
    required this.type,
    required this.slug,
    required this.downloadAllowed,
    required this.downloadLink,
    required this.storeName,
    required this.sellerLongitude,
    required this.sellerMobile,
    required this.sellerAddress,
    required this.sellerLatitude,
    required this.deliveryBoyName,
    required this.storeDescription,
    required this.sellerRating,
    required this.sellerProfile,
    required this.courierAgency,
    required this.trackingId,
    required this.awbCode,
    required this.url,
    required this.sellerName,
    required this.isReturnable,
    required this.specialPrice,
    required this.mainPrice,
    required this.image,
    required this.name,
    required this.pickupLocation,
    required this.weight,
    required this.sellerNoOfRatings,
    required this.productRating,
    required this.userRating,
    required this.userRatingImages,
    required this.userRatingComment,
    required this.orderCounter,
    required this.orderCancelCounter,
    required this.orderReturnCounter,
    required this.netAmount,
    required this.varaintIds,
    required this.variantValues,
    required this.attrName,
    required this.imageSm,
    required this.imageMd,
    required this.isAlreadyReturned,
    required this.isAlreadyCancelled,
    required this.returnRequestSubmitted,
    required this.shiprocketOrderTrackingUrl,
    required this.email,
    required this.isConsignmentCreated,
  });

  final String? id;
  final String? userId;
  final String? orderId;
  final String? deliveryBoyId;
  final String? sellerId;
  final String? isCredited;
  final dynamic otp;
  final String? productName;
  final String? variantName;
  final String? productVariantId;
  final String? quantity;
  final String? price;
  final String? discountedPrice;
  final String? taxIds;
  final String? taxPercent;
  final num? taxAmount;
  final String? discount;
  final String? subTotal;
  final String? deliverBy;
  final String? updatedBy;
  final dynamic status;
  final String? adminCommissionAmount;
  final String? sellerCommissionAmount;
  final String? activeStatus;
  final dynamic hashLink;
  final String? isSent;
  final DateTime? dateAdded;
  final String? deliveredQuantity;
  final String? productId;
  final String? isCancelable;
  final String? isPricesInclusiveTax;
  final String? cancelableTill;
  final String? type;
  final String? slug;
  final String? downloadAllowed;
  final String? downloadLink;
  final String? storeName;
  final String? sellerLongitude;
  final String? sellerMobile;
  final String? sellerAddress;
  final String? sellerLatitude;
  final String? deliveryBoyName;
  final String? storeDescription;
  final String? sellerRating;
  final String? sellerProfile;
  final String? courierAgency;
  final String? trackingId;
  final dynamic awbCode;
  final String? url;
  final String? sellerName;
  final String? isReturnable;
  final String? specialPrice;
  final String? mainPrice;
  final String? image;
  final String? name;
  final String? pickupLocation;
  final String? weight;
  final String? sellerNoOfRatings;
  final String? productRating;
  final String? userRating;
  final List<dynamic> userRatingImages;
  final String? userRatingComment;
  final String? orderCounter;
  final String? orderCancelCounter;
  final String? orderReturnCounter;
  final num? netAmount;
  final String? varaintIds;
  final String? variantValues;
  final String? attrName;
  final String? imageSm;
  final String? imageMd;
  final String? isAlreadyReturned;
  final String? isAlreadyCancelled;
  final String? returnRequestSubmitted;
  final String? shiprocketOrderTrackingUrl;
  final String? email;
  final String isConsignmentCreated;

  OrderItem copyWith({
    String? id,
    String? userId,
    String? orderId,
    String? deliveryBoyId,
    String? sellerId,
    String? isCredited,
    dynamic otp,
    String? productName,
    String? variantName,
    String? productVariantId,
    String? quantity,
    String? price,
    String? discountedPrice,
    String? taxIds,
    String? taxPercent,
    num? taxAmount,
    String? discount,
    String? subTotal,
    String? deliverBy,
    String? updatedBy,
    List<List<String>>? status,
    String? adminCommissionAmount,
    String? sellerCommissionAmount,
    String? activeStatus,
    dynamic hashLink,
    String? isSent,
    DateTime? dateAdded,
    String? deliveredQuantity,
    String? productId,
    String? isCancelable,
    String? isPricesInclusiveTax,
    String? cancelableTill,
    String? type,
    String? slug,
    String? downloadAllowed,
    String? downloadLink,
    String? storeName,
    String? sellerLongitude,
    String? sellerMobile,
    String? sellerAddress,
    String? sellerLatitude,
    String? deliveryBoyName,
    String? storeDescription,
    String? sellerRating,
    String? sellerProfile,
    String? courierAgency,
    String? trackingId,
    dynamic awbCode,
    String? url,
    String? sellerName,
    String? isReturnable,
    String? specialPrice,
    String? mainPrice,
    String? image,
    String? name,
    String? pickupLocation,
    String? weight,
    String? sellerNoOfRatings,
    String? productRating,
    String? userRating,
    List<dynamic>? userRatingImages,
    String? userRatingComment,
    String? orderCounter,
    String? orderCancelCounter,
    String? orderReturnCounter,
    num? netAmount,
    String? varaintIds,
    String? variantValues,
    String? attrName,
    String? imageSm,
    String? imageMd,
    String? isAlreadyReturned,
    String? isAlreadyCancelled,
    String? returnRequestSubmitted,
    String? shiprocketOrderTrackingUrl,
    String? email,
    String? isConsignmentCreated,
  }) {
    return OrderItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      deliveryBoyId: deliveryBoyId ?? this.deliveryBoyId,
      sellerId: sellerId ?? this.sellerId,
      isCredited: isCredited ?? this.isCredited,
      otp: otp ?? this.otp,
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      productVariantId: productVariantId ?? this.productVariantId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      taxIds: taxIds ?? this.taxIds,
      taxPercent: taxPercent ?? this.taxPercent,
      taxAmount: taxAmount ?? this.taxAmount,
      discount: discount ?? this.discount,
      subTotal: subTotal ?? this.subTotal,
      deliverBy: deliverBy ?? this.deliverBy,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
      adminCommissionAmount:
          adminCommissionAmount ?? this.adminCommissionAmount,
      sellerCommissionAmount:
          sellerCommissionAmount ?? this.sellerCommissionAmount,
      activeStatus: activeStatus ?? this.activeStatus,
      hashLink: hashLink ?? this.hashLink,
      isSent: isSent ?? this.isSent,
      dateAdded: dateAdded ?? this.dateAdded,
      deliveredQuantity: deliveredQuantity ?? this.deliveredQuantity,
      productId: productId ?? this.productId,
      isCancelable: isCancelable ?? this.isCancelable,
      isPricesInclusiveTax: isPricesInclusiveTax ?? this.isPricesInclusiveTax,
      cancelableTill: cancelableTill ?? this.cancelableTill,
      type: type ?? this.type,
      slug: slug ?? this.slug,
      downloadAllowed: downloadAllowed ?? this.downloadAllowed,
      downloadLink: downloadLink ?? this.downloadLink,
      storeName: storeName ?? this.storeName,
      sellerLongitude: sellerLongitude ?? this.sellerLongitude,
      sellerMobile: sellerMobile ?? this.sellerMobile,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      sellerLatitude: sellerLatitude ?? this.sellerLatitude,
      deliveryBoyName: deliveryBoyName ?? this.deliveryBoyName,
      storeDescription: storeDescription ?? this.storeDescription,
      sellerRating: sellerRating ?? this.sellerRating,
      sellerProfile: sellerProfile ?? this.sellerProfile,
      courierAgency: courierAgency ?? this.courierAgency,
      trackingId: trackingId ?? this.trackingId,
      awbCode: awbCode ?? this.awbCode,
      url: url ?? this.url,
      sellerName: sellerName ?? this.sellerName,
      isReturnable: isReturnable ?? this.isReturnable,
      specialPrice: specialPrice ?? this.specialPrice,
      mainPrice: mainPrice ?? this.mainPrice,
      image: image ?? this.image,
      name: name ?? this.name,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      weight: weight ?? this.weight,
      sellerNoOfRatings: sellerNoOfRatings ?? this.sellerNoOfRatings,
      productRating: productRating ?? this.productRating,
      userRating: userRating ?? this.userRating,
      userRatingImages: userRatingImages ?? this.userRatingImages,
      userRatingComment: userRatingComment ?? this.userRatingComment,
      orderCounter: orderCounter ?? this.orderCounter,
      orderCancelCounter: orderCancelCounter ?? this.orderCancelCounter,
      orderReturnCounter: orderReturnCounter ?? this.orderReturnCounter,
      netAmount: netAmount ?? this.netAmount,
      varaintIds: varaintIds ?? this.varaintIds,
      variantValues: variantValues ?? this.variantValues,
      attrName: attrName ?? this.attrName,
      imageSm: imageSm ?? this.imageSm,
      imageMd: imageMd ?? this.imageMd,
      isAlreadyReturned: isAlreadyReturned ?? this.isAlreadyReturned,
      isAlreadyCancelled: isAlreadyCancelled ?? this.isAlreadyCancelled,
      returnRequestSubmitted:
          returnRequestSubmitted ?? this.returnRequestSubmitted,
      shiprocketOrderTrackingUrl:
          shiprocketOrderTrackingUrl ?? this.shiprocketOrderTrackingUrl,
      email: email ?? this.email,
      isConsignmentCreated: isConsignmentCreated ?? this.isConsignmentCreated,
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"].toString(),
      isConsignmentCreated: json["is_consignment_created"].toString(),
      userId: json["user_id"].toString(),
      orderId: json["order_id"].toString(),
      deliveryBoyId: json["delivery_boy_id"].toString(),
      sellerId: json["seller_id"].toString(),
      isCredited: json["is_credited"].toString(),
      otp: json["otp"].toString(),
      productName: json["product_name"].toString(),
      variantName: json["variant_name"].toString(),
      productVariantId: json["product_variant_id"].toString(),
      quantity: json["quantity"].toString(),
      price: json["price"].toString(),
      discountedPrice: json["discounted_price"].toString(),
      taxIds: json["tax_ids"].toString(),
      taxPercent: json["tax_percent"].toString(),
      taxAmount:
          num.tryParse(json["tax_amount"].toString()) ?? json["tax_amount"],
      discount: json["discount"],
      subTotal: json["sub_total"],
      deliverBy: json["deliver_by"],
      updatedBy: json["updated_by"],
      status: json["status"],
      adminCommissionAmount: json["admin_commission_amount"],
      sellerCommissionAmount: json["seller_commission_amount"],
      activeStatus: json["active_status"],
      hashLink: json["hash_link"],
      isSent: json["is_sent"],
      dateAdded: DateTime.tryParse(json["date_added"] ?? ""),
      deliveredQuantity: json["delivered_quantity"],
      productId: json["product_id"],
      isCancelable: json["is_cancelable"],
      isPricesInclusiveTax: json["is_prices_inclusive_tax"],
      cancelableTill: json["cancelable_till"],
      type: json["type"],
      slug: json["slug"],
      downloadAllowed: json["download_allowed"],
      downloadLink: json["download_link"],
      storeName: json["store_name"],
      sellerLongitude: json["seller_longitude"],
      sellerMobile: json["seller_mobile"],
      sellerAddress: json["seller_address"],
      sellerLatitude: json["seller_latitude"],
      deliveryBoyName: json["delivery_boy_name"],
      storeDescription: json["store_description"],
      sellerRating: json["seller_rating"],
      sellerProfile: json["seller_profile"],
      courierAgency: json["courier_agency"],
      trackingId: json["tracking_id"],
      awbCode: json["awb_code"],
      url: json["url"],
      sellerName: json["seller_name"],
      isReturnable: json["is_returnable"],
      specialPrice: json["special_price"],
      mainPrice: json["main_price"],
      image: json["image"],
      name: json["name"],
      pickupLocation: json["pickup_location"],
      weight: json["weight"],
      sellerNoOfRatings: json["seller_no_of_ratings"],
      productRating: json["product_rating"],
      userRating: json["user_rating"],
      userRatingImages: json["user_rating_images"] == null
          ? []
          : List<dynamic>.from(json["user_rating_images"]!.map((x) => x)),
      userRatingComment: json["user_rating_comment"],
      orderCounter: json["order_counter"],
      orderCancelCounter: json["order_cancel_counter"],
      orderReturnCounter: json["order_return_counter"],
      netAmount: json["net_amount"],
      varaintIds: json["varaint_ids"],
      variantValues: json["variant_values"],
      attrName: json["attr_name"],
      imageSm: json["image_sm"],
      imageMd: json["image_md"],
      isAlreadyReturned: json["is_already_returned"],
      isAlreadyCancelled: json["is_already_cancelled"],
      returnRequestSubmitted: json["return_request_submitted"],
      shiprocketOrderTrackingUrl: json["shiprocket_order_tracking_url"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "delivery_boy_id": deliveryBoyId,
        "seller_id": sellerId,
        "is_credited": isCredited,
        "otp": otp,
        "product_name": productName,
        "variant_name": variantName,
        "product_variant_id": productVariantId,
        "quantity": quantity,
        "price": price,
        "discounted_price": discountedPrice,
        "tax_ids": taxIds,
        "tax_percent": taxPercent,
        "tax_amount": taxAmount,
        "discount": discount,
        "sub_total": subTotal,
        "deliver_by": deliverBy,
        "updated_by": updatedBy,
        "status": status.map((x) => x.map((x) => x).toList()).toList(),
        "admin_commission_amount": adminCommissionAmount,
        "seller_commission_amount": sellerCommissionAmount,
        "active_status": activeStatus,
        "hash_link": hashLink,
        "is_sent": isSent,
        "date_added": dateAdded?.toIso8601String(),
        "delivered_quantity": deliveredQuantity,
        "product_id": productId,
        "is_cancelable": isCancelable,
        "is_prices_inclusive_tax": isPricesInclusiveTax,
        "cancelable_till": cancelableTill,
        "type": type,
        "slug": slug,
        "download_allowed": downloadAllowed,
        "download_link": downloadLink,
        "store_name": storeName,
        "seller_longitude": sellerLongitude,
        "seller_mobile": sellerMobile,
        "seller_address": sellerAddress,
        "seller_latitude": sellerLatitude,
        "delivery_boy_name": deliveryBoyName,
        "store_description": storeDescription,
        "seller_rating": sellerRating,
        "seller_profile": sellerProfile,
        "courier_agency": courierAgency,
        "tracking_id": trackingId,
        "awb_code": awbCode,
        "url": url,
        "seller_name": sellerName,
        "is_returnable": isReturnable,
        "special_price": specialPrice,
        "main_price": mainPrice,
        "image": image,
        "name": name,
        "pickup_location": pickupLocation,
        "weight": weight,
        "seller_no_of_ratings": sellerNoOfRatings,
        "product_rating": productRating,
        "user_rating": userRating,
        "user_rating_images": userRatingImages.map((x) => x).toList(),
        "user_rating_comment": userRatingComment,
        "order_counter": orderCounter,
        "order_cancel_counter": orderCancelCounter,
        "order_return_counter": orderReturnCounter,
        "net_amount": netAmount,
        "varaint_ids": varaintIds,
        "variant_values": variantValues,
        "attr_name": attrName,
        "image_sm": imageSm,
        "image_md": imageMd,
        "is_already_returned": isAlreadyReturned,
        "is_already_cancelled": isAlreadyCancelled,
        "return_request_submitted": returnRequestSubmitted,
        "shiprocket_order_tracking_url": shiprocketOrderTrackingUrl,
        "email": email,
        "is_consignment_created": isConsignmentCreated
      };

  factory OrderItem.fromConsignment(ConsignmentItem item) {
    return OrderItem.fromJson({
      'name': item.productName,
      'price': item.price,
      'quantity': item.quantity,
      'image': item.image,
      "type": item.type,
      "variant_values": item.variantValues,
    });
  }
  @override
  String toString() {
    return 'OrderItem(id: $id, userId: $userId, orderId: $orderId, deliveryBoyId: $deliveryBoyId, sellerId: $sellerId, isCredited: $isCredited, otp: $otp, productName: $productName, variantName: $variantName, productVariantId: $productVariantId, quantity: $quantity, price: $price, discountedPrice: $discountedPrice, taxIds: $taxIds, taxPercent: $taxPercent, taxAmount: $taxAmount, discount: $discount, subTotal: $subTotal, deliverBy: $deliverBy, updatedBy: $updatedBy, status: $status, adminCommissionAmount: $adminCommissionAmount, sellerCommissionAmount: $sellerCommissionAmount, activeStatus: $activeStatus, hashLink: $hashLink, isSent: $isSent, dateAdded: $dateAdded, deliveredQuantity: $deliveredQuantity, productId: $productId, isCancelable: $isCancelable, isPricesInclusiveTax: $isPricesInclusiveTax, cancelableTill: $cancelableTill, type: $type, slug: $slug, downloadAllowed: $downloadAllowed, downloadLink: $downloadLink, storeName: $storeName, sellerLongitude: $sellerLongitude, sellerMobile: $sellerMobile, sellerAddress: $sellerAddress, sellerLatitude: $sellerLatitude, deliveryBoyName: $deliveryBoyName, storeDescription: $storeDescription, sellerRating: $sellerRating, sellerProfile: $sellerProfile, courierAgency: $courierAgency, trackingId: $trackingId, awbCode: $awbCode, url: $url, sellerName: $sellerName, isReturnable: $isReturnable, specialPrice: $specialPrice, mainPrice: $mainPrice, image: $image, name: $name, pickupLocation: $pickupLocation, weight: $weight, sellerNoOfRatings: $sellerNoOfRatings, productRating: $productRating, userRating: $userRating, userRatingImages: $userRatingImages, userRatingComment: $userRatingComment, orderCounter: $orderCounter, orderCancelCounter: $orderCancelCounter, orderReturnCounter: $orderReturnCounter, netAmount: $netAmount, varaintIds: $varaintIds, variantValues: $variantValues, attrName: $attrName, imageSm: $imageSm, imageMd: $imageMd, isAlreadyReturned: $isAlreadyReturned, isAlreadyCancelled: $isAlreadyCancelled, returnRequestSubmitted: $returnRequestSubmitted, shiprocketOrderTrackingUrl: $shiprocketOrderTrackingUrl, email: $email)';
  }
}
