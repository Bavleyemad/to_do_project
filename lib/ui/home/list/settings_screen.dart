import 'package:flutter/material.dart';
import 'package:to_do_project/providers/settings_providers.dart';
import 'package:to_do_project/ui/widgets/theme_buttom_sheet.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      var settingsProvider = Provider.of<SettingsProvider>(context);
      return Padding(
        padding: EdgeInsets.only(top: 36, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: Theme.of(context).textTheme.titleMedium),
            Divider(height: 12),
            InkWell(
              onTap: () {
                showThemeButtonSheet(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                ),
                child: Text(
                  settingsProvider.isDarkEnabled()
                      ? 'Dark Theme'
                      : 'Light Theme',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: settingsProvider.isDarkEnabled()?Colors.black:Colors.black,
                  ),
                ),
              ),
            ),
            Divider(height: 12),
          ],
        ),
      );
    } catch (e) {
      return Center(
        child: Text(
          'An error occurred while loading settings: $e',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
  }

  void showThemeButtonSheet(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ThemeButtomSheet();
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open theme settings: $e'),
        ),
      );
    }
  }
}
