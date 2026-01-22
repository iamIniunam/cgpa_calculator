import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AppImages.sampleProfileImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 106,
                              child: AppMaterial(
                                inkwellBorderRadius: BorderRadius.circular(16),
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppGradients.editImageBackground,
                                  ),
                                  child: const Icon(
                                    Iconsax.gallery_edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user?.name ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.school ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 38),
                            PrimaryTextFormField(
                              labelText: 'Full Name',
                              controller: fullNameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.words,
                            ),
                            PrimaryTextFormField(
                              labelText: 'Institution Name',
                              controller: schoolController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: PrimaryButton(
                      onTap: () {},
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
