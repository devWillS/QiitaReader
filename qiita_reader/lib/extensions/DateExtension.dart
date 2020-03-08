import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateExtension on String {
  get formatDate {
    if (this != null) {
      initializeDateFormatting("ja_JP");
      print(this);

      DateTime datetime = DateTime.parse(this).toLocal(); // StringからDate
      print(datetime);
      print(datetime.timeZoneName);
      var formatter = new DateFormat('yyyy年MM月dd日に投稿', "ja_JP");
      var formatted = formatter.format(datetime); // DateからString
      print(formatted);
      return formatted;
    } else {
      return null;
    }
  }
}
