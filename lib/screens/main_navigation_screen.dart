import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/screens/analytics_screen.dart';
import 'package:personal_finance_tracker/screens/home_screen.dart';
import 'package:personal_finance_tracker/screens/transaction_screen.dart';
import 'package:provider/provider.dart';

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
  ];
  @override
  void initState() {
    super.initState();
    // use listen: false because we are in initState
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
      // Main tab body using IndexedStack to preserve state
      body: IndexedStack(index: _currentIndex, children: _screens),

      // Center Add FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        elevation: 6,
        onPressed: () {
          // Navigate to Add/Edit transaction
          context.push(AppRoutes.transactionScreenRoute);
        },
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom navbar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(icon: Icons.home_outlined, index: 0),
              _navItem(icon: Icons.pie_chart_outline, index: 1),
              const SizedBox(width: 40), // space for FAB
              _navItem(icon: Icons.list_alt_outlined, index: 2),
              //_navItem(icon: Icons.person_outline, index: 3), // optional
            ],
          ),
        ),
      ),
    );
  }

  // Navbar item
  Widget _navItem({required IconData icon, required int index}) {
    return IconButton(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      icon: Icon(
        icon,
        color: _currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
