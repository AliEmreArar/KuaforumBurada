import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../main.dart';
import '../models/shop_model.dart';
import 'shop_dashboard_screen.dart';

class ShopRegisterScreen extends StatefulWidget {
  const ShopRegisterScreen({super.key});

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Design Colors
  final Color _primaryColor = const Color(0xFF13A4EC);
  final Color _backgroundColor = const Color(0xFFF6F7F8);
  final Color _textColor = const Color(0xFF111618);
  final Color _borderColor = const Color(0xFFE5E7EB);
  final Color _placeholderColor = const Color(0xFF617C89);

  // Controllers
  final _shopNameController =
      TextEditingController(); // Pre-filled in design "Glamour Hair Studio"
  final _locationController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedEmployeeRange = "1-5";
  final List<String> _employeeRanges = ["1-5", "6-10", "11-20", "20+"];

  String _selectedCategory = "Kadın Kuaförü";
  final List<String> _categories = [
    "Kadın Kuaförü",
    "Erkek Kuaförü",
    "Güzellik Salonu",
    "Çocuk Kuaförü",
    "Hayvan Kuaförü"
  ];

  // State
  bool _isLegalAccepted = false;
  List<ShopService> _services = [
    ShopService(name: 'Manikür', price: 250), // Example default
  ];
  List<OperatingHours> _operatingHours = [
    OperatingHours(day: 'Pazartesi'),
    OperatingHours(day: 'Salı'),
    OperatingHours(day: 'Çarşamba'),
    OperatingHours(day: 'Perşembe'),
    OperatingHours(day: 'Cuma'),
    OperatingHours(day: 'Cumartesi'),
    OperatingHours(day: 'Pazar', isOpen: false),
  ];

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  List<String> _selectedImageBase64s = [];

