import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/analytics_screen.dart';
import 'package:personal_finance_tracker/screens/home_screen.dart';
import 'package:personal_finance_tracker/screens/profile_screen.dart';
import 'package:personal_finance_tracker/screens/activity_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class MainNavScreen extends StatefulWidget {
  static final GlobalKey<_MainNavScreenState> navKey =
      GlobalKey<_MainNavScreenState>();
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  void switchToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    ActivityScreen(),
    ProfileScreen(),
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
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 6,
        shape: const CircleBorder(),
        onPressed: () {
          context.push(AppRoutes.transactionScreenRoute);
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: BottomAppBar(
            color: Colors.white.withOpacity(0.08),
            elevation: 0,
            notchMargin: 0,
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.12),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    icon: CupertinoIcons.house_fill,
                    label: 'Home',
                    index: 0,
                  ),
                  _navItem(
                    icon: CupertinoIcons.chart_bar_fill,
                    label: 'Analytics',
                    index: 1,
                  ),
                  const SizedBox(width: 48),
                  _navItem(
                    icon: CupertinoIcons.doc_text_fill,
                    label: 'Activity',
                    index: 2,
                  ),
                  _navItem(
                    icon: CupertinoIcons.person_fill,
                    label: 'Profile',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    IconData? icon,
    String? assetPath,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primaryColor
        : AppColors.white.withOpacity(0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primaryColor.withOpacity(0.2),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (assetPath != null)
                Image.asset(assetPath, width: 24, height: 24, color: color)
              else
                Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
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
