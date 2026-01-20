import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/dev_credits.dart';
import 'package:cgpa_calculator/ux/shared/components/slide_indicator.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_dialogs.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/components/grading_system_view.dart';
import 'package:cgpa_calculator/ux/views/onboarding/components/login_view.dart';
import 'package:cgpa_calculator/ux/views/onboarding/components/summary_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({Key? key}) : super(key: key);

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final TextEditingController nameController = TextEditingController();
  final Duration _slideAnimationDuration = const Duration(milliseconds: 500);
  final Duration _slideAnimationDuration2 = const Duration(milliseconds: 800);
  GradingScale selectedGradingScale = GradingScale.scale43;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void handleLogin() async {
    FocusScope.of(context).unfocus();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (nameController.text.isEmpty) {
      AppDialogs.showErrorDialog(context,
          errorMessage: 'Please enter your name to continue.');
      return;
    }

    AppDialogs.showLoadingDialog(context);
    await authViewModel.login(nameController.text.trim(), selectedGradingScale);
    if (!mounted) return;
    Navigation.back(context: context);
    if (authViewModel.loginResult.value.isSuccess) {
      Navigation.navigateToHomePage(context: context);
    } else if (authViewModel.loginResult.value.isError) {
      AppDialogs.showErrorDialog(
        context,
        errorMessage: authViewModel.loginResult.value.message ??
            'Failed to save your information',
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideList = [
      LoginView(controller: nameController, isEdit: _isEditingName),
      GradingSystemView(
        selectedScale: selectedGradingScale,
        onScaleChanged: (scale) {
          setState(() {
            selectedGradingScale = scale;
          });
        },
      ),
      SummaryView(
        nameController: nameController,
        selectedGradingScale: selectedGradingScale,
        onNameTap: () {
          _isEditingName = true;
          _pageController.animateToPage(
            0,
            duration: _slideAnimationDuration2,
            curve: Curves.easeInOut,
          );
        },
        onGradingSystemTap: () {
          _pageController.animateToPage(
            1,
            duration: _slideAnimationDuration,
            curve: Curves.easeInOut,
          );
        },
      ),
    ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: SlideIndicator(
            selectedIndex: _currentPage,
            slideList: slideList,
          ),
          automaticallyImplyLeading: false,
          leading: _currentPage > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: _slideAnimationDuration,
                      curve: Curves.easeInOut,
                    );
                  },
                )
              : null,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView.builder(
                padEnds: false,
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemBuilder: (context, index) {
                  return slideList[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: PrimaryButton(
                onTap: () {
                  if (_currentPage == 2) {
                    handleLogin();
                  } else {
                    FocusScope.of(context).unfocus();
                    _pageController.nextPage(
                      duration: _slideAnimationDuration,
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: const Text(AppStrings.continueText),
              ),
            ),
            const DevCredits(),
          ],
        ),
      ),
    );
  }
}
