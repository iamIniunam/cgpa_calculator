import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dense;
  final bool showDivider;
  final bool isFirst;
  final bool isLast;

  const SettingTile({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
    this.dense = false,
    this.showDivider = true,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).appBarTheme.foregroundColor ?? AppColors.white;

    final tile = Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: dense ? 10 : 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: showDivider
              ? BorderSide(color: color.withOpacity(0.3), width: 0)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontSize: 16),
              ),
            ],
          ),
          trailing ??
              (onTap != null
                  ? Icon(Icons.chevron_right_rounded, color: color, size: 24)
                  : const SizedBox.shrink()),
        ],
      ),
    );

    final borderRadius = (isFirst || isLast)
        ? BorderRadius.vertical(
            top: isFirst ? const Radius.circular(32) : Radius.zero,
            bottom: isLast ? const Radius.circular(32) : Radius.zero,
          )
        : BorderRadius.zero;

    return onTap != null
        ? AppMaterial(
            borderRadius: borderRadius,
            inkwellBorderRadius: borderRadius,
            onTap: onTap,
            child: tile,
          )
        : tile;
  }
}
