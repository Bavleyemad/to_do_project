import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_providers.dart';

class ThemeButtomSheet extends StatefulWidget {
  ThemeButtomSheet({super.key});

  @override
  State<ThemeButtomSheet> createState() => _ThemeButtomSheetState();
}

class _ThemeButtomSheetState extends State<ThemeButtomSheet> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                settingsProvider.changeTheme(ThemeMode.light);
              },
              child: settingsProvider.isDarkEnabled()
                  ? getUnselectedItem(context, 'Light Theme')
                  : getSelectedItem(context, 'Light Theme')),
          Divider(height: 24),
          InkWell(
              onTap: () {
                settingsProvider.changeTheme(ThemeMode.dark);
              },
              child: settingsProvider.isDarkEnabled()
                  ? getSelectedItem(context, 'Dark Theme')
                  : getUnselectedItem(context, 'Dark Theme')),
        ],
      ),
    );
  }

  Widget getSelectedItem(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget getUnselectedItem(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
