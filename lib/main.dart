import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'models/shop_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('tr_TR', null).then((_) {
    runApp(const KuaforSepetiApp());
  });
}

// --- Models ---

class Service {
  final String id;
  final String name;
  final String category;
  final double price;
  final int durationMinutes;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.durationMinutes,
  });
}

class Hairdresser {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> imageUrls;
  final double rating;
  final String location;
  final String district;
  final String category;
  final String businessType; // 'Kuaför', 'Hayvan Kuaförü', 'Güzellik Salonu'
  final List<Service> services;

  Hairdresser({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.rating,
    required this.location,
    required this.district,
    required this.category,
    this.businessType = 'Kuaför',
    required this.services,
  });
}

class CartItem {
  final String id;
  final Hairdresser hairdresser;
  final Service service;
  final DateTime date;
  final String time;

  CartItem({
    String? id,
    required this.hairdresser,
    required this.service,
    required this.date,
    required this.time,
  }) : id = id ?? const Uuid().v4();
}

class Appointment {
  final String id;
  final Hairdresser hairdresser;
  final Service service;
  final DateTime date;
  final String time;
  final String status; // 'Aktif', 'Tamamlandı', 'İptal Edildi'

  Appointment({
    required this.id,
    required this.hairdresser,
    required this.service,
    required this.date,
    required this.time,
    this.status = 'Aktif',
  });
}

class Campaign {
  final String id;
  final String title;
  final String description;
  final String code;
  final double discountAmount;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountAmount,
  });
}

class UserProfile {
  String name;
  String surname;
  String phone;
  String address;
  String email;
  String password;
  String creditCardNumber;
  String profilePhotoUrl;

  UserProfile({
    this.name = '',
    this.surname = '',
    this.phone = '',
    this.address = '',
    this.email = '',
    this.password = '',
    this.creditCardNumber = '',
    this.profilePhotoUrl = '',
    this.addresses = const [],
  });

  List<String> addresses;

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'phone': phone,
        'address': address,
        'email': email,
        'password': password,
        'creditCardNumber': creditCardNumber,
        'profilePhotoUrl': profilePhotoUrl,
        'addresses': addresses,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      creditCardNumber: json['creditCardNumber'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      addresses: List<String>.from(json['addresses'] ?? []),
    );
  }
}

// --- State Management ---

class AppState extends ChangeNotifier {
  AppState() {
    _loadData();
  }

  UserProfile userProfile = UserProfile();
  final List<UserProfile> _registeredUsers = []; // Mock Database

  bool register(String name, String surname, String address, String email,
      String password) {
    if (_registeredUsers.any((u) => u.email == email)) {
      return false;
    }
    final newUser = UserProfile(
      name: name,
      surname: surname,
      address: address, // Set primary address
      email: email,
      password: password,
      addresses: [address], // Initialize list with primary address
    );
    _registeredUsers.add(newUser);
    _saveData();
    return true;
  }

