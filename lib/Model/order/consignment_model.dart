class ConsignmentModel {
  String id;
  String username;
  String email;
  String mobile;
  String orderId;
  String name;
  String longitude;
  String latitude;
  String createdDate;
  String otp;
  String sellerId;
  String paymentMethod;
  String userAddress;
  String total;
  String deliveryCharge;
  String deliveryBoyId;
  String walletBalance;
  String discount;
  String taxPercent;
  String taxAmount;
  String promoDiscount;
  String totalPayable;
  String finalTotal;
  String notes;
  String deliveryDate;
  String deliveryTime;
  String isCodCollected;
  String isShiprocketOrder;
  String activeStatus;
  dynamic status;
  String isShiprocketOrderCreated;
  List<ConsignmentItem> consignmentItems;
  SellerDetails sellerDetails;
  TrackingDetails? trackingDetails;

  ConsignmentModel({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.orderId,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.createdDate,
    required this.otp,
    required this.sellerId,
    required this.paymentMethod,
    required this.userAddress,
    required this.total,
    required this.deliveryCharge,
    required this.deliveryBoyId,
    required this.walletBalance,
    required this.discount,
    required this.taxPercent,
    required this.taxAmount,
    required this.promoDiscount,
    required this.totalPayable,
    required this.finalTotal,
    required this.notes,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.isCodCollected,
    required this.isShiprocketOrder,
    required this.activeStatus,
    required this.status,
    required this.consignmentItems,
    required this.sellerDetails,
    required this.trackingDetails,
    required this.isShiprocketOrderCreated,
  });

  bool get isShiprocketConsignmentBool => isShiprocketOrder == '1';

  bool get isShiprocketOrderCreatedBool => isShiprocketOrderCreated == '1';

  //for updating in multiple screens
  void changeValues(ConsignmentModel consignment) {
    id = consignment.id;
    username = consignment.username;
    email = consignment.email;
    mobile = consignment.mobile;
    orderId = consignment.orderId;
    name = consignment.name;
    longitude = consignment.longitude;
    latitude = consignment.latitude;
    createdDate = consignment.createdDate;
    otp = consignment.otp;
    sellerId = consignment.sellerId;
    paymentMethod = consignment.paymentMethod;
    userAddress = consignment.userAddress;
    total = consignment.total;
    deliveryCharge = consignment.deliveryCharge;
    deliveryBoyId = consignment.deliveryBoyId;
    walletBalance = consignment.walletBalance;
    discount = consignment.discount;
    taxPercent = consignment.taxPercent;
    taxAmount = consignment.taxAmount;
    promoDiscount = consignment.promoDiscount;
    totalPayable = consignment.totalPayable;
    finalTotal = consignment.finalTotal;
    notes = consignment.notes;
    deliveryDate = consignment.deliveryDate;
    deliveryTime = consignment.deliveryTime;
    isCodCollected = consignment.isCodCollected;
    isShiprocketOrder = consignment.isShiprocketOrder;
    activeStatus = consignment.activeStatus;
    status = consignment.status;
    consignmentItems = consignment.consignmentItems;
    sellerDetails = consignment.sellerDetails;
    trackingDetails = consignment.trackingDetails;
    isShiprocketOrderCreated = consignment.isShiprocketOrderCreated;
  }

  factory ConsignmentModel.fromMap(Map<String, dynamic> map) {
    return ConsignmentModel(
      id: map['id'].toString(),
      username: map['username'].toString(),
      email: map['email'].toString(),
      mobile: map['mobile'].toString(),
      orderId: map['order_id'].toString(),
      name: map['name'].toString(),
      longitude: map['longitude'].toString(),
      latitude: map['latitude'].toString(),
      createdDate: map['created_date'].toString(),
      otp: map['otp'].toString(),
      sellerId: map['seller_id'].toString(),
      paymentMethod: map['payment_method'].toString(),
      userAddress: map['user_address'].toString(),
      total: map['total'].toString(),
      deliveryCharge: map['delivery_charge'].toString(),
      deliveryBoyId: map['delivery_boy_id'].toString(),
      walletBalance: map['wallet_balance'].toString(),
      discount: map['discount'].toString(),
      taxPercent: map['tax_percent'].toString(),
      taxAmount: map['tax_amount'].toString(),
      promoDiscount: map['promo_discount'].toString(),
      totalPayable: map['total_payable'].toString(),
      finalTotal: map['final_total'].toString(),
      notes: map['notes'].toString(),
      deliveryDate: map['delivery_date'].toString(),
      deliveryTime: map['delivery_time'].toString(),
      isCodCollected: map['is_cod_collected'].toString(),
      isShiprocketOrder: map['is_shiprocket_order'].toString(),
      activeStatus: map['active_status'].toString(),
      isShiprocketOrderCreated: map['is_shiprocket_order_created'].toString(),
      status: List.from(map['status'] ?? []),
      consignmentItems: List<ConsignmentItem>.from(
          map['consignment_items']?.map((x) => ConsignmentItem.fromMap(x)) ??
              {}),
      sellerDetails: SellerDetails.fromMap(map['seller_details'] ?? {}),
      trackingDetails: map['tracking_details'] == null
          ? null
          : TrackingDetails.fromMap(map['tracking_details'] ?? {}),
    );
  }
}

