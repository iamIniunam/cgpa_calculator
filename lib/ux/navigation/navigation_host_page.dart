import 'package:cgpa_calculator/ux/navigation/components/custom_bottom_nav.dart';
import 'package:cgpa_calculator/ux/shared/components/app_bar.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/bottom_dark_gradient.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/views/home/home_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/semester_search.dart';
import 'package:cgpa_calculator/ux/views/semesters/semesters_page.dart';
import 'package:cgpa_calculator/ux/views/settings/settings_page.dart';
import 'package:flutter/material.dart';

class NavigationHostPage extends StatefulWidget {
  const NavigationHostPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<NavigationHostPage> createState() => _NavigationHostPageState();
}

class _NavigationHostPageState extends State<NavigationHostPage> {
  late int currentIndex;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              appBar: currentIndex == 1
                  ? (isSearching
                      ? AppBar(
                          automaticallyImplyLeading: false,
                          title: SearchTextFormField(
                            autofocus: true,
                            hintText: 'Search semesters or courses',
                            controller: searchController,
                            onChanged: (v) => setState(() {}),
                            onClear: () {
                              searchController.clear();
                            },
                            onIconTap: () {
                              searchController.clear();
                              setState(() {
                                isSearching = false;
                              });
                            },
                            onSubmitted: (_) {
                              setState(() {});
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          bottom: const PreferredSize(
                            preferredSize: Size.fromHeight(1),
                            child: Divider(height: 2),
                          ),
                        )
                      : HomeAppBar(
                          actions: [
                            SemesterSearch(
                              onSearchToggle: () {
                                setState(() {
                                  isSearching = true;
                                });
                              },
                            ),
                          ],
                        ).asPreferredSize(height: 58))
                  : HomeAppBar(
                      actions: currentIndex == 0 ? null : [],
                    ).asPreferredSize(height: 58),
              body: IndexedStack(
                index: currentIndex,
                children: [
                  const HomePage(),
                  SemestersPage(searchQuery: searchController.text),
                  const SettingsPage(),
                ],
              ),
            ),
          ),
          const BottomDarkGradient(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: CustomBottomNav(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  isSearching = false;
                  searchController.clear();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
