import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;

  const AppBackground({super.key, required this.child, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: backgroundImage != null
                ? Image.asset(
                    backgroundImage!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  )
                // Old Background Image:
                // : Image.network(
                //     'https://images.unsplash.com/photo-1635776062127-d379bfcba9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80',
                //     fit: BoxFit.cover,
                //     height: double.infinity,
                //     width: double.infinity,
                //   ),
                // New Background Image (same as Sign In screens):
                : Image.network(
                    'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2187&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6), // Dark black overlay
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
