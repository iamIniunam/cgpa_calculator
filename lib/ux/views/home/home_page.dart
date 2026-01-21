import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/views/home/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/home/components/gpa_trajectory.dart';
import 'package:cgpa_calculator/ux/shared/view_models/cgpa_view_model.dart';
import 'package:cgpa_calculator/ux/views/home/components/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // void _showGradingScaleDialog(BuildContext context, CGPAViewModel viewModel) {
  //   final data = viewModel.cgpaDataResult.value.data;
  //   showDialog(
  //     context: context,
  //     builder: (context) => GradingScaleDialog(
  //       currentScale: data?.selectedScale ?? GradingScale.scale43,
  //       onScaleChanged: (scale) {
  //         if (scale != null) viewModel.changeGradingScale(scale);
  //       },
  //     ),
  //   );
  // }

  // void _showCourseDurationDialog(
  //     BuildContext context, CGPAViewModel viewModel) {
  //   final data = viewModel.cgpaDataResult.value.data;
  //   showDialog(
  //     context: context,
  //     builder: (context) => CourseDurationDialog(
  //       currentDuration: data?.selectedDuration ?? CourseDuration.fourYears,
  //       onCourseDurationChanged: (duration) {
  //         if (duration != null) viewModel.changeCourseDuration(duration);
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<CGPAViewModel>(context);
    // final authViewModel = Provider.of<AuthViewModel>(context);
    return ListView(
      children: const [
        CGPADisplay(
          cgpa: 3.75,
          maxGrade: 4.3,
          totalCredits: 84,
        ),
        GpaTrajectory(),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      icon: Icons.school_rounded,
                      title: 'Total Credits',
                      value: '84',
                      iconColor: AppColors.purple,
                      iconBackgroundColor: AppColors.purpleBackground,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: StatsCard(
                      icon: Icons.bar_chart_rounded,
                      title: 'Highest GPA',
                      value: '3.90',
                      iconColor: AppColors.green,
                      iconBackgroundColor: AppColors.greenBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              StatsCard(
                icon: Icons.track_changes_rounded,
                title: 'Target',
                value: '4.30',
                iconColor: AppColors.blue,
                iconBackgroundColor: AppColors.blueBackground,
                width: double.infinity,
              ),
            ],
          ),
        ),
        SizedBox(height: 110),
      ],
    );
  }
}
