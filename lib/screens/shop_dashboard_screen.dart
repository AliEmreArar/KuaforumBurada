import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/shop_model.dart';
import 'login_screen.dart';

class ShopDashboardScreen extends StatelessWidget {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final shop = state.currentShop;

    if (shop == null) {
      return const Scaffold(body: Center(child: Text('Giriş yapılmadı.')));
    }

    // Design Colors
    final Color primaryColor = const Color(0xFF2C7A7B);
    final Color backgroundColor = const Color(0xFFF7FAFC);
    final Color textColor = const Color(0xFF2D3748);
    final Color accentColor = const Color(0xFFDD6B20);
    final Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  color: backgroundColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store, size: 32, color: textColor),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              // Logout or Profile Menu
                              state.logoutShop();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.account_circle,
                                  size: 32, color: textColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          shop.shopName,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Services Section
                      _buildSectionTitle("Hizmetleriniz", textColor),
                      const SizedBox(height: 12),
                      if (shop.services.isEmpty)
                        _buildEmptyState(primaryColor, textColor)
                      else
                        ...shop.services.map((s) => _buildServiceItem(
                            s, primaryColor, textColor, cardColor)),

                      const SizedBox(height: 32),

                      // Store Info Section
                      _buildSectionTitle("Mağaza Bilgileri", textColor),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info, color: primaryColor, size: 28),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Profilinizi Güncel Tutun",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: textColor)),
                                      const SizedBox(height: 4),
                                      Text(
                                        "İletişim bilgilerinizi, çalışma saatlerinizi ve fotoğraflarınızı düzenleyerek müşterilerinize en doğru bilgiyi sunun.",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                label: const Text("Profili Düzenle",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Profil düzenleme yakında eklenecek.')),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80), // Space for FAB
                    ],
                  ),
                ),
              ],
            ),

            // FAB
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Hizmet ekleme yakında eklenecek.')),
                  );
                },
                backgroundColor: primaryColor,
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(title,
        style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color));
  }

  Widget _buildEmptyState(Color primaryColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.grey.shade200,
            style: BorderStyle
                .solid), // Dashed border needs custom painter, using solid for now or image
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.add_circle, size: 32, color: primaryColor),
          ),
          const SizedBox(height: 16),
          Text("Henüz hiç hizmet eklemediniz.",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          Text("Müşterilerinize sunduğunuz hizmetleri ekleyerek başlayın.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildServiceItem(ShopService service, Color primaryColor,
      Color textColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.content_cut, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor)),
                Text("30 dk",
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize:
                            12)), // Hardcoded duration as per design usage, actual data missing
              ],
            ),
          ),
          Text("${service.price.toInt()} TL",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
        ],
      ),
    );
  }
}
