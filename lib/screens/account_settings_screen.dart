import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cardController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppState>(context, listen: false).userProfile;
    _addressController = TextEditingController(text: user.address);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _cardController = TextEditingController(text: user.creditCardNumber);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final state = Provider.of<AppState>(context, listen: false);
      // We need to create a copy or update the existing object carefully.
      // Since UserProfile is mutable in this app, we can update fields directly.
      // But to trigger notifyListeners, we call updateProfile.
      final currentUser = state.userProfile;
      currentUser.address = _addressController.text;
      currentUser.phone = _phoneController.text;
      currentUser.email = _emailController.text;
      currentUser.creditCardNumber = _cardController.text;

      state.updateProfile(currentUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bilgiler güncellendi'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).userProfile;
    return Scaffold(
      appBar: AppBar(title: const Text('Hesap Ayarları')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: '${user.name} ${user.surname}',
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
              readOnly: true,
              enabled: false,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adres'),
              validator: (val) => val!.isEmpty ? 'Gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
              keyboardType: TextInputType.phone,
              validator: (val) => val!.isEmpty ? 'Gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta Adresi'),
              keyboardType: TextInputType.emailAddress,
              validator: (val) =>
                  !val!.contains('@') ? 'Geçersiz e-posta' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardController,
              decoration:
                  const InputDecoration(labelText: 'Ödeme Bilgisi (Kart No)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
