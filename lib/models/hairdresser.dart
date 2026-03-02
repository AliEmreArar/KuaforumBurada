class Hairdresser {
  final String id;
  final String name;
  final String location;
  final String district;
  final String imageUrl;
  final double rating;
  final double minOrder;
  final int serviceDuration; // in minutes
  final String description;
  final bool hasHomeService;
  final bool isSuperPrice;
  final String category; // "Erkek", "Kadın", etc.
  final double latitude;
  final double longitude;

  Hairdresser({
    required this.id,
    required this.name,
    required this.location,
    required this.district,
    required this.imageUrl,
    required this.rating,
    required this.minOrder,
    required this.serviceDuration,
    required this.description,
    required this.hasHomeService,
    required this.isSuperPrice,
    required this.category,
    required this.latitude,
    required this.longitude,
  });
}


