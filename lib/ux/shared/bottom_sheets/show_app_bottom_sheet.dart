import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dimens.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:flutter/material.dart';

Future showAppBottomSheet({
  required BuildContext? context,
  required Widget child,
  String? title,
  String? closeText,
  bool showCloseButton = true,
  bool isDismissible = true,
  bool isScrollControlled = true,
}) async {
  if (context == null) {
    return;
  }
  return await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    enableDrag: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppDimens.defaultBorderRadius),
        topRight: Radius.circular(AppDimens.defaultBorderRadius),
      ),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.defaultBorderRadius),
                      topRight: Radius.circular(AppDimens.defaultBorderRadius),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // title and close button
                      Visibility(
                        visible: title != null || showCloseButton,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Visibility(
                                  visible: title != null,
                                  child: Text(
                                    title ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Visibility(
                                visible: showCloseButton,
                                child: Material(
                                  color: AppColors.transparent,
                                  child: Ink(
                                    color: AppColors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () {
                                        Navigation.back(context: context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child:
                                            AppImages.svgCloseBottomSheetIcon,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // content
                      SafeArea(child: child),

                      // space
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
