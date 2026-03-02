import '../models/hairdresser.dart';
import '../models/service_item.dart';
import '../models/review.dart';
import '../models/campaign.dart';

class MockData {
  static List<Hairdresser> getHairdressers() {
    return [
      Hairdresser(
        id: '1',
        name: 'Erkek Berberi Ali Usta',
        location: 'Kadıköy',
        district: 'Moda',
        imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=800',
        rating: 9.2,
        minOrder: 200,
        serviceDuration: 30,
        description: '20 yıllık deneyimli berber. Modern ve klasik kesimlerde uzman.',
        hasHomeService: true,
        isSuperPrice: true,
        category: 'Erkek',
        latitude: 40.9901,
        longitude: 29.0291,
      ),
      Hairdresser(
        id: '2',
        name: 'Kadın Kuaförü Ayşe Hanım',
        location: 'Beşiktaş',
        district: 'Ortaköy',
        imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
        rating: 9.5,
        minOrder: 300,
        serviceDuration: 45,
        description: 'Kadın kuaförlüğünde uzman. Trend saç modelleri ve renklendirme.',
        hasHomeService: false,
        isSuperPrice: false,
        category: 'Kadın',
        latitude: 41.0422,
        longitude: 29.0060,
      ),
      Hairdresser(
        id: '3',
        name: 'Style Barbershop',
        location: 'Şişli',
        district: 'Nişantaşı',
        imageUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
        rating: 8.9,
        minOrder: 180,
        serviceDuration: 25,
        description: 'Modern erkek kuaförü. Profesyonel hizmet ve rahat ortam.',
        hasHomeService: true,
        isSuperPrice: true,
        category: 'Erkek',
        latitude: 41.0529,
        longitude: 28.9877,
      ),
      Hairdresser(
        id: '4',
        name: 'Elite Hair Studio',
        location: 'Beyoğlu',
        district: 'Taksim',
        imageUrl: 'https://images.unsplash.com/photo-1516975080664-ed2fc6a13737?w=800',
        rating: 9.7,
        minOrder: 400,
        serviceDuration: 60,
        description: 'Lüks kuaför salonu. Premium hizmet ve kaliteli ürünler.',
        hasHomeService: false,
        isSuperPrice: false,
        category: 'Kadın',
        latitude: 41.0286,
        longitude: 28.9744,
      ),
      Hairdresser(
        id: '5',
        name: 'Hızlı Tıraş Merkezi',
        location: 'Üsküdar',
        district: 'Çarşı',
        imageUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=800',
        rating: 8.5,
        minOrder: 150,
        serviceDuration: 20,
        description: 'Hızlı ve kaliteli tıraş hizmeti. Uygun fiyat, iyi hizmet.',
        hasHomeService: true,
        isSuperPrice: true,
        category: 'Erkek',
        latitude: 41.0260,
        longitude: 29.0154,
      ),
      Hairdresser(
        id: '6',
        name: 'Güzellik Merkezi',
        location: 'Bakırköy',
        district: 'Ataköy',
        imageUrl: 'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=800',
        rating: 9.0,
        minOrder: 250,
        serviceDuration: 40,
        description: 'Kapsamlı güzellik merkezi. Tüm güzellik ihtiyaçlarınız için.',
        hasHomeService: false,
        isSuperPrice: false,
        category: 'Kadın',
        latitude: 40.9830,
        longitude: 28.8731,
      ),
      Hairdresser(
        id: '7',
        name: 'Çocuk Kuaförü',
        location: 'Ataşehir',
        district: 'Ataşehir',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
        rating: 9.3,
        minOrder: 120,
        serviceDuration: 30,
        description: 'Çocuklar için özel kuaför hizmeti. Eğlenceli ve güvenli ortam.',
        hasHomeService: true,
        isSuperPrice: true,
        category: 'Çocuk',
        latitude: 40.9932,
        longitude: 29.1133,
      ),
      Hairdresser(
        id: '8',
        name: 'Manikür & Pedikür Salonu',
        location: 'Kadıköy',
        district: 'Bahariye',
        imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
        rating: 8.8,
        minOrder: 180,
        serviceDuration: 45,
        description: 'Profesyonel manikür ve pedikür hizmeti.',
        hasHomeService: false,
        isSuperPrice: false,
        category: 'Manikür',
        latitude: 40.9880,
        longitude: 29.0250,
      ),
    ];
  }

