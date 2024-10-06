// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pigen_vpn/colors.dart';
import 'package:pigen_vpn/customText.dart';

// Custom AppBar Widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback onPressed;
  final Icon leadingIcon;
  List<Widget> actionIcon = [];

  // Constructor for custom actions
  CustomAppBar({
    Key? key,
    required this.titleText,
    required this.onPressed,
    this.leadingIcon = const Icon(
      CupertinoIcons.globe,
      color: AppColors.primaryColor,
      size: 30,
    ),
    required this.actionIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      centerTitle: true,
      title: CustomText(
        text: titleText,
        color: AppColors.primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: leadingIcon,
          onPressed: onPressed,
        ),
      ),
      actions: actionIcon,
    );
  }

  // Override preferredSize to define AppBar size
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
