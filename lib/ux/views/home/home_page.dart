import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/views/home/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/home/components/gpa_trajectory.dart';
import 'package:cgpa_calculator/ux/views/home/components/stats_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CGPADisplay(
          cgpa: 3.75,
          maxGrade: 4.3,
          totalCredits: 84,
        ),
        const GpaTrajectory(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      iconBackgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.purpleBackground
                              : AppColors.purpleLight,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: StatsCard(
                      icon: Icons.bar_chart_rounded,
                      title: 'Highest GPA',
                      value: '3.90',
                      iconColor: AppColors.green,
                      iconBackgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.greenBackground
                              : AppColors.greenLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const StatsCardBig(),
            ],
          ),
        ),
        const SizedBox(height: 110),
      ],
    );
  }
}
