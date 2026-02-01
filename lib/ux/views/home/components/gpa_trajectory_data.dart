import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GpaTrajectoryData extends StatelessWidget {
  const GpaTrajectoryData({
    super.key,
    required this.semesters,
    required this.totalSemesters,
    this.maxGradePoint,
  });

  final List<Semester> semesters;
  final int totalSemesters;
  final double? maxGradePoint;

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> gpaSpots = [];

    for (int i = 0; i < semesters.length; i++) {
      final semester = semesters[i];
      double gpa = semester.semesterGPA ?? 0.0;
      gpaSpots.add(FlSpot((i + 1).toDouble(), gpa));
    }

    if (gpaSpots.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            AppStrings.addCoursesToSeeYourTrajectory,
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
      );
    }

    final double effectiveMaxGrade =
        (maxGradePoint ?? 5.0) <= 0 ? 5.0 : maxGradePoint ?? 5.0;
    final double yInterval = effectiveMaxGrade / 5;

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
            minX: 0,
            maxX: totalSemesters.toDouble() + 1,
            minY: 0.0,
            maxY: effectiveMaxGrade,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              horizontalInterval: yInterval,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.greyInputBorder.withOpacity(0.3)
                      : AppColors.grey400.withOpacity(0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.greyInputBorder.withOpacity(0.3)
                      : AppColors.grey400.withOpacity(0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.greyInputBorder.withOpacity(0.5)
                    : AppColors.greyInputBorder,
                width: 1,
              ),
            ),
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
                  reservedSize: 30,
                  interval: yInterval,
                  getTitlesWidget: (value, meta) {
                    if (value < 0 || value > (effectiveMaxGrade)) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textGrey
                              : AppColors.grey400,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value < 1 || value > totalSemesters) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'S${value.toInt()}',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textGrey
                              : AppColors.grey400,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
                preventCurveOverShooting: true,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.primaryColorLight,
                      strokeWidth: 2.5,
                      strokeColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.white.withOpacity(0.9)
                              : Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColorLight.withOpacity(0.3),
                      AppColors.primaryColorLight.withOpacity(0.1),
                      AppColors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryColorGradientLight,
                    AppColors.primaryColorLight,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