  static List<ServiceItem> getServicesForSalon(String salonId) {
    final allServices = {
      '1': [
        ServiceItem(
          id: 's1',
          name: 'Klasik Saç Kesimi',
          description: 'Geleneksel erkek saç kesimi',
          price: 200,
          category: 'Saç Kesimi',
        ),
        ServiceItem(
          id: 's2',
          name: 'Modern Fade Kesim',
          description: 'Trend fade stili kesim',
          price: 250,
          category: 'Saç Kesimi',
        ),
        ServiceItem(
          id: 's3',
          name: 'Sakal Tıraşı',
          description: 'Profesyonel sakal düzenleme',
          price: 100,
          category: 'Sakal Tıraşı',
        ),
        ServiceItem(
          id: 's4',
          name: 'Saç Yıkama',
          description: 'Şampuan ve bakım',
          price: 50,
          category: 'Bakım',
        ),
      ],
      '2': [
        ServiceItem(
          id: 's5',
          name: 'Kadın Saç Kesimi',
          description: 'Profesyonel kadın saç kesimi',
          price: 300,
          category: 'Saç Kesimi',
        ),
        ServiceItem(
          id: 's6',
          name: 'Fön Çekme',
          description: 'Profesyonel fön hizmeti',
          price: 200,
          category: 'Şekillendirme',
        ),
        ServiceItem(
          id: 's7',
          name: 'Saç Boyama',
          description: 'Kalıcı saç boyama',
          price: 500,
          category: 'Renklendirme',
        ),
        ServiceItem(
          id: 's8',
          name: 'Keratin Bakımı',
          description: 'Saç düzleştirme ve bakım',
          price: 800,
          category: 'Bakım',
        ),
      ],
    };

    return allServices[salonId] ?? allServices['1']!;
  }

  static List<Review> getReviewsForSalon(String salonId) {
    return [
      Review(
        id: 'r1',
        userName: 'Mehmet Y.',
        rating: 5.0,
        comment: 'Çok memnun kaldım, çok profesyonel hizmet. Kesinlikle tavsiye ederim!',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r2',
        userName: 'Ahmet K.',
        rating: 4.5,
        comment: 'Güzel bir deneyimdi, fiyat performans açısından çok iyi.',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Review(
        id: 'r3',
        userName: 'Ali V.',
        rating: 5.0,
        comment: 'Mükemmel! Çok temiz ve hijyenik bir ortam. Tekrar geleceğim.',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Review(
        id: 'r4',
        userName: 'Can D.',
        rating: 4.0,
        comment: 'İyi bir hizmet aldım, biraz beklemek zorunda kaldım ama sonuç güzeldi.',
        date: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  static List<String> getCategories() {
    return ['Erkek', 'Kadın', 'Manikür', 'Çocuk', 'Sakal', 'Fön', 'Boyama'];
  }

  static List<Campaign> getCampaigns() {
    return [
      Campaign(
        id: '1',
        title: 'Öğrenci İndirimi',
        description: 'Öğrencilere özel %20 indirim',
        discount: '%20',
        code: 'OGRENCI20',
        isActive: true,
      ),
      Campaign(
        id: '2',
        title: 'İlk Ziyaret Bedava',
        description: 'İlk randevunuzda ücretsiz saç kesimi',
        discount: 'ÜCRETSİZ',
        code: 'ILKZIYARET',
        isActive: true,
      ),
      Campaign(
        id: '3',
        title: 'Hafta İçi Özel',
        description: 'Pazartesi-Perşembe arası %15 indirim',
        discount: '%15',
        code: 'HAFTAICI15',
        isActive: true,
      ),
      Campaign(
        id: '4',
        title: 'Arkadaşını Getir',
        description: 'Arkadaşınızla birlikte gelin, ikinize de %25 indirim',
        discount: '%25',
        code: 'ARKADAS25',
        isActive: true,
      ),
    ];
  }
}
