import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SearchTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool autofocus;
  final bool enabled;
  final VoidCallback onClear;
  final VoidCallback? onIconTap;

  const SearchTextFormField({
    super.key,
    this.controller,
    this.labelText = '',
    this.hintText = '',
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
    this.autofocus = false,
    this.maxLength,
    this.obscureText,
    this.onTap,
    this.onSubmitted,
    this.enabled = true,
    required this.onClear,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.dark
            ? AppColors.textFieldBackground
            : AppColors.field2),
        borderRadius: BorderRadius.circular(
          AppDimens.defaultBorderRadius,
        ),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.primaryColor
              : AppColors.transparentBackgroundLight,
          width: 1.2,
        ),
      ),
      child: TextField(
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        autofocus: autofocus,
        cursorColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.primaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
              top: (controller?.text.isEmpty ?? false) ? 0 : 6,
              left: 10,
              right: 10),
          hintText: hintText ?? 'Search',
          hintStyle: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 36, maxWidth: 36),
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 36, maxWidth: 36),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkResponse(
              radius: 8,
              onTap: onIconTap,
              child: Icon(
                Icons.arrow_back_rounded,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
          suffixIcon: Visibility(
            visible: controller?.text.isNotEmpty ?? false,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.cancel,
                  color: AppColors.greyInputBorder,
                  size: 15.5,
                ),
              ),
            ),
          ),
        ),
        inputFormatters: inputFormatters,
        keyboardType: TextInputType.text,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

class PrimaryTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool optional;
  final bool required;
  final bool readOnly;
  final bool greyedOut;
  final bool autofocus;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final bool hasBottomPadding;
  final Color? focusedColor;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Widget? labelTrailing;

  const PrimaryTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
    this.autofocus = false,
    this.maxLength,
    this.obscureText,
    this.onTap,
    this.enabled = true,
    this.optional = false,
    this.required = false,
    this.readOnly = false,
    this.greyedOut = false,
    this.textCapitalization,
    this.textInputAction,
    this.hasBottomPadding = true,
    this.focusedColor,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.focusNode,
    this.fillColor,
    this.labelTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: hasBottomPadding ? 16 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: labelText != null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        labelText ?? '',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Visibility(
                        visible: optional,
                        child: const Text(
                          ' (Optional)',
                          style: TextStyle(
                            color: Color.fromRGBO(154, 154, 154, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: required,
                        child: const Text(
                          '*',
                          style: TextStyle(
                            color: AppColors.red500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  labelTrailing ?? const SizedBox.shrink()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 55,
            child: TextFormField(
              focusNode:
                  focusNode ?? (readOnly ? AlwaysDisabledFocusNode() : null),
              readOnly: readOnly,
              enabled: enabled,
              autofocus: autofocus,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.primaryColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor ??
                    (enabled
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textFieldBackground
                            : AppColors.field2)
                        : AppColors.disabledButton),
                suffixIcon: suffixWidget,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                hintText: hintText ?? '',
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(166, 164, 164, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: enabledBorder ??
                    OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.defaultBorderRadius),
                      borderSide: greyedOut
                          ? BorderSide.none
                          : BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.primaryColor
                                  : AppColors.grey200,
                              width: 1.2,
                            ),
                    ),
                disabledBorder: disabledBorder ??
                    OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.defaultBorderRadius),
                      borderSide: const BorderSide(
                        color: AppColors.lightFontGrey,
                        width: 1.2,
                      ),
                    ),
                focusedBorder: focusedBorder ??
                    OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.defaultBorderRadius),
                      borderSide: greyedOut
                          ? BorderSide.none
                          : BorderSide(
                              color: focusedColor ??
                                  (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.primaryColor
                                      : AppColors.grey200),
                              width: 1.2,
                            ),
                    ),
                border: border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: greyedOut
                          ? BorderSide.none
                          : const BorderSide(
                              color: AppColors.borderColor,
                              width: 2.0,
                            ),
                    ),
              ),
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              validator: validator,
              controller: controller,
              onChanged: onChanged,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
            ),
          ),
        ],
      ),
    );
  }
}

class LongTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool autofocus;
  final bool required;
  final bool greyedOut;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;

  const LongTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.minLines = 5,
    this.maxLines,
    this.autofocus = false,
    this.required = false,
    this.greyedOut = false,
    this.maxLength,
    this.obscureText,
    this.onTap,
    this.enabled = true,
    this.textCapitalization,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: labelText != null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    labelText ?? '',
                    style: TextStyle(
                      color: AppColors.greyInputBorder,
                      fontSize: 14,
                      fontWeight: greyedOut ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                  Visibility(
                    visible: required,
                    child: const Text(
                      '*',
                      style: TextStyle(
                          color: AppColors.red500, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            autofocus: autofocus,
            minLines: minLines,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              filled: greyedOut,
              fillColor: enabled
                  ? (greyedOut ? AppColors.field2 : AppColors.transparent)
                  : AppColors.greyInputBorder,
              hintText: hintText ?? '',
              hintMaxLines: 3,
              hintStyle: const TextStyle(
                color: AppColors.greyInputBorder,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: greyedOut
                    ? BorderSide.none
                    : const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: greyedOut
                    ? BorderSide.none
                    : const BorderSide(color: AppColors.borderColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: greyedOut
                    ? BorderSide.none
                    : const BorderSide(
                        color: AppColors.borderColor, width: 2.0),
              ),
            ),
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            onChanged: onChanged,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            textInputAction: textInputAction,
          ),
        ],
      ),
    );
  }
}
