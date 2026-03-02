import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../main.dart'; // Imports AppState, CartItem, Hairdresser, Service

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Sepetim',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.cartItems.isEmpty) {
            return _buildEmptyCart();
          }

          // Group items by Hairdresser ID + Date + Time to create "Appointments"
          final groupedItems = _groupCartItems(appState.cartItems);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of Appointments (Cards)
                ...groupedItems.entries.map((entry) {
                  return _buildAppointmentCard(
                      context, appState, entry.value, entry.key);
                }),

                const SizedBox(height: 24),
                const Text("Promosyon Kodu",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPromoCodeSection(context, appState),

                const SizedBox(height: 24),
                const Text("Fiyatlandırma",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPricingSection(appState),

                const SizedBox(height: 24),
                const Text("Ödeme Yöntemi",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPaymentMethodSection(),

                const SizedBox(height: 32),
                _buildCheckoutButton(context, appState),
                const SizedBox(height: 20),
                _buildLegalText(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Sepetiniz boş',
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Map<String, List<CartItem>> _groupCartItems(List<CartItem> items) {
    final Map<String, List<CartItem>> grouped = {};
    for (var item in items) {
      final key =
          "${item.hairdresser.id}_${DateFormat('yyyyMMdd').format(item.date)}_${item.time}";
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Widget _buildAppointmentCard(BuildContext context, AppState appState,
      List<CartItem> items, String groupKey) {
    if (items.isEmpty) return const SizedBox.shrink();
    final firstItem = items.first;
    final shop = firstItem.hairdresser;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          // Header: Shop Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    shop.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 70, height: 70, color: Colors.grey.shade200),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shop.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("${shop.district}, ${shop.location}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(
                        "${DateFormat('d MMMM EEEE', 'tr_TR').format(firstItem.date)}, ${firstItem.time}",
                        style: TextStyle(
                            color: const Color(0xFF00796B).withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Services List
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (ctx, i) =>
                Divider(color: Colors.grey.shade100, height: 1),
            itemBuilder: (ctx, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => appState.removeFromCart(item.id),
                            child: const Icon(Icons.remove_circle_outline,
                                color: Colors.red, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(item.service.name,
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Text("₺${item.service.price.toInt()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          // Specialist (Footer)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Uzman",
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                const Text("Ayşe Yılmaz", // Mock or dynamic if available
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF333333))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection(BuildContext context, AppState appState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: "Kupon Kodu Giriniz",
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  appState.applyCoupon(_couponController.text);
                  if (appState.appliedDiscount != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "${appState.appliedDiscount!.toInt()} TL indirim uygulandı!"),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Geçersiz kupon kodu."),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child:
                    const Text("Ekle", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
          if (appState.appliedDiscount != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "${appState.appliedCouponCode} kodu uygulandı",
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildPricingSection(AppState appState) {
    double subTotal =
        appState.cartItems.fold(0, (sum, item) => sum + item.service.price);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPriceRow("Ara Toplam", subTotal),
          const SizedBox(height: 12),
          _buildPriceRow("İndirim", -(appState.appliedDiscount ?? 0),
              isDiscount: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Toplam Tutar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("₺${appState.totalAmount.toInt()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF00796B))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(
          "${amount == 0 ? '' : (isDiscount ? '-' : '')}₺${amount.abs().toInt()}",
          style: TextStyle(
              color: isDiscount ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.grey),
            title: const Text("VISA **** 1234",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Son Kullanma: 12/26"),
            trailing: const Icon(Icons.check_circle, color: Color(0xFF00796B)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.add_card, color: Colors.grey),
            title: const Text("Yeni Kart Ekle"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, AppState appState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          appState.confirmOrder();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Randevu talebiniz alındı! Randevularım sayfasından takip edebilirsiniz.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00796B),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: const Text("Ödemeyi Tamamla ve Onayla",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }

  Widget _buildLegalText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Onaylayarak Hizmet Sözleşmesi ve İptal Politikası'nı kabul etmiş olursunuz.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
      ),
    );
  }
}
