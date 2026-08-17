import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String format(String pattern) => DateFormat(pattern).format(this);

  String get dayMonth => DateFormat('d MMM', 'fr').format(this);
  String get dayMonthYear => DateFormat('d MMM yyyy', 'fr').format(this);
  String get fullDate => DateFormat('EEEE d MMMM yyyy', 'fr').format(this);
  String get shortDate => DateFormat('dd/MM/yyyy', 'fr').format(this);
  String get time => DateFormat('HH:mm', 'fr').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String get relative {
    if (isToday) return "Aujourd'hui";
    if (isYesterday) return 'Hier';
    return dayMonth;
  }
}