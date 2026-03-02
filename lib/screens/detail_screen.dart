import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main.dart'; // Imports Hairdresser, Service, AppState
import 'search_screen.dart'; // Imports AppointmentBookingScreen

class DetailScreen extends StatefulWidget {
  final Hairdresser salon;

  const DetailScreen({
    super.key,
    required this.salon,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _selectedTab = 'Services'; // Services, Portfolio, Reviews
  List<Service> _services = [];

  // Design Colors
  final Color _primaryColor = const Color(0xFF00796B); // Teal
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _textColor = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    // Use services from the hairdresser object directly
    _services = widget.salon.services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120), // Space for bottom bar
            child: Column(
              children: [
                // Header Image
                Stack(
                  children: [
                    SizedBox(
                      height: 256, // h-64
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: widget.salon.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey),
                      ),
                    ),
                    // Overlay + Header Buttons
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCircleButton(
                                icon: Icons.arrow_back,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              // Optional: Salon name in header when scrolled
                              const SizedBox(width: 40),
                              _buildCircleButton(
                                icon: Icons.favorite_border,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Main Content (Rounded overlap)
                Container(
                  transform: Matrix4.translationValues(0, -32, 0), // -mt-8
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.salon.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating & Location
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.salon.rating}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: _textColor),
                          ),
                          Text(
                            " (95+ reviews)",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.location_on,
                              color: _primaryColor, size: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${widget.salon.district}, ${widget.salon.location}",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Three Action Grid
                      Row(
                        children: [
                          Expanded(
                              child: _buildActionCard(
                                  Icons.schedule, "09:00 - 19:00")),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildActionCard(Icons.call, "Contact")),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildActionCard(
                                  Icons.directions, "Directions")),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Segmented Control
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: _buildTabButton("Services")),
                            Expanded(child: _buildTabButton("Portfolio")),
                            Expanded(child: _buildTabButton("Reviews")),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tab Content
                      if (_selectedTab == 'Services')
                        _buildServicesList()
                      else if (_selectedTab == 'Reviews')
                        const Center(child: Text("Yorumlar yakında..."))
                      else
                        const Center(
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text("Portfolio Content"))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: _backgroundColor.withOpacity(0.98),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                // Ensure it doesn't overlap home indicator
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Generic Book Action or Scroll to services
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Book Now",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Bottom Nav Mock (Row of icons text)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBottomNavItem(Icons.explore, "Keşfet", true),
                        _buildBottomNavItem(
                            Icons.calendar_today, "Randevular", false),
                        _buildBottomNavItem(Icons.palette, "Tasarımlar", false),
                        _buildBottomNavItem(
                            Icons.favorite, "Favorilerim", false),
                        _buildBottomNavItem(Icons.person, "Profil", false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blueGrey.shade900, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: _textColor)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final bool isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 24, color: isActive ? _primaryColor : Colors.grey.shade500),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: isActive ? _primaryColor : Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildServicesList() {
    final groupedServices = <String, List<Service>>{};
    for (var service in _services) {
      if (!groupedServices.containsKey(service.category)) {
        groupedServices[service.category] = [];
      }
      groupedServices[service.category]!.add(service);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedServices.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor)),
            const SizedBox(height: 12),
            ...entry.value.map((s) => _buildServiceRow(s)),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildServiceRow(Service service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: _textColor)),
                Text("${service.durationMinutes} min",
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Row(
            children: [
              Text("${service.price.toInt()}₺",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: _textColor)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  // Navigate to AppointmentBookingScreen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AppointmentBookingScreen(
                              hairdresser: widget.salon, service: service)));
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: _primaryColor, size: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
