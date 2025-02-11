class DeliveryBoy {
  String id;
  String name;

  DeliveryBoy({
    required this.id,
    required this.name,
  });

  factory DeliveryBoy.fromMap(Map<String, dynamic> map) {
    return DeliveryBoy(
      id: map['id'].toString(),
      name: map['name'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
