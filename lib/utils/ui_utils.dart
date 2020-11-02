import 'package:intl/intl.dart';

List<T> mapList<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

String capitalizeWord(String givenString) {
//  List<String> splitStr = givenString.toLowerCase().split(' ');
  List<String> splitStr = givenString.split(' ');
  for (int i = 0; i < splitStr.length; i++) {
    // You do not need to check if i is larger than splitStr length, as your for does that for you
    // Assign it back to the array
    splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
  }
  // Directly return the joined string
  return splitStr.join(' ');
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

String rupiahFormatPrice(int number){
  if(number>=0){
    return "Rp"+numberFormatPrice(number);
  } else {
    return "-Rp"+numberFormatPrice(number.abs());
  }
}

String numberFormatPrice(int number) {
  NumberFormat nf = NumberFormat("#,###");
  return nf.format(number).replaceAll(new RegExp(r','), '.');
}