class SellerDetails {
  String storeName;
  String sellerName;
  String address;
  String mobile;
  String storeImage;
  String latitude;
  String longitude;

  SellerDetails({
    required this.storeName,
    required this.sellerName,
    required this.address,
    required this.mobile,
    required this.storeImage,
    required this.latitude,
    required this.longitude,
  });

  factory SellerDetails.fromMap(Map<String, dynamic> map) {
    return SellerDetails(
      storeName: map['store_name'].toString(),
      sellerName: map['seller_name'].toString(),
      address: map['address'].toString(),
      mobile: map['mobile'].toString(),
      storeImage: map['store_image'].toString(),
      latitude: map['latitude'].toString(),
      longitude: map['longitude'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'store_name': storeName,
      'seller_name': sellerName,
      'address': address,
      'mobile': mobile,
      'store_image': storeImage,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class ConsignmentItem {
  String id;
  String productVariantId;
  String orderItemId;
  String unitPrice;
  String quantity;
  String isCredited;
  String productName;
  String variantName;
  String price;
  String discountedPrice;
  String taxIds;
  String taxPercent;
  String taxAmount;
  String discount;
  String subTotal;
  String deliverBy;
  String updatedBy;
  String isSent;
  String dateAdded;
  String deliveredQuantity;
  String isCancelable;
  String isReturnable;
  String image;
  String type;
  String subtotalOfOrderItems;
  String notes;
  String deliveryDate;
  String deliveryTime;
  String isCodCollected;
  String isShiprocketOrder;
  String pickupLocation;
  String sku;
  String productSlug;
  String variantIds;
  String variantValues;
  String attrName;
  String imageSm;
  String imageMd;
  String isAlreadyReturned;
  String isAlreadyCancelled;
  String returnRequestSubmitted;

  ConsignmentItem({
    required this.id,
    required this.productVariantId,
    required this.orderItemId,
    required this.unitPrice,
    required this.quantity,
    required this.isCredited,
    required this.productName,
    required this.variantName,
    required this.price,
    required this.discountedPrice,
    required this.taxIds,
    required this.taxPercent,
    required this.taxAmount,
    required this.discount,
    required this.subTotal,
    required this.deliverBy,
    required this.updatedBy,
    required this.isSent,
    required this.dateAdded,
    required this.deliveredQuantity,
    required this.isCancelable,
    required this.isReturnable,
    required this.image,
    required this.type,
    required this.subtotalOfOrderItems,
    required this.notes,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.isCodCollected,
    required this.isShiprocketOrder,
    required this.pickupLocation,
    required this.sku,
    required this.productSlug,
    required this.variantIds,
    required this.variantValues,
    required this.attrName,
    required this.imageSm,
    required this.imageMd,
    required this.isAlreadyReturned,
    required this.isAlreadyCancelled,
    required this.returnRequestSubmitted,
  });

  factory ConsignmentItem.fromMap(Map<String, dynamic> map) {
    return ConsignmentItem(
      id: map['id'].toString(),
      productVariantId: map['product_variant_id'].toString(),
      orderItemId: map['order_item_id'].toString(),
      unitPrice: map['unit_price'].toString(),
      quantity: map['quantity'].toString(),
      isCredited: map['is_credited'].toString(),
      productName: map['product_name'].toString(),
      variantName: map['variant_name'].toString(),
      price: map['price'].toString(),
      discountedPrice: map['discounted_price'].toString(),
      taxIds: map['tax_ids'].toString(),
      taxPercent: map['tax_percent']?.toString() ?? '',
      taxAmount: map['tax_amount'].toString(),
      discount: map['discount'].toString(),
      subTotal: map['sub_total'].toString(),
      deliverBy: map['deliver_by'].toString(),
      updatedBy: map['updated_by'].toString(),
      isSent: map['is_sent'].toString(),
      dateAdded: map['date_added'].toString(),
      deliveredQuantity: map['delivered_quantity'].toString(),
      isCancelable: map['is_cancelable'].toString(),
      isReturnable: map['is_returnable'].toString(),
      image: map['image'].toString(),
      type: map['type'].toString(),
      subtotalOfOrderItems: map['subtotal_of_order_items'].toString(),
      notes: map['notes'].toString(),
      deliveryDate: map['delivery_date'].toString(),
      deliveryTime: map['delivery_time'].toString(),
      isCodCollected: map['is_cod_collected'].toString(),
      isShiprocketOrder: map['is_shiprocket_order'].toString(),
      pickupLocation: map['pickup_location'].toString(),
      sku: map['sku']?.toString() ?? '',
      productSlug: map['product_slug'].toString(),
      variantIds: map['varaint_ids'].toString(),
      variantValues: map['variant_values'].toString(),
      attrName: map['attr_name'].toString(),
      imageSm: map['image_sm'].toString(),
      imageMd: map['image_md'].toString(),
      isAlreadyReturned: map['is_already_returned'].toString(),
      isAlreadyCancelled: map['is_already_cancelled'].toString(),
      returnRequestSubmitted: map['return_request_submitted'].toString(),
    );
  }
}

//for shiprocket and local tracking
class TrackingDetails {
  String? id;
  String? orderId;
  String? shiprocketOrderId;
  String? shipmentId;
  String? courierCompanyId;
  String? awbCode;
  String? pickupStatus;
  String? pickupScheduledDate;
  String? pickupTokenNumber;
  String? status;
  String? others;
  String? pickupGeneratedDate;
  String? data;
  String? date;
  String? isCanceled;
  String? manifestUrl;
  String? labelUrl;
  String? invoiceUrl;
  String? orderItemId;
  String? courierAgency;
  String? trackingId;
  String? url;
  String? dateCreated;
  String? consignmentId;

  TrackingDetails({
    this.id,
    this.orderId,
    this.shiprocketOrderId,
    this.shipmentId,
    this.courierCompanyId,
    this.awbCode,
    this.pickupStatus,
    this.pickupScheduledDate,
    this.pickupTokenNumber,
    this.status,
    this.others,
    this.pickupGeneratedDate,
    this.data,
    this.date,
    this.isCanceled,
    this.manifestUrl,
    this.labelUrl,
    this.invoiceUrl,
    this.orderItemId,
    this.courierAgency,
    this.trackingId,
    this.url,
    this.dateCreated,
    this.consignmentId,
  });

  factory TrackingDetails.fromMap(Map<String, dynamic> map) {
    return TrackingDetails(
      id: map['id']?.toString(),
      orderId: map['order_id']?.toString(),
      shiprocketOrderId: map['shiprocket_order_id']?.toString(),
      shipmentId: map['shipment_id']?.toString(),
      courierCompanyId: map['courier_company_id']?.toString(),
      awbCode: map['awb_code']?.toString(),
      pickupStatus: map['pickup_status']?.toString(),
      pickupScheduledDate: map['pickup_scheduled_date']?.toString(),
      pickupTokenNumber: map['pickup_token_number']?.toString(),
      status: map['status']?.toString(),
      others: map['others']?.toString(),
      pickupGeneratedDate: map['pickup_generated_date']?.toString(),
      data: map['data']?.toString(),
      date: map['date']?.toString(),
      isCanceled: map['is_canceled']?.toString(),
      manifestUrl: map['manifest_url']?.toString(),
      labelUrl: map['label_url']?.toString(),
      invoiceUrl: map['invoice_url']?.toString(),
      orderItemId: map['order_item_id']?.toString(),
      courierAgency: map['courier_agency']?.toString(),
      trackingId: map['tracking_id']?.toString(),
      url: map['url']?.toString(),
      dateCreated: map['date_created']?.toString(),
      consignmentId: map['consignment_id']?.toString(),
    );
  }
}
