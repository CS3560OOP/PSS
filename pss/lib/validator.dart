import "package:intl/intl.dart";
import "date.dart";

class Validator {
  // Checks to see if date is
  // compare DateTime formatted version
  // of input to original the input
  bool isValidDate(Date d) {
    String comparatorStr = DateFormat.yMd()
        .format(DateTime(d.getYear(), d.getMonth(), d.getDay()));
    String originalStr = d.getMonth().toString() +
        "/" +
        d.getDay().toString() +
        "/" +
        d.getYear().toString();
    return originalStr == comparatorStr;
  }
}
