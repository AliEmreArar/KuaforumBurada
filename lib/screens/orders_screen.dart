import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Design Colors
  final Color _primaryColor = const Color(0xFF00796B); // Teal
  final Color _backgroundColor = const Color(0xFFF6F7F8);
  final Color _textColorDark = const Color(0xFF18181B);
  final Color _textColorGray = const Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("Tasarımlar",
            style: TextStyle(
                color: _textColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            // AI Header Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/4712/4712035.png", // Placeholder for AI icon
                        color: _primaryColor,
                        errorBuilder: (ctx, err, stack) => Icon(
                            Icons.auto_awesome,
                            color: _primaryColor,
                            size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Yapay Zeka ile Saçını Tasarla",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColorDark)),
                  const SizedBox(height: 8),
                  Text(
                    "Hayalindeki saç modelini tarif et, sana özel tasarımlar ve kuaför önerileri sunalım.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textColorGray, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Chat & Results Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildChatBubble(
                      "Merhaba! Hayalindeki saç stilini bulmana nasıl yardımcı olabilirim?",
                      isAi: true),
                  _buildChatBubble("kısa, dalgalı, kahverengi saç",
                      isAi: false),
                  _buildChatBubble(
                      "Harika bir seçim! İşte \"kısa, dalgalı, kahverengi saç\" için bazı öneriler:",
                      isAi: true),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildGeneratedImage(
                              "https://images.unsplash.com/photo-1620331317312-74b88bf40907?w=500")),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildGeneratedImage(
                              "https://images.unsplash.com/photo-1620331311520-246422fd82f9?w=500")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Bu stilleri beğendin mi? İstersen bu modelleri yapabilecek kuaförleri listeleyebilirim.",
                            style:
                                TextStyle(fontSize: 13, color: _textColorDark)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Kuaförleri Göster",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 24),

            // Inspiration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("İlham Al",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _textColorDark)),
                  const SizedBox(height: 12),
                  Text("Hayalindeki Saç Stili Hangisi?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColorDark)),
                  const SizedBox(height: 12),
                  // Style Grid
                  Row(
                    children: [
                      Expanded(
                          child: _buildStyleCard("Kısa Saç",
                              "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500")),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStyleCard("Uzun Saç",
                              "https://images.unsplash.com/photo-1519699047748-de8e457a634e?w=500")),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Hayalindeki Saç Rengi Hangisi?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColorDark)),
                  const SizedBox(height: 12),
                  // Color Grid
                  Row(
                    children: [
                      Expanded(
                          child: _buildColorCard("Bal Köpüğü", "7.31",
                              "https://images.unsplash.com/photo-1634449571010-02389ed0f9b0?w=500")),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildColorCard("Küllü Sarı", "9.1",
                              "https://images.unsplash.com/photo-1580618672591-eb180b1a973f?w=500")),
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

  Widget _buildChatBubble(String text, {required bool isAi}) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isAi ? Colors.grey.shade200 : _primaryColor,
          borderRadius: BorderRadius.only(
            topLeft:
                isAi ? const Radius.circular(4) : const Radius.circular(16),
            topRight:
                isAi ? const Radius.circular(16) : const Radius.circular(4),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isAi ? _textColorDark : Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildGeneratedImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(url,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: Colors.grey)),
      ),
    );
  }

  Widget _buildStyleCard(String title, String url) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildColorCard(String title, String code, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Text(title,
            style:
                TextStyle(fontWeight: FontWeight.w600, color: _textColorDark)),
        Text(code, style: TextStyle(fontSize: 12, color: _textColorGray)),
      ],
    );
  }
}
