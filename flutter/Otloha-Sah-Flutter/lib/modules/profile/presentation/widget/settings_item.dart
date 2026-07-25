import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key? key,
    required this.title,
    required this.action,
    required this.icon,
  }) : super(key: key);

  final String title;
  final Function() action;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(
              0,
              3.0,
            ),
            blurRadius: 6.0,
            spreadRadius: 0.2,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColor.txtColor3,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColor.txtGrayColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: action,
      ),
    );
  }
}
