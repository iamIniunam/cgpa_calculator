import 'package:cgpa_calculator/models/ui_models.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String courseName;
  final int creditHours;
  final double grade;
  final List<GradeOption> gradeOptions;
  final VoidCallback onDelete;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int?> onCreditHoursChanged;
  final ValueChanged<double?> onGradeChanged;

  const CourseCard({
    Key? key,
    required this.courseName,
    required this.creditHours,
    required this.grade,
    required this.gradeOptions,
    required this.onDelete,
    required this.onNameChanged,
    required this.onCreditHoursChanged,
    required this.onGradeChanged,
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late TextEditingController nameController = TextEditingController();
  bool isLocked = false;
  final FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.courseName);
    // Auto-lock if course has a name
    isLocked = widget.courseName.trim().isNotEmpty;
  }

  @override
  void didUpdateWidget(CourseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseName != widget.courseName) {
      nameController.text = widget.courseName;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  void toggleLock() {
    setState(() {
      isLocked = !isLocked;
      if (!isLocked) {
        // Focus on name field when unlocking
        Future.delayed(const Duration(milliseconds: 100), () {
          nameFocusNode.requestFocus();
        });
      }
    });
  }

  void handleDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text(
          widget.courseName.isEmpty
              ? 'Delete this course?'
              : 'Delete ${widget.courseName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmptyCourse = widget.courseName.trim().isEmpty;

    return Card(
      color: isLocked
          ? Colors.grey.shade900
          : Colors.blue.shade900.withOpacity(0.3),
      elevation: isLocked ? 1 : 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLocked ? Colors.transparent : Colors.blue.shade700,
          width: isLocked ? 0 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Name Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    focusNode: nameFocusNode,
                    enabled: !isLocked,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLocked ? Colors.white : Colors.blue.shade100,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      labelStyle: TextStyle(
                        color: isLocked
                            ? Colors.grey.shade500
                            : Colors.blue.shade300,
                      ),
                      hintText: 'e.g., MATH 101',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.blue.shade400, width: 2),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: isLocked
                          ? Colors.grey.shade800.withOpacity(0.5)
                          : Colors.blue.shade900.withOpacity(0.2),
                      prefixIcon: Icon(
                        Icons.book_outlined,
                        color: isLocked
                            ? Colors.grey.shade500
                            : Colors.blue.shade300,
                        size: 20,
                      ),
                    ),
                    onChanged: (value) {
                      widget.onNameChanged(value);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 8),
                if (!isEmptyCourse) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey.shade800
                          : Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isLocked
                            ? Icons.lock_outline_rounded
                            : Icons.lock_open_rounded,
                        size: 20,
                      ),
                      color: isLocked ? Colors.grey.shade400 : Colors.white,
                      tooltip: isLocked ? 'Unlock to edit' : 'Lock',
                      onPressed: toggleLock,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.red.shade300,
                    tooltip: 'Delete course',
                    onPressed: handleDelete,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: widget.creditHours,
                    decoration: InputDecoration(
                      labelText: 'Credit Hours',
                      labelStyle: TextStyle(
                        color: isLocked
                            ? Colors.grey.shade500
                            : Colors.blue.shade300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isLocked
                              ? Colors.grey.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: isLocked
                          ? Colors.grey.shade800.withOpacity(0.5)
                          : Colors.blue.shade900.withOpacity(0.2),
                      prefixIcon: Icon(
                        Icons.schedule_outlined,
                        color: isLocked
                            ? Colors.grey.shade500
                            : Colors.blue.shade300,
                        size: 20,
                      ),
                    ),
                    dropdownColor: Colors.grey.shade900,
                    style: TextStyle(
                      color: isLocked ? Colors.grey.shade400 : Colors.white,
                      fontSize: 14,
                    ),
                    items: [0, 1, 2, 3]
                        .map((credits) => DropdownMenuItem(
                              value: credits,
                              child: Text('$credits CH'),
                            ))
                        .toList(),
                    onChanged: isLocked ? null : widget.onCreditHoursChanged,
                  ),
                ),

                const SizedBox(width: 12),

                // Grade
                Expanded(
                  child: DropdownButtonFormField<double>(
                    value: widget.grade,
                    decoration: InputDecoration(
                      labelText: 'Grade',
                      labelStyle: TextStyle(
                        color: isLocked
                            ? Colors.grey.shade500
                            : Colors.blue.shade300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isLocked
                              ? Colors.grey.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: isLocked
                          ? Colors.grey.shade800.withOpacity(0.5)
                          : Colors.blue.shade900.withOpacity(0.2),
                      prefixIcon: Icon(
                        Icons.grade_outlined,
                        color: isLocked
                            ? Colors.grey.shade500
                            : Colors.blue.shade300,
                        size: 20,
                      ),
                    ),
                    dropdownColor: Colors.grey.shade900,
                    style: TextStyle(
                      color: isLocked ? Colors.grey.shade400 : Colors.white,
                      fontSize: 14,
                    ),
                    items: widget.gradeOptions
                        .map((grade) => DropdownMenuItem(
                              value: grade.value,
                              child: Text(grade.label),
                            ))
                        .toList(),
                    onChanged: isLocked ? null : widget.onGradeChanged,
                  ),
                ),
              ],
            ),

            // Lock status indicator
            if (isLocked && !isEmptyCourse)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Course locked. Click the lock icon to edit.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
