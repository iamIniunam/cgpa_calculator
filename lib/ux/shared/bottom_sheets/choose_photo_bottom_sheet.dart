import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChoosePhotoBottomSheet extends StatelessWidget {
  const ChoosePhotoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        singleOption(
            context: context,
            title: AppStrings.uploadFromGallery,
            icon: Icons.photo_library_rounded,
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            }),
        singleOption(
            context: context,
            title: AppStrings.takePicture,
            icon: Icons.camera_alt_rounded,
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            })
      ],
    );
  }

  Widget singleOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AppMaterial(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryColor
                  : AppColors.dark,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
