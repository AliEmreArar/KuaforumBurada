import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import '../main.dart'; // For AppState

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).userProfile;
    final userName =
        user.name.isNotEmpty ? user.name : 'Aslı'; // Fallback or mock name

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hoş Geldin, $userName!",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Icon(Icons.settings, color: Color(0xFF0F172A)),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "Ne arıyorsun?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 32),

              // Cards Grid
              // We have 1 large top card, and 2 smaller bottom cards in a row
              Expanded(
                child: Column(
                  children: [
                    // Top Card: Kuaför
                    Expanded(
                      flex: 5,
                      child: _buildCategoryCard(
                        context,
                        title: "Kuaför",
                        image:
                            "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800", // Salon image
                        icon: Icons.cut,
                        onTap: () => _navigateToHome(context, "Kuaför"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Bottom Cards
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildCategoryCard(
                              context,
                              title: "Hayvan Kuaförü",
                              image:
                                  "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=800", // Dog grooming
                              icon: Icons.pets,
                              onTap: () =>
                                  _navigateToHome(context, "Hayvan Kuaförü"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCategoryCard(
                              context,
                              title: "Güzellik Salonu",
                              image:
                                  "https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=800", // Beauty products
                              icon: Icons.spa,
                              onTap: () =>
                                  _navigateToHome(context, "Güzellik Salonu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context,
      {required String title,
      required String image,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFFA6B9A8), size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context, String businessType) {
    // Navigate to HomeScreen with the selected business type
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(businessType: businessType)),
    );
  }
}
