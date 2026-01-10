import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';

enum BackgroundStyle {
  premiumHybrid, // Home: Iridescent + Splash Hints
  glowMesh, // Splash/Auth: Glow Blobs
  silkDark, // Analytics/Profile: Silk Image
  abstractDark, // Transactions: Dark Abstract + Gradient
}

class AppBackground extends StatelessWidget {
  final Widget child;
  final BackgroundStyle style;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  const AppBackground({
    super.key,
    required this.child,
    this.style = BackgroundStyle.glowMesh,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = true,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Stack(children: [_buildBackground(context), child]),
    );
  }

  Widget _buildBackground(BuildContext context) {
    switch (style) {
      case BackgroundStyle.premiumHybrid:
        return _buildPremiumHybrid(context);
      case BackgroundStyle.glowMesh:
        return _buildGlowMesh(context);
      case BackgroundStyle.silkDark:
        return _buildSilkDark(context);
      case BackgroundStyle.abstractDark:
        return _buildAbstractDark(context);
    }
  }

  Widget _buildPremiumHybrid(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2574&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.85),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: -100,
          right: -50,
          child: _GlowBlob(
            color: AppColors.primaryColor,
            opacity: 0.15,
            blur: 150,
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: _GlowBlob(color: AppColors.accent, opacity: 0.1, blur: 120),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: -30,
          child: _GlowBlob(
            color: AppColors.primaryDark,
            opacity: 0.05,
            blur: 80,
          ),
        ),
      ],
    );
  }

  Widget _buildGlowMesh(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.background),
        Positioned(
          top: -100,
          right: -100,
          child: _GlowBlob(
            color: AppColors.primaryColor,
            opacity: 0.4,
            blur: 120,
            spread: 50,
          ),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          child: _GlowBlob(
            color: AppColors.accent,
            opacity: 0.2,
            blur: 150,
            spread: 40,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: -50,
          child: _GlowBlob(
            color: AppColors.primaryDark,
            opacity: 0.1,
            blur: 100,
            spread: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSilkDark(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2187&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          ),
        ),
      ],
    );
  }

  Widget _buildAbstractDark(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1635776062127-d379bfcba9f8?q=80&w=1920&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double opacity;
  final double blur;
  final double spread;
  final double size;

  const _GlowBlob({
    required this.color,
    required this.opacity,
    required this.blur,
    this.spread = 30,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(opacity * 0.5),
            blurRadius: blur,
            spreadRadius: spread,
          ),
        ],
      ),
    );
  }
}
