import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'detail_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'category_selection_screen.dart';
import '../main.dart'; // For AppState
import '../widgets/category_chip.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  final String? businessType; // 'Kuaför', 'Hayvan Kuaförü', 'Güzellik Salonu'
  const HomeScreen({super.key, this.businessType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late String _selectedCategory;
  late String _currentBusinessType;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // New Design Colors (from old Profile Screen)
  final Color _primaryColor = const Color(0xFF00796B); // Teal
  final Color _secondaryColor = const Color(0xFFFF8A65); // Orange
  final Color _backgroundColor = const Color(0xFFF7F8FA);
  final Color _textColorDark = const Color(0xFF333333);
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _currentBusinessType = widget.businessType ?? 'Kuaför';
    _selectedCategory = 'Tümü';
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardHome(),
          const CartScreen(), // Sepetim (Index 1)
          _buildAppointmentsView(), // Randevular (Index 2)
          const OrdersScreen(), // Tasarımlar (Index 3)
          const Center(child: Text("Favorilerim")),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: _currentIndex + 1,
            selectedItemColor: _primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CategorySelectionScreen()),
                );
              } else {
                setState(() => _currentIndex = index - 1);
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded), label: 'Kategoriler'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Ana Sayfa'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined), label: 'Sepetim'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: 'Randevular'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.palette_outlined), label: 'Tasarımlar'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border), label: 'Favoriler'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardHome() {
    final appState = Provider.of<AppState>(context);
    final upcomingAppointment = appState.appointments
        .where((a) => a.status == 'Aktif')
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final hasAppointment = upcomingAppointment.isNotEmpty;
    // Use user's address or default
    final userAddress = appState.userProfile.address.isNotEmpty
        ? appState.userProfile.address
        : "Adres Seçin";

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // Header (Location + Avatar)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Konum",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12)),
                      GestureDetector(
                        onTap: () =>
                            _showAddressChangeDialog(context, appState),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                color: _primaryColor, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(userAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _textColorDark)),
                            ),
                            const Icon(Icons.keyboard_arrow_down, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200"),
                        fit: BoxFit.cover),
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 8)
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03), blurRadius: 4)
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Salon, hizmet veya konum ara...",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Categories - Horizontally scrollable chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _buildCategoryChips(),
            ),
          ),

          const SizedBox(height: 20),

          // Next Appointment Card (or Inspiration Banner)
          if (hasAppointment) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.confirmation_number_outlined,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Sıradaki Randevun",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                              "${upcomingAppointment.first.hairdresser.name} - ${upcomingAppointment.first.time}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(upcomingAppointment.first.service.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 16)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ] else ...[
            // Banner if no appointment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=600"),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent
                          ])),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sonbahar\nİndirimleri",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _secondaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 36),
                            padding: EdgeInsets.zero,
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        child: const Text("Keşfet"),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Recommendations (Horizontal)
          _buildSectionHeader("Size Özel Öneriler", "Tümünü Gör"),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildRecommendationCard(
                    appState.allHairdressers.isNotEmpty
                        ? appState.allHairdressers[0]
                        : null,
                    "Glamour Hair Studio",
                    "4.9",
                    "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=500"),
                _buildRecommendationCard(
                    appState.allHairdressers.length > 1
                        ? appState.allHairdressers[1]
                        : null,
                    "Urban Cuts",
                    "4.7",
                    "https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=500"),
                _buildRecommendationCard(
                    appState.allHairdressers.length > 2
                        ? appState.allHairdressers[2]
                        : null,
                    "Elite Barber",
                    "4.8",
                    "https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=500"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Salon List header
          _buildSectionHeader(_getSectionTitle(), ""),
          // Filtered List
          ..._getFilteredHairdressers(appState.allHairdressers)
              .take(10)
              .map((salon) => _buildSalonListTile(salon)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColorDark)),
          if (action.isNotEmpty)
            Text(action,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor)),
        ],
      ),
    );
  }

  String _getSectionTitle() {
    switch (_currentBusinessType) {
      case 'Hayvan Kuaförü':
        return 'Yakındaki Pet Kuaförleri';
      case 'Güzellik Salonu':
        return 'Yakındaki Güzellik Salonları';
      default:
        return 'Yakındaki Kuaförler';
    }
  }

  List<Widget> _buildCategoryChips() {
    // Define categories based on business type
    List<Map<String, dynamic>> categories;

    if (_currentBusinessType == 'Hayvan Kuaförü') {
      categories = [
        {'name': 'Tümü', 'icon': Icons.apps},
        {'name': 'Köpek', 'icon': Icons.pets},
        {'name': 'Kedi', 'icon': Icons.pets},
        {'name': 'Kedi & Köpek', 'icon': Icons.pets_outlined},
      ];
    } else if (_currentBusinessType == 'Güzellik Salonu') {
      categories = [
        {'name': 'Tümü', 'icon': Icons.apps},
        {'name': 'Cilt Bakımı', 'icon': Icons.face_retouching_natural},
        {'name': 'Spa', 'icon': Icons.spa},
        {'name': 'Makyaj', 'icon': Icons.brush},
        {'name': 'Epilasyon', 'icon': Icons.clean_hands},
        {'name': 'Manikür', 'icon': Icons.back_hand},
      ];
    } else {
      // Default: Kuaför
      categories = [
        {'name': 'Tümü', 'icon': Icons.apps},
        {'name': 'Erkek', 'icon': Icons.face},
        {'name': 'Kadın', 'icon': Icons.face_3},
        {'name': 'Çocuk', 'icon': Icons.child_care},
      ];
    }

    return categories.map((category) {
      final isSelected = _selectedCategory == category['name'] as String;
      return CategoryChip(
        name: category['name'] as String,
        icon: category['icon'] as IconData,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            _selectedCategory = category['name'] as String;
          });
        },
      );
    }).toList();
  }

  Widget _buildRecommendationCard(
      Hairdresser? salon, String name, String rating, String imageUrl) {
    return GestureDetector(
      onTap: () {
        if (salon != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => DetailScreen(salon: salon)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Salon detayları yüklenemedi.")));
        }
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(imageUrl,
                  height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(" $rating",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSalonListTile(Hairdresser salon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => DetailScreen(salon: salon)));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(salon.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 80, height: 80, color: Colors.grey.shade200)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salon.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _textColorDark)),
                    Text(salon.category,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: _secondaryColor),
                        Text(" ${salon.rating}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey.shade400),
                        Text(" 1.2 km",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle),
                child:
                    Icon(Icons.arrow_forward, color: _primaryColor, size: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsView() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  "Henüz randevunuz yok",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Randevularım'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.appointments.length,
            itemBuilder: (context, index) {
              final appointment = appState.appointments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appointment.hairdresser.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: appointment.status == 'Aktif'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              appointment.status,
                              style: TextStyle(
                                color: appointment.status == 'Aktif'
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(appointment.service.name,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMMM yyyy', 'tr_TR')
                                .format(appointment.date),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            appointment.time,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      if (appointment.status == 'Aktif') ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              appState.cancelAppointment(appointment.id);
                            },
                            child: const Text("İptal Et",
                                style: TextStyle(color: Colors.red)),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<Hairdresser> _getFilteredHairdressers(List<Hairdresser> allSalons) {
    return allSalons.where((salon) {
      // First filter by business type
      bool matchesBusinessType = salon.businessType == _currentBusinessType;

      // Then filter by category
      bool matchesCategory = true;
      if (_selectedCategory != 'Tümü') {
        matchesCategory = salon.services.any((s) =>
                s.category
                    .toLowerCase()
                    .contains(_selectedCategory.toLowerCase()) ||
                s.name
                    .toLowerCase()
                    .contains(_selectedCategory.toLowerCase())) ||
            salon.name
                .toLowerCase()
                .contains(_selectedCategory.toLowerCase()) ||
            salon.category
                .toLowerCase()
                .contains(_selectedCategory.toLowerCase());
      }

      // Then filter by search query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch = salon.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            salon.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            salon.district.toLowerCase().contains(_searchQuery.toLowerCase());
      }

      return matchesBusinessType && matchesCategory && matchesSearch;
    }).toList();
  }

  void _showAddressChangeDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Adres İşlemleri"),
        content: const Text("Adres değiştirmek istiyor musunuz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showNewAddressInput(context, appState);
            },
            child: const Text("Evet"),
          ),
        ],
      ),
    );
  }

  void _showNewAddressInput(BuildContext context, AppState appState) {
    final TextEditingController addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Yeni Adres Girin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                  hintText: "Yeni adresinizi yazın...",
                  border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            if (appState.userProfile.addresses.isNotEmpty) ...[
              const Text("Kayıtlı Adreslerim:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appState.userProfile.addresses.length,
                  itemBuilder: (c, i) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on, size: 16),
                    title: Text(appState.userProfile.addresses[i],
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      appState.updateCurrentAddress(
                          appState.userProfile.addresses[i]);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              )
            ]
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.isNotEmpty) {
                appState.addAddress(addressController.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Kaydet ve Seç"),
          ),
        ],
      ),
    );
  }
}
