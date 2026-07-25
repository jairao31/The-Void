import 'package:intl/intl.dart';

String formatShortDate(DateTime dt) => DateFormat('d MMM').format(dt);

String formatFullDate(DateTime dt) => DateFormat('d MMM yyyy').format(dt);

String formatDateTime(DateTime dt) => DateFormat('d MMM yyyy · HH:mm').format(dt);

String todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

String dateKey(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);
