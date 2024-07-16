import 'package:flutter/material.dart';

class SettingsList extends StatelessWidget {
  final String listName;
  final List<Widget> children;

  const SettingsList({super.key, required this.listName, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listName,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        ...children,
      ],
    );
  }
}
