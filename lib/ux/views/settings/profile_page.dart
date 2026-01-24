import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/components/user_profile_picture.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/utils/utils.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthViewModel authViewModel = AppDI.getIt<AuthViewModel>();
  late TextEditingController fullNameController = TextEditingController();
  late TextEditingController schoolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = authViewModel.currentUser.value;
    fullNameController.text = user?.name ?? '';
    schoolController.text = user?.school ?? '';
  }

  Future<void> updateProfile() async {
    final user = authViewModel.currentUser.value;
    final currentName = user?.name ?? '';
    final currentSchool = user?.school ?? '';
    if (fullNameController.text.trim() == currentName &&
        schoolController.text.trim() == currentSchool) {
      AppDialogs.showErrorDialog(context,
          errorMessage: 'No changes detected to update.');
      return;
    }

    AppDialogs.showLoadingDialog(context);
    var request = UpdateUserProfileRequest(
      fullName: fullNameController.text.trim(),
      school: schoolController.text.trim(),
    );

    await authViewModel.updateProfile(request);
    if (!mounted) return;
    Navigation.back(context: context);
    handleUpdateProfileResult();
  }

  void handleUpdateProfileResult() {
    var result = authViewModel.updateProfileResult.value;
    if (result.isSuccess) {
      UiUtils.showToast(message: 'Profile updated successfully!');
    } else if (result.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: result.message ?? 'An unexpected error occurred.',
      );
    }
  }

  bool isButtonEnabled() {
    final user = authViewModel.currentUser.value;
    final currentName = user?.name ?? '';
    final currentSchool = user?.school ?? '';

    return fullNameController.text.trim() != currentName ||
        schoolController.text.trim() != currentSchool;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    schoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: const Divider(height: 2).asPreferredSize(height: 1),
        ),
        body: ValueListenableBuilder<AppUser?>(
          valueListenable: authViewModel.currentUser,
          builder: (context, user, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: UserProfilePicture(size: 140),
                      ),
                      const SizedBox(height: 28),
                      PrimaryTextFormField(
                        labelText: 'Full Name',
                        controller: fullNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                      ),
                      PrimaryTextFormField(
                        labelText: 'Institution Name',
                        controller: schoolController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PrimaryButton(
                    enabled: isButtonEnabled(),
                    onTap: updateProfile,
                    child: const Text('Save changes'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
