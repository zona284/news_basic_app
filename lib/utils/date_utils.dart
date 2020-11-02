/**
 * Date Helper
 */
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String localFormat(String strdate){
  initializeDateFormatting();
  DateTime date = DateTime.parse(strdate);
  DateTime diff = DateTime.fromMillisecondsSinceEpoch(DateTime.now().difference(date).inMinutes);
  var difference = DateFormat("mm").format(diff);

  return DateFormat("d MMM y", 'ID_id').format(date);
}

String localFormatMonthYearOnly(String strdate){
  DateTime date = DateTime.parse(strdate);
  initializeDateFormatting();
  return DateFormat("MMMM y",'ID_id').format(date);
}