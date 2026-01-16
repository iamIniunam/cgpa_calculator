import 'package:cgpa_calculator/views/home_screen.dart';
import 'package:cgpa_calculator/views/view_models/cgpa_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CGPACalculatorApp());
}

class CGPACalculatorApp extends StatelessWidget {
  const CGPACalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CGPAViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyCGPA',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.black,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const CGPACalculatorScreen(),
      ),
    );
  }
}
