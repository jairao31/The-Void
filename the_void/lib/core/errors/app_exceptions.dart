class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection.');
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class BackupException extends AppException {
  const BackupException(super.message);
}

class DatabaseException extends AppException {
  const DatabaseException(super.message);
}

class WrongPasswordException extends AppException {
  const WrongPasswordException() : super('Incorrect password.');
}
