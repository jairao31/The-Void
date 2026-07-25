import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class AppTabBar extends StatelessWidget {
  final Widget child;

  const AppTabBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isDark ? AppColorsDark.borderLight : AppColors.borderLight;
    final activeColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final inactiveColor = isDark ? AppColorsDark.textMuted : AppColors.textMuted;

    final tabs = [
      _TabItem(icon: '⌂', label: 'Home', route: '/home'),
      _TabItem(icon: '✦', label: 'Harvest', route: '/harvest'),
      _TabItem(icon: '↗', label: 'Progress', route: '/progress'),
      _TabItem(icon: '⚙', label: 'Settings', route: '/settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 0.5)),
      ),
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) {
          final isActive = location.startsWith(tab.route);
          return GestureDetector(
            onTap: () => context.go(tab.route),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                tab.icon,
                style: TextStyle(
                  fontSize: 18,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabItem {
  final String icon;
  final String label;
  final String route;
  const _TabItem({required this.icon, required this.label, required this.route});
}
