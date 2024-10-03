import 'package:intl/intl.dart';

class Formatters {
  static formatterCurrency(double value) {
    var f = NumberFormat("###.00", "pt_BR");
    return f.format(value);
  }

  static formatterCurrent(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}:${date.second}";
  }

  static formatterCurrentMonth(DateTime date) {
    return _getMonthName(date.month);
  }

  static formatterCurrentMonthByInt(int month) {
    return _getMonthName(month);
  }

  static formatterTagForPortugue(String type) {
    return type == "exit" ? "saída" : "entrada";
  }

  static _getMonthName(int month) {
    switch (month) {
      case 1:
        return "Janeiro";
      case 2:
        return "Fevereiro";
      case 3:
        return "Março";
      case 4:
        return "Abril";
      case 5:
        return "Maio";
      case 6:
        return "Junho";
      case 7:
        return "Julho";
      case 8:
        return "Agosto";
      case 9:
        return "Setembro";
      case 10:
        return "Outubro";
      case 11:
        return "Novembro";
      case 12:
        return "Dezembro";
    }
  }
}
