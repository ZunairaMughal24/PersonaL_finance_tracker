import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/screens/edit_transaction_screen.dart';
import 'package:personal_finance_tracker/screens/home_screen.dart';
import 'package:personal_finance_tracker/screens/transaction_screen.dart';


CustomTransitionPage<void> _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}){
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
class AppRoutes {
  static const String homeScreenRoute = '/homeScreen';
    static const String transactionScreenRoute = '/trasactionScreen';
    static const String editTransactionScreenRoute = '/editTransactionScreen';
     
 
}
final router = GoRouter(
  initialLocation: AppRoutes.homeScreenRoute,
  routes: [
     GoRoute(
      path: AppRoutes.homeScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.transactionScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child:  TransactionScreen(),
      ),
      
    ),
     GoRoute(
      path: AppRoutes.editTransactionScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child:  EditTransactionScreen(),
      ),
      
    ),
 
  ],
);
