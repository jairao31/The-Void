import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BackupStatus { idle, loading, success, error }

class BackupState {
  final BackupStatus status;
  final DateTime? lastBackupAt;
  final String? errorMessage;

  const BackupState({
    this.status = BackupStatus.idle,
    this.lastBackupAt,
    this.errorMessage,
  });

  BackupState copyWith({
    BackupStatus? status,
    DateTime? lastBackupAt,
    String? errorMessage,
  }) => BackupState(
    status: status ?? this.status,
    lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    errorMessage: errorMessage,
  );
}

class BackupNotifier extends Notifier<BackupState> {
  @override
  BackupState build() => const BackupState();
}

final backupProvider = NotifierProvider<BackupNotifier, BackupState>(BackupNotifier.new);
