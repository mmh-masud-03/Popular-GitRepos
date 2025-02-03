import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';


class CustomDrawer extends ConsumerWidget {
  final VoidCallback onAllRepositoriesTap;
  final VoidCallback onFavoritesTap;

  const CustomDrawer({
    Key? key,
    required this.onAllRepositoriesTap,
    required this.onFavoritesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current theme mode
    final themeMode = ref.watch(themeProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Popular GitRepos",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your GitHub Explorer",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Theme Toggle
          ListTile(
            leading: Icon(Icons.brightness_6, color: Theme.of(context).iconTheme.color),
            title: const Text("Toggle Theme"),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeProvider.notifier).state =
                value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),

          // All Repositories
          ListTile(
            leading: Icon(Icons.list, color: Theme.of(context).iconTheme.color),
            title: const Text("All Repositories"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              onAllRepositoriesTap();
            },
          ),

          // Favorite Repositories
          ListTile(
            leading: Icon(Icons.star, color: Theme.of(context).iconTheme.color),
            title: const Text("Favorite Repositories"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              onFavoritesTap();
            },
          ),
        ],
      ),
    );
  }
}