  bool login(String email, String password) {
    try {
      final user = _registeredUsers
          .firstWhere((u) => u.email == email && u.password == password);
      userProfile = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    userProfile = UserProfile(); // Reset
    notifyListeners();
  }

  void addAddress(String newAddress) {
    if (!userProfile.addresses.contains(newAddress)) {
      userProfile.addresses.add(newAddress);
      userProfile.address = newAddress; // Set as current
      _saveData();
      notifyListeners();
    }
  }

  void updateCurrentAddress(String address) {
    if (userProfile.addresses.contains(address)) {
      userProfile.address = address;
      notifyListeners();
    }
  }

  // --- Shop Management ---
  ShopProfile? currentShop;
  final List<ShopProfile> _registeredShops = [];

  bool registerShop(ShopProfile shop) {
    if (_registeredShops.any((s) => s.email == shop.email)) {
      return false;
    }
    _registeredShops.add(shop);
    _saveData();
    return true;
  }

  bool loginShop(String email, String password) {
    try {
      final shop = _registeredShops
          .firstWhere((s) => s.email == email && s.password == password);
      currentShop = shop;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logoutShop() {
    currentShop = null;
    notifyListeners();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Users
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      final List<dynamic> decoded = jsonDecode(usersJson);
      _registeredUsers.clear();
      _registeredUsers.addAll(decoded.map((e) => UserProfile.fromJson(e)));
    }

    // Load Shops
    final shopsJson = prefs.getString('shops');
    if (shopsJson != null) {
      final List<dynamic> decoded = jsonDecode(shopsJson);
      _registeredShops.clear();
      _registeredShops.addAll(decoded.map((e) => ShopProfile.fromJson(e)));
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'users', jsonEncode(_registeredUsers.map((e) => e.toJson()).toList()));
    prefs.setString(
        'shops', jsonEncode(_registeredShops.map((e) => e.toJson()).toList()));
  }

  List<Hairdresser> get allHairdressers {
    final shopHairdressers = _registeredShops
        .map((shop) => Hairdresser(
              id: shop.id,
              name: shop.shopName,
              imageUrl: shop.photoUrls.isNotEmpty
                  ? shop.photoUrls.first
                  : 'https://images.unsplash.com/photo-1521590832896-76c0f2956662?w=800',
              imageUrls: shop.photoUrls.isNotEmpty
                  ? shop.photoUrls
                  : [
                      'https://images.unsplash.com/photo-1521590832896-76c0f2956662?w=800'
                    ],
              rating: 5.0,
              location: shop.location,
              district: 'Merkez',
              category: shop.category,
              services: shop.services
                  .map((s) => Service(
                      id: const Uuid().v4(),
                      name: s.name,
                      category: 'Genel',
                      price: s.price,
                      durationMinutes: 30))
                  .toList(),
            ))
        .toList();

    return [...hairdressers, ...shopHairdressers];
  }

  List<CartItem> cartItems = [];
  List<Appointment> appointments = [];
  List<Campaign> campaigns = [
    Campaign(
        id: '1',
        title: 'Hoşgeldin İndirimi',
        description: 'İlk siparişine özel 50 TL indirim',
        code: 'MERHABA50',
        discountAmount: 50),
    Campaign(
        id: '2',
        title: 'Yaz Fırsatı',
        description: 'Tüm hizmetlerde 20 TL indirim',
        code: 'YAZ20',
        discountAmount: 20),
  ];

  double? appliedDiscount;
  String? appliedCouponCode;

  // Mock Data
  final List<Hairdresser> hairdressers = [
    // === KUAFÖR (Hairdressers) ===
    Hairdresser(
      id: '1',
      name: 'Erkek Berberi Ali Usta',
      imageUrl:
          'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=800',
      rating: 4.8,
      location: 'Kadıköy',
      district: 'Moda',
      category: 'Erkek',
      businessType: 'Kuaför',
      services: [
        Service(
            id: 's1',
            name: 'Saç Kesimi',
            category: 'Saç',
            price: 250,
            durationMinutes: 30),
        Service(
            id: 's2',
            name: 'Sakal Tıraşı',
            category: 'Sakal',
            price: 150,
            durationMinutes: 20),
        Service(
            id: 's3',
            name: 'Saç Yıkama',
            category: 'Bakım',
            price: 50,
            durationMinutes: 10),
      ],
    ),
    Hairdresser(
      id: '2',
      name: 'Kadın Kuaförü Ayşe',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
      rating: 4.9,
      location: 'Beşiktaş',
      district: 'Ortaköy',
      category: 'Kadın',
      businessType: 'Kuaför',
      services: [
        Service(
            id: 's4',
            name: 'Saç Kesimi',
            category: 'Saç',
            price: 400,
            durationMinutes: 45),
        Service(
            id: 's5',
            name: 'Boya',
            category: 'Renklendirme',
            price: 800,
            durationMinutes: 120),
        Service(
            id: 's6',
            name: 'Fön',
            category: 'Şekillendirme',
            price: 200,
            durationMinutes: 30),
      ],
    ),
    Hairdresser(
      id: 'k1',
      name: 'Çocuk Kuaförü Minikler',
      imageUrl:
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=800',
      rating: 4.7,
      location: 'Ataşehir',
      district: 'Meydan',
      category: 'Çocuk',
      businessType: 'Kuaför',
      services: [
        Service(
            id: 'ck1',
            name: 'Çocuk Saç Kesimi',
            category: 'Saç',
            price: 150,
            durationMinutes: 25),
      ],
    ),

    // === HAYVAN KUAFÖRÜ (Pet Groomers) ===
    Hairdresser(
      id: 'h1',
      name: 'Pet Grooming Center',
      imageUrl:
          'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=800',
      rating: 4.9,
      location: 'Kadıköy',
      district: 'Bostancı',
      category: 'Köpek',
      businessType: 'Hayvan Kuaförü',
      services: [
        Service(
            id: 'h1s1',
            name: 'Köpek Tıraşı',
            category: 'Tıraş',
            price: 350,
            durationMinutes: 60),
        Service(
            id: 'h1s2',
            name: 'Köpek Yıkama',
            category: 'Yıkama',
            price: 200,
            durationMinutes: 45),
        Service(
            id: 'h1s3',
            name: 'Tırnak Kesimi',
            category: 'Bakım',
            price: 100,
            durationMinutes: 20),
      ],
    ),
    Hairdresser(
      id: 'h2',
      name: 'Veteriner Kliniği & Pet Spa',
      imageUrl:
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      rating: 4.8,
      location: 'Beşiktaş',
      district: 'Yıldız',
      category: 'Kedi & Köpek',
      businessType: 'Hayvan Kuaförü',
      services: [
        Service(
            id: 'h2s1',
            name: 'Genel Muayene',
            category: 'Sağlık',
            price: 300,
            durationMinutes: 30),
        Service(
            id: 'h2s2',
            name: 'Aşı Uygulaması',
            category: 'Sağlık',
            price: 250,
            durationMinutes: 15),
        Service(
            id: 'h2s3',
            name: 'Pet Grooming',
            category: 'Bakım',
            price: 400,
            durationMinutes: 90),
      ],
    ),
    Hairdresser(
      id: 'h3',
      name: 'Kedi Kuaförü Patisepeti',
      imageUrl:
          'https://images.unsplash.com/photo-1573865526739-10659fec78a5?w=800',
      rating: 4.6,
      location: 'Şişli',
      district: 'Teşvikiye',
      category: 'Kedi',
      businessType: 'Hayvan Kuaförü',
      services: [
        Service(
            id: 'h3s1',
            name: 'Kedi Tıraşı',
            category: 'Tıraş',
            price: 300,
            durationMinutes: 45),
        Service(
            id: 'h3s2',
            name: 'Kedi Banyosu',
            category: 'Yıkama',
            price: 250,
            durationMinutes: 30),
      ],
    ),

    // === GÜZELLİK SALONU (Beauty Salons) ===
    Hairdresser(
      id: 'g1',
      name: 'Style Studio Beauty',
      imageUrl:
          'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
      rating: 4.5,
      location: 'Şişli',
      district: 'Nişantaşı',
      category: 'Cilt Bakımı',
      businessType: 'Güzellik Salonu',
      services: [
        Service(
            id: 'g1s1',
            name: 'Manikür',
            category: 'Tırnak',
            price: 250,
            durationMinutes: 40),
        Service(
            id: 'g1s2',
            name: 'Pedikür',
            category: 'Tırnak',
            price: 300,
            durationMinutes: 50),
        Service(
            id: 'g1s3',
            name: 'Cilt Bakımı',
            category: 'Cilt',
            price: 500,
            durationMinutes: 60),
      ],
    ),
    Hairdresser(
      id: 'g2',
      name: 'Spa & Wellness Center',
      imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
      rating: 4.8,
      location: 'Beyoğlu',
      district: 'Taksim',
      category: 'Spa',
      businessType: 'Güzellik Salonu',
      services: [
        Service(
            id: 'g2s1',
            name: 'Masaj',
            category: 'Masaj',
            price: 600,
            durationMinutes: 60),
        Service(
            id: 'g2s2',
            name: 'Vücut Bakımı',
            category: 'Bakım',
            price: 450,
            durationMinutes: 45),
        Service(
            id: 'g2s3',
            name: 'Aromaterapi',
            category: 'Spa',
            price: 350,
            durationMinutes: 30),
      ],
    ),
    Hairdresser(
      id: 'g3',
      name: 'Makyaj Stüdyosu Beauty Point',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
      rating: 4.7,
      location: 'Kadıköy',
      district: 'Moda',
      category: 'Makyaj',
      businessType: 'Güzellik Salonu',
      services: [
        Service(
            id: 'g3s1',
            name: 'Gelin Makyajı',
            category: 'Makyaj',
            price: 1500,
            durationMinutes: 90),
        Service(
            id: 'g3s2',
            name: 'Gece Makyajı',
            category: 'Makyaj',
            price: 400,
            durationMinutes: 45),
        Service(
            id: 'g3s3',
            name: 'Kaş & Kirpik',
            category: 'Bakım',
            price: 200,
            durationMinutes: 30),
      ],
    ),
    Hairdresser(
      id: 'g4',
      name: 'Güzellik Merkezi Lüks',
      imageUrl:
          'https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=800',
      rating: 4.9,
      location: 'Bakırköy',
      district: 'Ataköy',
      category: 'Epilasyon',
      businessType: 'Güzellik Salonu',
      services: [
        Service(
            id: 'g4s1',
            name: 'Lazer Epilasyon',
            category: 'Epilasyon',
            price: 800,
            durationMinutes: 30),
        Service(
            id: 'g4s2',
            name: 'İğneli Epilasyon',
            category: 'Epilasyon',
            price: 500,
            durationMinutes: 45),
        Service(
            id: 'g4s3',
            name: 'Yüz Bakımı',
            category: 'Cilt',
            price: 400,
            durationMinutes: 50),
      ],
    ),
  ];

  void updateProfile(UserProfile newProfile) {
    userProfile = newProfile;
    _saveData();
    notifyListeners();
  }

  void addToCart(
      Hairdresser hairdresser, Service service, DateTime date, String time) {
    cartItems.add(CartItem(
        hairdresser: hairdresser, service: service, date: date, time: time));
    notifyListeners();
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((item) => item.id == id);
    if (cartItems.isEmpty) {
      appliedDiscount = null;
      appliedCouponCode = null;
    }
    notifyListeners();
  }

  void applyCoupon(String code) {
    final campaign = campaigns.firstWhere(
      (c) => c.code == code,
      orElse: () => Campaign(
          id: '', title: '', description: '', code: '', discountAmount: 0),
    );

    if (campaign.code.isNotEmpty) {
      appliedDiscount = campaign.discountAmount;
      appliedCouponCode = code;
    } else {
      appliedDiscount = null;
      appliedCouponCode = null;
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = cartItems.fold(0, (sum, item) => sum + item.service.price);
    if (appliedDiscount != null) {
      total -= appliedDiscount!;
    }
    return total < 0 ? 0 : total;
  }

  void confirmOrder() {
    for (var item in cartItems) {
      appointments.add(Appointment(
        id: const Uuid().v4(),
        hairdresser: item.hairdresser,
        service: item.service,
        date: item.date,
        time: item.time,
      ));
    }
    cartItems.clear();
    appliedDiscount = null;
    appliedCouponCode = null;
    notifyListeners();
  }

  void cancelAppointment(String id) {
    final index = appointments.indexWhere((app) => app.id == id);
    if (index != -1) {
      appointments[index] = Appointment(
        id: appointments[index].id,
        hairdresser: appointments[index].hairdresser,
        service: appointments[index].service,
        date: appointments[index].date,
        time: appointments[index].time,
        status: 'İptal Edildi',
      );
      notifyListeners();
    }
  }
}

// --- App Structure ---

class KuaforSepetiApp extends StatelessWidget {
  const KuaforSepetiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'KuaförSepeti',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00796B), // Teal
            primary: const Color(0xFF00796B),
            secondary: const Color(0xFFF5F5F5),
          ),
          scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

// --- Screens ---
