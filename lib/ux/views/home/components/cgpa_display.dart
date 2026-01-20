import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class CGPADisplay extends StatelessWidget {
  final double cgpa;
  final double maxGrade;
  final int totalCredits;

  const CGPADisplay({
    super.key,
    required this.cgpa,
    required this.maxGrade,
    required this.totalCredits,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColorGradientDark,
              AppColors.primaryColorGradientLight,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current CGPA'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textGrey2,
                        letterSpacing: 1.2,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.textGrey2.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.greyInputBorder,
                      width: 0.3,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+0.12',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.white,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  cgpa.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.white,
                        fontSize: 60,
                      ),
                ),
                Text(
                  'Target: ${maxGrade.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textGrey2,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GPADisplay extends StatelessWidget {
  final double gpa;
  final int maxcredits;

  const GPADisplay({
    super.key,
    required this.gpa,
    required this.maxcredits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Credits',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textGrey,
                        )),
                Text(
                  maxcredits.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('SGPA',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textGrey,
                      )),
              Text(
                gpa.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
