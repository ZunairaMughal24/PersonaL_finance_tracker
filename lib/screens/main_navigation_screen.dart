import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/analytics_screen.dart';
import 'package:personal_finance_tracker/screens/home_screen.dart';
import 'package:personal_finance_tracker/screens/profile_screen.dart';
import 'package:personal_finance_tracker/screens/transaction_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    TransactionScreen(),
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
      body: IndexedStack(index: _currentIndex, children: _screens),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 6,
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
        child: BottomAppBar(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(icon: Icons.home_outlined, index: 0),
                _navItem(icon: Icons.pie_chart_outline, index: 1),
                const SizedBox(width: 40), // space for FAB
                _navItem(icon: Icons.list_alt_outlined, index: 2),
                _navItem(icon: Icons.person_outline, index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({required IconData icon, required int index}) {
    return Material(
      color: Colors.transparent, // transparent to see ripple
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: AppColors.primaryColor.withOpacity(0.2),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: _currentIndex == index
                ? AppColors.primaryColor
                : AppColors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }
}
