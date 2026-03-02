import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Imports Hairdresser, Service, AppState

class AppointmentBookingScreen extends StatefulWidget {
  final Hairdresser hairdresser;
  final Service service;

  const AppointmentBookingScreen(
      {super.key, required this.hairdresser, required this.service});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  // Design Colors
  final Color _primaryColor = const Color(0xFF00796B); // Teal
  final Color _textColorDark = const Color(0xFF111618);
  final Color _backgroundColor = const Color(0xFFF7FAFC);

  int _selectedDate = 6;
  String _selectedTime = "10:30";
  String _selectedSpecialist = "no-preference";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Tarih ve Uzman Seçimi",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 4)
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.service.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _textColorDark)),
                          const SizedBox(height: 4),
                          Text(
                              "Toplam Süre: ${widget.service.durationMinutes} dakika",
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                                "₺${widget.service.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: _primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: widget.hairdresser.imageUrl.startsWith('http')
                              ? NetworkImage(widget.hairdresser.imageUrl)
                              : NetworkImage(
                                  "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Calendar Section (Simplified Mock)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {}),
                        Text("Aralık 2023",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _textColorDark)),
                        IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {}),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        "Pzt",
                        "Sal",
                        "Çar",
                        "Per",
                        "Cum",
                        "Cmt",
                        "Paz"
                      ]
                          .map((e) => Text(e,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey)))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(31, (index) {
                        final day = index + 1;
                        final isSelected = day == _selectedDate;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = day),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? null
                                  : Border.all(color: Colors.transparent),
                            ),
                            child: Text(
                              "$day",
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),

            // Time Slots
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Uygun Saatler",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColorDark)),
            ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ["10:00", "10:30", "11:00", "11:30", "13:00", "14:00"]
                    .map((time) {
                  final isSelected = time == _selectedTime;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = time),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? _primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected
                                ? _primaryColor
                                : Colors.grey.shade300),
                      ),
                      child: Text(time,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Specialist Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Uzman Seç",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColorDark)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSpecialistOption("no-preference", "Farketmez",
                      "Müsait olan ilk uzman", null, Icons.diversity_3),
                  const SizedBox(height: 8),
                  _buildSpecialistOption(
                      "ayse",
                      "Ayşe Yılmaz",
                      "4.8",
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
                      null),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white.withOpacity(0.9),
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showSummaryModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Tarih ve Uzmanı Onayla",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistOption(
      String id, String name, String sub, String? imgUrl, IconData? icon) {
    bool isSelected = _selectedSpecialist == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedSpecialist = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: _primaryColor, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 4)
                ],
        ),
        child: Row(
          children: [
            if (imgUrl != null)
              CircleAvatar(backgroundImage: NetworkImage(imgUrl), radius: 24)
            else
              CircleAvatar(
                  backgroundColor: _primaryColor.withOpacity(0.2),
                  radius: 24,
                  child: Icon(icon, color: _primaryColor)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _textColorDark)),
                  if (icon == null)
                    Row(children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(sub, style: const TextStyle(fontSize: 13))
                    ])
                  else
                    Text(sub,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFA6B9A8)), // Custom Primary Ref
          ],
        ),
      ),
    );
  }

  void _showSummaryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Randevu Özeti",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 24),
            _buildSummaryRow("Hizmet", widget.service.name),
            const SizedBox(height: 16),
            _buildSummaryRow(
                "Tarih ve Saat", "$_selectedDate Aralık 2023, $_selectedTime"),
            const SizedBox(height: 16),
            _buildSummaryRow(
                "Uzman",
                _selectedSpecialist == "no-preference"
                    ? "Farketmez"
                    : _selectedSpecialist),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tahmini Fiyat",
                    style: TextStyle(color: Colors.grey)),
                Text("₺${widget.service.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: _primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart logic using AppState
                  Provider.of<AppState>(context, listen: false).addToCart(
                    widget.hairdresser,
                    widget.service,
                    DateTime(2023, 12, _selectedDate),
                    _selectedTime,
                  );

                  Navigator.pop(ctx); // Close modal
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst); // Go back to Home
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Randevu Sepete Eklendi!"),
                      backgroundColor: Colors.green));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Sepete Ekle ve Devam Et",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Geri Dön/Düzenle",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
