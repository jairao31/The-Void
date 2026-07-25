import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _count = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_count <= 1) {
        t.cancel();
        if (mounted) context.pushReplacement('/session/void');
      } else {
        setState(() => _count--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$_count', style: AppTextStyles.countdownNum(context)),
                const SizedBox(height: 24),
                Text(AppStrings.countdownLabel,
                    style: AppTextStyles.voidLabel(context)),
                const SizedBox(height: 8),
                Text(AppStrings.countdownHint,
                    style: AppTextStyles.voidLabel(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
