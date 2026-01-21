import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GpaTrajectoryData extends StatelessWidget {
  const GpaTrajectoryData({
    super.key,
    required this.semesters,
    required this.totalSemesters,
  });

  final List<Semester> semesters;
  final int totalSemesters;

  @override
  Widget build(BuildContext context) {
    // final authViewModel = Provider.of<AuthViewModel>(context);
    // final maxGrade = GradeCalculator.getMaxGrade(authViewModel.gradingScale);

    final List<FlSpot> gpaSpots = [];

    for (int i = 1; i <= totalSemesters; i++) {
      final semester = semesters.firstWhere(
        (s) => s.semesterNumber == i,
        orElse: () => Semester(semesterNumber: i, courses: []),
      );

      if (semester.courses.isNotEmpty) {
        final gpa = GradeCalculator.calculateGPA(semester.courses);
        gpaSpots.add(FlSpot(i.toDouble(), gpa));
      }
    }

    if (gpaSpots.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Add courses to see your trajectory',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.transparent,
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppColors.dark,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      'Semester ${spot.x.toInt()}\nGPA: ${spot.y.toStringAsFixed(2)}',
                      const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            minX: 1,
            maxX: totalSemesters.toDouble(),
            minY: 0.0,
            maxY: 4.0,
            // gridData: FlGridData(
            //   show: true,
            //   drawVerticalLine: false,
            //   horizontalInterval: maxGrade / 5,
            //   getDrawingHorizontalLine: (value) {
            //     return FlLine(
            //       color: Colors.grey.shade800,
            //       strokeWidth: 0.5,
            //     );
            //   },
            // ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 4.0 / 5,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value < 1 || value > totalSemesters) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'S${value.toInt()}',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: gpaSpots,
                isCurved: true,
                curveSmoothness: 0.3,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.primaryColorLight,
                      strokeWidth: 2,
                      strokeColor: Colors.white70,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColorLight.withOpacity(0.3),
                      AppColors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryColorLight,
                    AppColors.primaryColorLight,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
