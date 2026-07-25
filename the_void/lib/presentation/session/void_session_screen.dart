import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/session_provider.dart';
import '../../domain/services/session_service.dart';
import 'quiet_prompt_screen.dart';

class VoidSessionScreen extends ConsumerStatefulWidget {
  const VoidSessionScreen({super.key});

  @override
  ConsumerState<VoidSessionScreen> createState() => _VoidSessionScreenState();
}

class _VoidSessionScreenState extends ConsumerState<VoidSessionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _completionTimer;
  bool _sessionStarted = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _opacityAnim = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Start session after first frame so providers are ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
  }

  Future<void> _startSession() async {
    if (_sessionStarted) return;
    _sessionStarted = true;

    final targetSeconds = ref.read(selectedDurationProvider);
    final quietMode = ref.read(quietModeEnabledProvider);
    final service = ref.read(sessionServiceProvider);

    final sessionId = await service.startSession(
      targetDurationSeconds: targetSeconds,
      quietModeEnabled: quietMode,
    );

    ref.read(activeSessionIdProvider.notifier).state = sessionId;

    _stopwatch.start();
    _completionTimer = Timer(
      Duration(seconds: targetSeconds),
      _onSessionComplete,
    );
  }

  Future<void> _onSessionComplete() async {
    HapticFeedback.lightImpact();
    _stopwatch.stop();
    await _finaliseSession(interrupted: false, reason: null);
    if (mounted) context.pushReplacement('/session/post');
  }

  Future<void> _finaliseSession({
    required bool interrupted,
    String? reason,
  }) async {
    final sessionId = ref.read(activeSessionIdProvider);
    if (sessionId == null) return;

    final targetSeconds = ref.read(selectedDurationProvider);
    final quietMode = ref.read(quietModeEnabledProvider);
    final service = ref.read(sessionServiceProvider);
    final actual = _stopwatch.elapsed.inSeconds;

    int points;
    if (interrupted) {
      points = await service.interruptSession(
        sessionId: sessionId,
        actualDurationSeconds: actual,
        targetDurationSeconds: targetSeconds,
        quietModeEnabled: quietMode,
        reason: reason,
      );
    } else {
      points = await service.completeSession(
        sessionId: sessionId,
        actualDurationSeconds: actual,
        targetDurationSeconds: targetSeconds,
        quietModeEnabled: quietMode,
      );
    }

    ref.read(completedSessionResultProvider.notifier).state = SessionResult(
      sessionId: sessionId,
      actualDurationSeconds: actual,
      targetDurationSeconds: targetSeconds,
      pointsEarned: points,
      wasCompleted: !interrupted,
      quietModeEnabled: quietMode,
    );
  }

  void _showEndConfirmation() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _EndSessionSheet(
        elapsedSeconds: _stopwatch.elapsed.inSeconds,
        onKeepGoing: () => Navigator.pop(ctx),
        onEndSession: () async {
          Navigator.pop(ctx);
          _completionTimer?.cancel();
          _stopwatch.stop();
          await _finaliseSession(interrupted: true, reason: null);
          if (mounted) context.pushReplacement('/session/interrupted');
        },
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _completionTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quietMode = ref.watch(quietModeEnabledProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColorsDark.bgVoid : AppColors.bgVoid;
    final ringColor = isDark ? AppColorsDark.pulseRing : AppColors.pulseRing;
    final coreColor = isDark ? AppColorsDark.pulseCore : AppColors.pulseCore;

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _showEndConfirmation(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // End button — min 44×44 tap target
            Positioned(
              top: 56,
              right: 24,
              child: GestureDetector(
                onTap: _showEndConfirmation,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: Text(AppStrings.voidEnd,
                      style: AppTextStyles.voidLabel(context)),
                ),
              ),
            ),

            // Quiet mode pill
            if (quietMode)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(AppStrings.voidQuietOn,
                      style: AppTextStyles.voidLabel(context)),
                ),
              ),

            // Pulse circle
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnim.value,
                    child: Opacity(
                      opacity: _opacityAnim.value,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ringColor, width: 1),
                        ),
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: coreColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom text
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(AppStrings.voidLine1,
                      style: AppTextStyles.voidLabel(context)),
                  Text(AppStrings.voidLine2,
                      style: AppTextStyles.voidLabel(context)),
                  const SizedBox(height: 24),
                  Text(AppStrings.voidHint,
                      style: AppTextStyles.voidLabel(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndSessionSheet extends StatelessWidget {
  final int elapsedSeconds;
  final VoidCallback onKeepGoing;
  final VoidCallback onEndSession;

  const _EndSessionSheet({
    required this.elapsedSeconds,
    required this.onKeepGoing,
    required this.onEndSession,
  });

  @override
  Widget build(BuildContext context) {
    final min = elapsedSeconds ~/ 60;
    final sec = elapsedSeconds % 60;
    final elapsed = min > 0 ? '$min min $sec sec' : '$sec sec';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.voidEndTitle,
              style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 8),
          Text('${AppStrings.voidEndBody} $elapsed.',
              style: AppTextStyles.body(context)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onKeepGoing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).brightness == Brightness.light
                    ? AppColors.bgPrimary
                    : AppColorsDark.bgPage,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(AppStrings.voidEndKeep,
                  style: AppTextStyles.buttonLabel(context)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: onEndSession,
              child: Text(AppStrings.voidEndConfirm,
                  style: AppTextStyles.buttonGhost(context)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
