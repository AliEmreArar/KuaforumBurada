import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // For AppState
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = const Color(0xFFFF8A65); // Orange
    final Color backgroundColor = const Color(0xFFF7F8FA);
    final Color textColorDark = const Color(0xFF333333);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AppState>(
            builder: (context, appState, _) {
              return Column(
                children: [
                  const SizedBox(height: 32),
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10)
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(appState.userProfile
                                          .profilePhotoUrl.isNotEmpty
                                      ? appState.userProfile.profilePhotoUrl
                                      : "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200"),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.grey.shade300,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    _showSettingsDialog(context, appState),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${appState.userProfile.name} ${appState.userProfile.surname}",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColorDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.userProfile.email,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Menu Options
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          Icons.settings_outlined,
                          "Ayarlar",
                          textColorDark,
                          onTap: () => _showSettingsDialog(context, appState),
                        ),
                        _buildDivider(),
                        _buildProfileOption(
                          Icons.location_on_outlined,
                          "Adreslerim",
                          textColorDark,
                          onTap: () => _showAddressList(context),
                        ),
                        _buildDivider(),
                        _buildProfileOption(
                          Icons.local_offer_outlined,
                          "Promosyon Kodlarım",
                          textColorDark,
                          onTap: () => _showPromoCodesDialog(context, appState),
                        ),
                        _buildDivider(),
                        _buildProfileOption(
                          Icons.lock_outline,
                          "Şifre Değiştir",
                          textColorDark,
                          onTap: () =>
                              _showPasswordChangeDialog(context, appState),
                        ),
                        _buildDivider(),
                        _buildProfileOption(
                          Icons.color_lens_outlined,
                          "Tema Değiştir",
                          textColorDark,
                          onTap: () => _showThemeChangeDialog(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ],
                    ),
                    child: _buildProfileOption(
                      Icons.logout,
                      "Çıkış Yap",
                      Colors.red,
                      onTap: () {
                        appState.logout();
                        // Assuming LoginScreen is the initial route or handled by main wrapper
                        // If we are in HomeScreen (Stack), we might need to navigate
                        // For now, let's assume appState changes trigger UI updates or we push
                        // Since HomeScreen is main, we probably need to pushReplacement or restart app.
                        // However, usually logout resets state.
                        // Let's perform a simple check. If we are in a Navigation stack, pop to root.
                        // But here we are likely at root.
                        // Let's show a snackbar for now or navigate to a login screen if it existed separately.
                        // Since I don't see LoginScreen being pushed, I will just show message.
                        // Wait, I see 'screens/login_screen.dart' in file list.
                        // I will navigate to LoginScreen.
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const LoginScreen()));
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, AppState appState) {
    final nameController =
        TextEditingController(text: appState.userProfile.name); // Read only
    final surnameController =
        TextEditingController(text: appState.userProfile.surname); // Read only
    final emailController =
        TextEditingController(text: appState.userProfile.email);
    final phoneController =
        TextEditingController(text: appState.userProfile.phone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Profil Ayarları"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: "Ad (Değiştirilemez)"),
                readOnly: true,
                enabled: false,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: surnameController,
                decoration:
                    const InputDecoration(labelText: "Soyad (Değiştirilemez)"),
                readOnly: true,
                enabled: false,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "E-posta"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Telefon"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              appState.updateProfile(UserProfile(
                name: appState.userProfile.name,
                surname: appState.userProfile.surname,
                email: emailController.text,
                phone: phoneController.text,
                address: appState.userProfile.address, // Keep current
                password: appState.userProfile.password,
                profilePhotoUrl: appState.userProfile.profilePhotoUrl,
                addresses: appState.userProfile.addresses,
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil güncellendi")));
            },
            child: const Text("Kaydet"),
          )
        ],
      ),
    );
  }

  void _showPromoCodesDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Promosyon Kodları"),
        content: SizedBox(
          width: double.maxFinite,
          child: appState.campaigns.isEmpty
              ? const Text("Aktif kampanya bulunmamaktadır.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: appState.campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = appState.campaigns[index];
                    return ListTile(
                      title: Text(campaign.code,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.teal)),
                      subtitle:
                          Text("${campaign.title} - ${campaign.description}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          // Copy to clipboard logic or just info
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "${campaign.code} kodu kopyalandı (simüle)!")));
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Kapat")),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog(BuildContext context, AppState appState) {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Şifre Değiştir"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              decoration: const InputDecoration(labelText: "Mevcut Şifre"),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassController,
              decoration: const InputDecoration(labelText: "Yeni Şifre"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              if (oldPassController.text == appState.userProfile.password) {
                appState.userProfile.password = newPassController.text;
                // Ideally trigger save
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Şifre başarıyla değiştirildi")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Mevcut şifre hatalı"),
                    backgroundColor: Colors.red));
              }
            },
            child: const Text("Değiştir"),
          )
        ],
      ),
    );
  }

  void _showThemeChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tema Değiştir"),
        content: const Text(
            "Tema değiştirme özelliği yakında eklenecektir. Şu anda sadece Aydınlık mod kullanılabilir."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Tamam")),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, Color color,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100);
  }

  void _showAddressList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Consumer<AppState>(
        builder: (context, appState, _) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kayıtlı Adreslerim",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.pop(ctx);
                        // Trigger add address logic from here if needed, or simple show dialog
                        // For now, simple dialog
                        _showAddAddressDialog(context, appState);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                if (appState.userProfile.addresses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("Henüz kayıtlı adresiniz yok.")),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: appState.userProfile.addresses.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final address = appState.userProfile.addresses[index];
                        final isSelected =
                            address == appState.userProfile.address;
                        return ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.location_on_outlined,
                            color: isSelected
                                ? const Color(0xFF00796B)
                                : Colors.grey,
                          ),
                          title: Text(address),
                          subtitle: isSelected
                              ? const Text("Seçili Adres",
                                  style: TextStyle(
                                      color: Color(0xFF00796B), fontSize: 12))
                              : null,
                          onTap: () {
                            appState.updateCurrentAddress(address);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, AppState appState) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Yeni Adres Ekle"),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: "Adres giriniz..."),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("İptal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      appState.addAddress(_controller.text);
                      Navigator.pop(ctx);
                      // Re-open list to show new address if desired, but nice to just finish
                    }
                  },
                  child: const Text("Ekle"),
                )
              ],
            ));
  }
}
