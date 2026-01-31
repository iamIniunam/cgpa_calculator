import 'dart:io';

import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_image_widget.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/utils/utils.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ViewProfileImagePage extends StatefulWidget {
  const ViewProfileImagePage({super.key, this.isEditMode = false});

  final bool isEditMode;

  @override
  State<ViewProfileImagePage> createState() => _ViewProfileImagePageState();
}

class _ViewProfileImagePageState extends State<ViewProfileImagePage> {
  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();
  File? newProfileImage;

  @override
  void initState() {
    super.initState();
    _authViewModel.updateProfileResult
        .addListener(onProfileImageUpdateResultChange);
    // if (widget.isEditMode) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     selectNewProfilePhoto();
    //   });
    // }
  }

  void onProfileImageUpdateResultChange() async {
    if (!mounted) return;
    var result = _authViewModel.updateProfileResult.value;
    if (result.isLoading) {
      AppDialogs.showLoadingDialog(context);
    } else if (result.isSuccess) {
      await NetworkImage(
        _authViewModel.currentUser.value?.profilePicture ?? '',
      ).evict();
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {});
      Navigation.back(context: context);
      UiUtils.showToast(message: 'Profile picture updated!');
    } else if (result.isError) {
      Navigation.back(context: context);
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? 'An unexpected error occurred.',
      );
    }
  }

  // Future selectNewProfilePhoto() async {
  //   ImageSource? imageSource = await showAppBottomSheet(
  //     context: context,
  //     title: 'Choose Picture',
  //     child: const ChoosePhotoBottomSheet(),
  //   );
  //   if (imageSource != null) {
  //     File? newProfileImage =
  //         await ImageUtils.selectAndCropImageFromSource(source: imageSource);
  //     if (newProfileImage != null) {
  //       _authViewModel.updateProfile(
  //         UpdateUserProfileRequest(profilePicture: newProfileImage),
  //       );
  //     }
  //   }
  // }

  @override
  void dispose() {
    _authViewModel.updateProfileResult
        .removeListener(onProfileImageUpdateResultChange);
    _authViewModel.updateProfileResult.value = UIResult.empty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
        bottom: const Divider(height: 2).asPreferredSize(height: 1),
      ),
      body: ColoredBox(
        color: AppColors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: "profile",
                    child: Container(
                      alignment: Alignment.center,
                      child: Visibility(
                        replacement: AppImageWidget.local(
                          height: double.infinity,
                          width: double.infinity,
                          image: AppImages.profilePlaceholder,
                          showPlaceHolder: false,
                        ),
                        child: AppImageWidget(
                          showPlaceHolder: false,
                          baseUrl: _authViewModel.currentUser.value
                              ?.displayProfileImageBaseUrl(),
                          imageUrl: _authViewModel.currentUser.value
                              ?.displayProfileImageUrl(),
                          height: double.infinity,
                          width: double.infinity,
                          boxFit: BoxFit.cover,
                          borderRadius: 0,
                          placeHolder: null,
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                // AppMaterial(
                //   inkwellBorderRadius:
                //       const BorderRadius.all(Radius.circular(10)),
                //   onTap: selectNewProfilePhoto,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.white),
                //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                //     ),
                //     padding: const EdgeInsets.all(7),
                //     child: const Row(mainAxisSize: MainAxisSize.min, children: [
                //       Icon(
                //         Icons.edit,
                //         color: Colors.white,
                //         size: 20,
                //       ),
                //       SizedBox(
                //         width: 5,
                //       ),
                //       Text(
                //         'Change picture',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ]),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
