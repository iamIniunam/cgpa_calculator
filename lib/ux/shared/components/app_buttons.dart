import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color? overlayColor;
  final bool enabled;
  final EdgeInsets? contentPadding;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.overlayColor,
    this.enabled = true,
    this.expand = true,
    this.contentPadding,
  });

  ButtonStyle getStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        const Size.fromHeight(45),
      ),
      enableFeedback: true,
      overlayColor: MaterialStateColor.resolveWith((states) =>
          overlayColor ?? AppColors.backgroundGrey.withOpacity(0.2)),
      padding: MaterialStateProperty.all(
        contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: AppColors.transparent,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.disabledButton;
        }
        return backgroundColor; // Defer to the widget's default.
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey;
        }
        return foregroundColor; // Defer to the widget's default.
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        expand
            ? Expanded(
                child: TextButton(
                style: getStyle(),
                onPressed: enabled
                    ? () {
                        onTap?.call();
                      }
                    : null,
                child: child,
              ))
            : TextButton(
                style: getStyle(),
                onPressed: enabled
                    ? () {
                        onTap?.call();
                      }
                    : null,
                child: child,
              )
      ],
    );
  }
}

class PrimaryOutlinedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color? overlayColor;
  final bool enabled;
  final EdgeInsets? contentPadding;

  const PrimaryOutlinedButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.white,
    this.foregroundColor = AppColors.primary500,
    this.borderColor = AppColors.primary500,
    this.overlayColor,
    this.enabled = true,
    this.contentPadding,
  });

  ButtonStyle getStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        const Size.fromHeight(45),
      ),
      enableFeedback: true,
      overlayColor: MaterialStateColor.resolveWith(
          (states) => overlayColor ?? AppColors.backgroundGrey),
      padding: MaterialStateProperty.all(
        contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.primary500,
        ),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.greyInputBorder;
        }
        return backgroundColor; // Defer to the widget's default.
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.lightFontGrey;
          }
          return foregroundColor; // Defer to the widget's default.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextButton(
          style: getStyle(),
          onPressed: enabled
              ? () {
                  onTap?.call();
                }
              : null,
          child: child,
        )),
      ],
    );
  }
}
