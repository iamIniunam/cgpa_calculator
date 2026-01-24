import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/shared/components/app_image_widget.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';

class UserProfilePicture extends StatelessWidget {
  UserProfilePicture(
      {super.key, required this.size, this.onTap, this.noPictureWidget});

  final double size;
  final VoidCallback? onTap;
  final Widget? noPictureWidget;
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ValueListenableBuilder(
        valueListenable: _authViewModel.currentUser,
        builder: (context, user, _) {
          if (user == null || user.hasProfilePicture() == false) {
            return noPictureWidget ??
                AppImageWidget.local(
                  image: AppImages.profilePlaceholder,
                  height: size,
                  width: size,
                );
          } else {
            return AppImageWidget(
              baseUrl: user.displayProfileImageBaseUrl(),
              imageUrl: user.displayProfileImageUrl(),
              placeHolder: AppImages.profilePlaceholder,
              errorImage: AppImages.profilePlaceholder,
              height: size,
              width: size,
              borderRadius: 100,
            );
          }
        },
      ),
    );
  }
}
