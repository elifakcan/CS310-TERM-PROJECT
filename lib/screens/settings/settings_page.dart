import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/prefs_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/cart_provider.dart';
import '../../models/product.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PrefsProvider>();
    final auth = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================
              // PROFILE SECTION
              // ============================================
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Email
                      Text(
                        user?.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Statistics Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Favorites Count
                          StreamBuilder<List<Product>>(
                            stream: productProvider.streamMyFavorites(),
                            builder: (context, snap) {
                              final favoritesCount = snap.data?.length ?? 0;
                              return _buildStatCard(
                                context,
                                Icons.favorite,
                                'Favorites',
                                favoritesCount.toString(),
                                Colors.red,
                              );
                            },
                          ),
                          
                          // Dislikes Count
                          StreamBuilder<List<Product>>(
                            stream: productProvider.streamMyDislikes(),
                            builder: (context, snap) {
                              final dislikesCount = snap.data?.length ?? 0;
                              return _buildStatCard(
                                context,
                                Icons.close,
                                'Dislikes',
                                dislikesCount.toString(),
                                Colors.orange,
                              );
                            },
                          ),
                          
                          // Cart Count
                          _buildStatCard(
                            context,
                            Icons.shopping_bag,
                            'In Bag',
                            cartProvider.cartItems.length.toString(),
                            colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // ============================================
              // SETTINGS SECTION
              // ============================================
              Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              
              // DARK MODE
              Card(
                elevation: 1,
                child: SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  value: prefs.isDarkMode,
                  onChanged: (_) {
                    context.read<PrefsProvider>().toggleTheme();
                  },
                ),
              ),
              
              const SizedBox(height: 12),
              
              // CHANGE PASSWORD
              Card(
                elevation: 1,
                child: ListTile(
                  leading: Icon(Icons.lock, color: colorScheme.primary),
                  title: Text(
                    'Change Password',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // ============================================
              // LOGOUT BUTTON
              // ============================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                    // Navigator stack'ini tamamen temizle ve WelcomePage'e git
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.welcome,
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
