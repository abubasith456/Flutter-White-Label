import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final bool showBackButton;
  final bool
  showActionButton; // Added parameter to control action button visibility

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.onAction,
    this.actionIcon = Icons.delete_forever,
    this.showBackButton = true,
    this.showActionButton = false, // Default: Action button hidden
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack ?? () => Navigator.pop(context),
              )
              : null,
      actions:
          showActionButton
              ? [
                IconButton(
                  icon: Icon(actionIcon, color: Colors.white),
                  onPressed: onAction,
                ),
              ]
              : null, // Hide actions if `showActionButton` is false
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
