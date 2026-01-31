import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dimens.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_theme.dart';
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

  ButtonStyle getStyle(BuildContext context) {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        const Size.fromHeight(55),
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
          fontWeight: FontWeight.bold,
          fontFamily: AppTheme.fontFamily,
          fontSize: 18,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.defaultBorderRadius),
          side: const BorderSide(
            color: AppColors.transparent,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).brightness == Brightness.dark
              ? AppColors.disabledButtonBgDark
              : AppColors.disabledButtonBgLight;
        }
        return backgroundColor; // Defer to the widget's default.
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).brightness == Brightness.dark
              ? AppColors.disabledButtonFgDark
              : AppColors.disabledButtonFgLight;
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
                style: getStyle(context),
                onPressed: enabled
                    ? () {
                        onTap?.call();
                      }
                    : null,
                child: child,
              ))
            : TextButton(
                style: getStyle(context),
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
  final double? borderWidth;

  const PrimaryOutlinedButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.transparent,
    this.foregroundColor = AppColors.primaryColor,
    this.borderColor = AppColors.primaryColor,
    this.overlayColor,
    this.enabled = true,
    this.contentPadding,
    this.borderWidth,
  });

  ButtonStyle getStyle(BuildContext context) {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        const Size.fromHeight(55),
      ),
      enableFeedback: true,
      overlayColor: MaterialStateColor.resolveWith((states) =>
          overlayColor ??
          (Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundGrey.withOpacity(0.11)
              : AppColors.backgroundGrey)),
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
          borderRadius: BorderRadius.circular(AppDimens.defaultBorderRadius),
          side: BorderSide(color: borderColor, width: borderWidth ?? 1),
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
          style: getStyle(context),
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
