// import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
// import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
// import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';

// class SummaryView extends StatelessWidget {
//   const SummaryView({
//     super.key,
//     required this.nameController,
//     required this.selectedGradingScale,
//     required this.onNameTap,
//     required this.onGradingSystemTap,
//   });

//   final TextEditingController nameController;
//   final GradingScale selectedGradingScale;
//   final VoidCallback onNameTap;
//   final VoidCallback onGradingSystemTap;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: const BoxDecoration(
//               color: AppColors.dark2,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.check_circle_outline_rounded,
//               color: Colors.white70,
//               size: 48,
//             ),
//           ),
//           const SizedBox(height: 30),
//           Text(
//             "You're all set!",
//             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: AppColors.white,
//                 ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             'MyCGPA is ready to track your progress throughout your academic journey.',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   color: AppColors.textGrey,
//                   fontSize: 22,
//                 ),
//           ),
//           const SizedBox(height: 36),
//           Summary(
//             userName: nameController.text.trim(),
//             selectedScale: selectedGradingScale,
//             onNameTap: onNameTap,
//             onGradingSystemTap: onGradingSystemTap,
//           )
//         ],
//       ),
//     );
//   }
// }

// class Summary extends StatelessWidget {
//   const Summary({
//     super.key,
//     required this.userName,
//     required this.selectedScale,
//     required this.onNameTap,
//     required this.onGradingSystemTap,
//   });

//   final String userName;
//   final GradingScale selectedScale;
//   final VoidCallback onNameTap;
//   final VoidCallback onGradingSystemTap;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.dark2, width: 0.8),
//       ),
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           color: AppColors.cardBackground,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: AppColors.dark2, width: 0.8),
//         ),
//         child: Column(
//           children: [
//             summaryCard(
//               icon: Icons.person_rounded,
//               title: 'Student Name',
//               value: userName,
//               onTap: onNameTap,
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: DottedLine(
//                 dashColor: AppColors.dark2,
//               ),
//             ),
//             summaryCard(
//               icon: Icons.hourglass_top_rounded,
//               title: 'Grading System',
//               value: '${selectedScale.name} GPA',
//               onTap: onGradingSystemTap,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget summaryCard(
//       {required IconData icon,
//       required String title,
//       required String value,
//       required VoidCallback onTap}) {
//     return AppMaterial(
//       inkwellBorderRadius: BorderRadius.circular(14),
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: const BoxDecoration(
//                 color: AppColors.dark2,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 color: AppColors.primaryColor,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   color: AppColors.textGrey,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: AppColors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
