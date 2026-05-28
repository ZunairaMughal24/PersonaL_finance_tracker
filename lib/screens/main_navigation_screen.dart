import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/screens/analytics_screen.dart';
import 'package:montage/screens/home_screen.dart';
import 'package:montage/screens/settings_screen.dart';
import 'package:montage/screens/activity_screen.dart';
import 'package:provider/provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/utils/haptic_feedback_helper.dart';
import 'package:montage/widgets/glass_container.dart';

class MainNavScreen extends StatefulWidget {
  static final GlobalKey<MainNavScreenState> navKey =
      GlobalKey<MainNavScreenState>();
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => MainNavScreenState();
}

class MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  void switchToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    HapticHelper.selection();
    // Clear activity filters and selection when navigating away from Activity tab
    if (_currentIndex == 2 && index != 2) {
      context.read<TransactionFilterProvider>().clearFilters();
      final listVm = context.read<TransactionListViewModel>();
      listVm.clearSelection();
      if (listVm.isSearchVisible) {
        listVm.toggleSearch();
      }
    }
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    ActivityScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          switchToHome();
        }
      },
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: IndexedStack(index: _currentIndex, children: _screens),

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          elevation: 6,
          shape: const CircleBorder(),
          onPressed: () {
            HapticHelper.medium();
            context.push(AppRoutes.transactionScreenRoute);
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: GlassContainer(
          customBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          showBottomBorder: false,
          blur: 40,
          borderOpacity: 0.12,
          padding: EdgeInsets.zero,
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            notchMargin: 0,
            padding: EdgeInsets.zero,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  iconPath: AppImages.homeAngle,
                  label: 'Home',
                  index: 0,
                ),
                _navItem(
                  iconPath: AppImages.chart,
                  label: 'Analytics',
                  index: 1,
                ),
                const SizedBox(width: 48),
                _navItem(
                  iconPath: AppImages.record,
                  label: 'Activity',
                  index: 2,
                ),
                _navItem(
                  icon: CupertinoIcons.person_fill,
                  label: 'Settings',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    IconData? icon,
    String? iconPath,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primaryColor
        : AppColors.white.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primaryColor.withValues(alpha: 0.2),
        onTap: () => _onTabSelected(index),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  height: 22,
                )
              else if (icon != null)
                Icon(icon, color: color, size: 21),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
