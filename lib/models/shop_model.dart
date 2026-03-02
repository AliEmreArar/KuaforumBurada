class ShopService {
  String name;
  double price;

  ShopService({required this.name, required this.price});

  Map<String, dynamic> toJson() => {'name': name, 'price': price};

  factory ShopService.fromJson(Map<String, dynamic> json) {
    return ShopService(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class OperatingHours {
  String day;
  String start;
  String end;
  bool isOpen;

  OperatingHours({
    required this.day,
    this.start = '09:00',
    this.end = '18:00',
    this.isOpen = true,
  });

  Map<String, dynamic> toJson() => {
        'day': day,
        'start': start,
        'end': end,
        'isOpen': isOpen,
      };

  factory OperatingHours.fromJson(Map<String, dynamic> json) {
    return OperatingHours(
      day: json['day'],
      start: json['start'],
      end: json['end'],
      isOpen: json['isOpen'],
    );
  }
}

class ShopProfile {
  String id;
  String shopName; // Immutable
  String legalOwnerName;
  String taxId;
  String location;
  String phoneNumber;
  String email;
  String password; // Hashed in real app
  String category;
  int employeeCount;
  List<OperatingHours> operatingHours;
  List<ShopService> services;
  List<String> photoUrls;

  ShopProfile({
    required this.id,
    required this.shopName,
    required this.legalOwnerName,
    required this.taxId,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.category,
    required this.employeeCount,
    required this.operatingHours,
    required this.services,
    required this.photoUrls,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'shopName': shopName,
        'legalOwnerName': legalOwnerName,
        'taxId': taxId,
        'location': location,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'category': category,
        'employeeCount': employeeCount,
        'operatingHours': operatingHours.map((e) => e.toJson()).toList(),
        'services': services.map((e) => e.toJson()).toList(),
        'photoUrls': photoUrls,
      };

  factory ShopProfile.fromJson(Map<String, dynamic> json) {
    return ShopProfile(
      id: json['id'],
      shopName: json['shopName'],
      legalOwnerName: json['legalOwnerName'],
      taxId: json['taxId'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      category: json['category'] ?? 'Kuaför', // Default to Kuaför
      employeeCount: json['employeeCount'],
      operatingHours: (json['operatingHours'] as List)
          .map((e) => OperatingHours.fromJson(e))
          .toList(),
      services: (json['services'] as List)
          .map((e) => ShopService.fromJson(e))
          .toList(),
      photoUrls: List<String>.from(json['photoUrls']),
    );
  }
}
