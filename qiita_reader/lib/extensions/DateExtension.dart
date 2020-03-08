import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateExtension on String {
  get formatDate {
    if (this != null) {
      initializeDateFormatting("ja_JP");

      DateTime datetime = DateTime.parse(this).toLocal(); // StringからDate
      var formatter = new DateFormat('yyyy年MM月dd日に投稿', "ja_JP");
      var formatted = formatter.format(datetime); // DateからString
      return formatted;
    } else {
      return null;
    }
  }
}
