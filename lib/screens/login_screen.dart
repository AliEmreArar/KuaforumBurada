import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Import MainScreen and AppState
import '../widgets/legal_consent_checkbox.dart';
import 'shop_register_screen.dart';
import 'shop_dashboard_screen.dart';
import 'category_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Enum to track the current view state
  LoginView _currentView = LoginView.initial;
  // ... (rest is same)

  // Login Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Register Controllers
  final _regNameController = TextEditingController();
  final _regSurnameController = TextEditingController();
  final _regAddressController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  bool _isLegalAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _regNameController.dispose();
    _regSurnameController.dispose();
    _regAddressController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  void _resetToInitial() {
    setState(() {
      _currentView = LoginView.initial;
      _clearControllers();
      _isLegalAccepted = false;
    });
  }

  void _clearControllers() {
    _emailController.clear();
    _passwordController.clear();
    _regNameController.clear();
    _regSurnameController.clear();
    _regAddressController.clear();
    _regEmailController.clear();
    _regPasswordController.clear();
  }

  void _handleCustomerLogin() {
    if (_formKey.currentState!.validate()) {
      final success = Provider.of<AppState>(context, listen: false).login(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const CategorySelectionScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('E-posta veya şifre hatalı.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _handleShopLogin() {
    if (_formKey.currentState!.validate()) {
      final success = Provider.of<AppState>(context, listen: false).loginShop(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Dükkan bulunamadı veya şifre hatalı.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _handleCustomerRegister() {
    if (_registerFormKey.currentState!.validate()) {
      if (!_isLegalAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Lütfen yasal metinleri onaylayın.'),
              backgroundColor: Colors.red),
        );
        return;
      }

      final success = Provider.of<AppState>(context, listen: false).register(
        _regNameController.text,
        _regSurnameController.text,
        _regAddressController.text,
        _regEmailController.text,
        _regPasswordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Kayıt başarılı! Lütfen giriş yapın.'),
              backgroundColor: Colors.green),
        );
        setState(() {
          _currentView = LoginView.customerLogin;
          // Pre-fill email for convenience
          _emailController.text = _regEmailController.text;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Bu e-posta adresi zaten kayıtlı.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Design specific colors for this screen
    final Color primaryColor = const Color(0xFF13A4EC); // Blue from design

    // If we are in initial view, we use the specific design layout
    if (_currentView == LoginView.initial) {
      return Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800', // Barber shop background placeholder
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.grey.shade900);
                },
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade900),
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                color:
                    const Color(0xFFF6F7F8).withOpacity(0.8), // Light overlay
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  // Logo Area
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                        Icon(Icons.content_cut, size: 48, color: primaryColor),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "KuaförSepeti'ne Hoş Geldiniz",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D171B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Buttons Area
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        _buildRoleButton(
                          text: 'Dükkan Sahibiyim',
                          icon: Icons.storefront,
                          color: const Color(0xFF0F172A), // Slate 900
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              _currentView = LoginView.shopOwner;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildRoleButton(
                          text: 'Müşteriyim',
                          icon: Icons.person,
                          color: primaryColor.withOpacity(0.9),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              _currentView = LoginView.customer;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Zaten bir hesabın var mı? ',
                              style: TextStyle(
                                color: const Color(0xFF4C809A),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentView = LoginView
                                      .customerLogin; // Default to customer login
                                });
                              },
                              child: Text(
                                'Giriş Yap',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Other views (Standard Forms)
    // Kept simple/functional but aligned with colors
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentView != LoginView.initial) ...[
                  // Simple header for other views
                  Icon(Icons.content_cut, size: 48, color: primaryColor),
                  const SizedBox(height: 16),
                ],
                if (_currentView == LoginView.shopOwner) ...[
                  const Text(
                    'Dükkan Sahibi Girişi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildButton(
                    text: 'Giriş Yapmak İstiyorum',
                    icon: Icons.login,
                    color: const Color(0xFF0F172A),
                    onPressed: () {
                      setState(() {
                        _currentView = LoginView.shopLogin;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    text: 'Dükkan Kaydı Oluşturmak İstiyorum',
                    icon: Icons.app_registration,
                    color: primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShopRegisterScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _resetToInitial,
                    child: const Text('Geri Dön'),
                  ),
                ] else if (_currentView == LoginView.shopLogin) ...[
                  _buildLoginForm(
                      isShop: true, primaryColor: const Color(0xFF0F172A)),
                ] else if (_currentView == LoginView.customer) ...[
                  const Text(
                    'Müşteri Girişi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildButton(
                    text: 'Giriş Yap',
                    icon: Icons.login,
                    color: primaryColor,
                    onPressed: () {
                      setState(() {
                        _currentView = LoginView.customerLogin;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    text: 'Kayıt Ol',
                    icon: Icons.person_add,
                    color: const Color(0xFF0F172A),
                    onPressed: () {
                      setState(() {
                        _currentView = LoginView.customerRegister;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _resetToInitial,
                    child: const Text('Geri Dön'),
                  ),
                ] else if (_currentView == LoginView.customerLogin) ...[
                  _buildLoginForm(isShop: false, primaryColor: primaryColor),
                ] else if (_currentView == LoginView.customerRegister) ...[
                  _buildRegisterForm(primaryColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String text,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildLoginForm({required bool isShop, required Color primaryColor}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            isShop ? 'Dükkan Girişi' : 'Müşteri Girişi',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'E-posta Adresi',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen e-posta adresinizi girin';
              }
              if (!value.contains('@')) {
                return 'Geçerli bir e-posta adresi girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Şifre',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen şifrenizi girin';
              }
              if (value.length < 6) {
                return 'Şifre en az 6 karakter olmalıdır';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isShop ? _handleShopLogin : _handleCustomerLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Giriş Yap',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _currentView =
                    isShop ? LoginView.shopOwner : LoginView.customer;
              });
            },
            child: const Text('Geri Dön'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(Color primaryColor) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          const Text(
            'Müşteri Kaydı',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _regNameController,
            decoration: const InputDecoration(
              labelText: 'Ad',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Lütfen adınızı girin' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _regSurnameController,
            decoration: const InputDecoration(
              labelText: 'Soyad',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Lütfen soyadınızı girin'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _regAddressController,
            decoration: const InputDecoration(
              labelText: 'Adres',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Lütfen adresinizi girin'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _regEmailController,
            decoration: const InputDecoration(
              labelText: 'E-posta Adresi',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen e-posta adresinizi girin';
              }
              if (!value.contains('@')) {
                return 'Geçerli bir e-posta adresi girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _regPasswordController,
            decoration: const InputDecoration(
              labelText: 'Şifre',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen şifrenizi girin';
              }
              if (value.length < 6) {
                return 'Şifre en az 6 karakter olmalıdır';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          LegalConsentCheckbox(
            isChecked: _isLegalAccepted,
            onChanged: (val) {
              setState(() {
                _isLegalAccepted = val ?? false;
              });
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLegalAccepted ? _handleCustomerRegister : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Kayıt Ol',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _currentView = LoginView.customer;
              });
            },
            child: const Text('Geri Dön'),
          ),
        ],
      ),
    );
  }
}

enum LoginView {
  initial,
  shopOwner,
  shopLogin,
  customer,
  customerLogin,
  customerRegister,
}
