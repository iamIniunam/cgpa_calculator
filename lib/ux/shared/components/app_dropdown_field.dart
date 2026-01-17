import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropdownField extends StatelessWidget {
  final List<String>? items;
  final List<DropdownMenuItem<dynamic>>? dropdownItems;
  final bool stringItems;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final String? hintText;
  final String? labelText;
  final dynamic valueHolder;
  final Widget? prefixWidget;
  final Color? fillColor;
  final bool hasFill;
  final bool required;
  final Widget? itemsIcon;
  final bool enabled;

  const AppDropdownField({
    super.key,
    this.items,
    this.stringItems = true,
    this.dropdownItems,
    this.onChanged,
    this.hintText,
    this.prefixWidget,
    this.fillColor,
    this.hasFill = false,
    this.required = false,
    this.validator,
    this.valueHolder,
    this.labelText,
    this.itemsIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: labelText != null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  labelText ?? '',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Visibility(
                  visible: required,
                  child: const Text(
                    '*',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 54, 36, 0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          child: DropdownButtonFormField2<dynamic>(
            isExpanded: true,
            validator: validator,
            value: valueHolder,
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Nunito',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            hint: Text(
              hintText ?? '',
              style: const TextStyle(
                color: Color.fromRGBO(166, 164, 164, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color:
                    enabled ? AppColors.primaryColor : AppColors.disabledBorder,
              ),
              iconSize: 30,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    enabled ? AppColors.transparent : AppColors.disabledButton,
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: enabled
                        ? AppColors.primaryColor
                        : AppColors.disabledBorder,
                  ),
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              elevation: 0,
              maxHeight: 150,
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            decoration: InputDecoration(
              enabled: enabled,
              filled: true,
              fillColor:
                  enabled ? AppColors.transparent : AppColors.disabledButton,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color.fromRGBO(166, 164, 164, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: enabled
                      ? AppColors.primaryColor
                      : AppColors.disabledBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: enabled
                      ? AppColors.primaryColor
                      : AppColors.disabledBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: stringItems == true
                ? (items ?? [])
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Row(
                            children: [
                              Visibility(
                                visible: itemsIcon != null,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: itemsIcon,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList()
                : (dropdownItems ?? []),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
