class BackupMetadata {
  final DateTime? lastBackupAt;
  final bool isSignedIn;
  final String? email;

  const BackupMetadata({
    this.lastBackupAt,
    required this.isSignedIn,
    this.email,
  });
}