  Future<void> _pickImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        setState(() {
          _selectedImageBase64s.add(base64String);
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImageBase64s.removeAt(index);
    });
  }

  void _addService() {
    setState(() {
      _services.add(ShopService(name: '', price: 0));
    });
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate() && _isLegalAccepted) {
      _formKey.currentState!.save();

      // Mapping string range to int
      int empCount = 1;
      if (_selectedEmployeeRange == "6-10") empCount = 10;
      if (_selectedEmployeeRange == "11-20") empCount = 20;
      if (_selectedEmployeeRange == "20+") empCount = 21;

      final shop = ShopProfile(
        id: const Uuid().v4(),
        shopName: _shopNameController.text.isEmpty
            ? "Glamour Hair Studio"
            : _shopNameController.text,
        legalOwnerName: _ownerNameController.text,
        taxId: _taxIdController.text,
        location: _locationController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        category: _selectedCategory,
        employeeCount: empCount,
        operatingHours: _operatingHours,
        services: _services,
        photoUrls: _selectedImageBase64s,
      );

      final success =
          Provider.of<AppState>(context, listen: false).registerShop(shop);

      if (success) {
        Provider.of<AppState>(context, listen: false)
            .loginShop(shop.email, shop.password);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ShopDashboardScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Dükkan kaydı başarıyla oluşturuldu!'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Bu e-posta ile kayıtlı bir dükkan zaten var.'),
              backgroundColor: Colors.red),
        );
      }
    } else if (!_isLegalAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lütfen yasal metinleri onaylayın.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("Dükkan Sahibi Kayıt",
            style: TextStyle(
                color: _textColor, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: _backgroundColor,
        foregroundColor: _textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                bottom: 140), // Space for fixed bottom bar
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Business Info
                  _buildSectionHeader("İşletme Bilgileri"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildLabeledInput(
                          label: "Dükkan Adı",
                          child: _buildInput(
                            controller: _shopNameController,
                            hintText: "Glamour Hair Studio",
                            icon: Icons.lock,
                            readOnly:
                                false, // Keeping editable as it affects registration
                            filledColor: Colors.grey.shade200, // Look readonly
                          ),
                        ),
                        _buildLabeledInput(
                          label: "Kategori",
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _borderColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: _placeholderColor),
                                items: _categories
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e,
                                            style:
                                                TextStyle(color: _textColor))))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedCategory = val!),
                              ),
                            ),
                          ),
                        ),
                        _buildLabeledInput(
                          label: "Lokasyon",
                          child: _buildInput(
                            controller: _locationController,
                            hintText: "Adres seçin",
                            icon: Icons.map,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Operating Hours Summary Row
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: InkWell(
                      onTap: _showOperatingHoursDialog,
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.schedule, color: _textColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Çalışma Saatleri",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _textColor)),
                                Text("Pazartesi - Cuma: 09:00 - 18:00",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: _placeholderColor)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildLabeledInput(
                      label: "Çalışan Sayısı",
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedEmployeeRange,
                            isExpanded: true,
                            items: _employeeRanges
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedEmployeeRange = val!),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Legal Info
                  _buildSectionHeader("Yasal Bilgiler"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildLabeledInput(
                          label: "Yasal Sahip Adı Soyadı",
                          child: _buildInput(
                            controller: _ownerNameController,
                            hintText: "Adınız Soyadınız",
                          ),
                        ),
                        _buildLabeledInput(
                          label: "Vergi Numarası",
                          child: _buildInput(
                            controller: _taxIdController,
                            hintText: "10 haneli vergi numaranız",
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contact
                  _buildSectionHeader("İletişim & Giriş Bilgileri"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildLabeledInput(
                          label: "Dükkan Telefon Numarası",
                          child: _buildInput(
                            controller: _phoneController,
                            hintText: "0 (XXX) XXX XX XX",
                            inputType: TextInputType.phone,
                          ),
                        ),
                        _buildLabeledInput(
                          label: "E-posta",
                          child: _buildInput(
                            controller: _emailController,
                            hintText: "ornek@email.com",
                            inputType: TextInputType.emailAddress,
                          ),
                        ),
                        _buildLabeledInput(
                          label: "Şifre",
                          child: _buildInput(
                            controller: _passwordController,
                            hintText: "Şifrenizi oluşturun",
                            isPassword: true,
                            icon: Icons.visibility_off,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Photos
                  _buildSectionHeader("Dükkan Görselleri"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: _selectedImageBase64s.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _selectedImageBase64s.length) {
                          return GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.shade300,
                                    style: BorderStyle
                                        .values[1]), // Dashed approximation
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 32, color: Colors.grey.shade400),
                                  Text("Fotoğraf Ekle",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                          );
                        }
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                base64Decode(_selectedImageBase64s[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close,
                                      size: 12, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Services
                  _buildSectionHeader("Hizmet Menüsü"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ..._services
                            .map((service) => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: _buildInput(
                                          controller: null,
                                          initialValue: service.name,
                                          hintText: "Hizmet Adı",
                                          onChanged: (v) => service.name = v,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: _buildInput(
                                          controller: null,
                                          initialValue:
                                              service.price.toInt().toString(),
                                          hintText: "Fiyat",
                                          inputType: TextInputType.number,
                                          onChanged: (v) => service.price =
                                              double.tryParse(v) ?? 0,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 48,
                                        height: 56, // Match input height
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.grey),
                                          onPressed: () => setState(
                                              () => _services.remove(service)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        InkWell(
                          onTap: _addService,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300,
                                  style: BorderStyle.values[1]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle, color: _primaryColor),
                                const SizedBox(width: 8),
                                Text("Yeni Hizmet Ekle",
                                    style: TextStyle(
                                        color: _primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isLegalAccepted,
                          onChanged: (v) =>
                              setState(() => _isLegalAccepted = v!),
                          activeColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: _textColor, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: "Kullanım Koşulları",
                                  style: TextStyle(
                                      color: _primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                    text: "'nı okudum ve kabul ediyorum."),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Kaydı Tamamla",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 12),
      child: Text(title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
    );
  }

  Widget _buildLabeledInput({required String label, required Widget child}) {
    return SizedBox(
      width: double
          .infinity, // Constrain width in parent Wrap if needed, but defaults to full
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textColor)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController? controller,
    String? initialValue,
    required String hintText,
    IconData? icon,
    bool readOnly = false,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    Color? filledColor,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: filledColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: readOnly ? Colors.transparent : _borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              initialValue: initialValue,
              readOnly: readOnly,
              obscureText: isPassword,
              keyboardType: inputType,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: _placeholderColor),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: TextStyle(color: _textColor),
              validator: (v) => (v == null || v.isEmpty) ? 'Gerekli' : null,
            ),
          ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(icon, color: _placeholderColor),
            ),
        ],
      ),
    );
  }

  void _showOperatingHoursDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return StatefulBuilder(builder: (context, setModalState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Çalışma Saatleri",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _textColor)),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: _operatingHours.map((hours) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(hours.day,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500))),
                                Switch(
                                  value: hours.isOpen,
                                  onChanged: (val) {
                                    setModalState(() => hours.isOpen = val);
                                    setState(
                                        () {}); // Update main screen too if needed
                                  },
                                  activeColor: _primaryColor,
                                ),
                                if (hours.isOpen) ...[
                                  const SizedBox(width: 8),
                                  _buildTimePickBtn(
                                      context,
                                      hours.start,
                                      (t) =>
                                          setModalState(() => hours.start = t)),
                                  const Text(" - "),
                                  _buildTimePickBtn(
                                      context,
                                      hours.end,
                                      (t) =>
                                          setModalState(() => hours.end = t)),
                                ] else
                                  const Expanded(
                                      flex: 3,
                                      child: Text("Kapalı",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.grey))),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor),
                          child: const Text("Kaydet",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                );
              });
            });
      },
    );
  }

  Widget _buildTimePickBtn(
      BuildContext context, String time, Function(String) onPick) {
    return GestureDetector(
      onTap: () async {
        final parts = time.split(":");
        final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: int.parse(parts[0]), minute: int.parse(parts[1])));
        if (picked != null) {
          onPick(
              "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4)),
        child: Text(time),
      ),
    );
  }
}
