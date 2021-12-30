import 'package:intl/intl.dart';

class StringHelper {
  static String capitalize(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  static String formatTime(time,
      {bool check = true,
      bool friend = false,
      bool walletFluctuations = false}) {
    if (walletFluctuations) {
      String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);
      return formattedDate;
    }

    if (check) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(time);
      if (friend) {
        String formattedDate = DateFormat('dd/MM/yyyy').format(time);
        return formattedDate;
      }
      return formattedDate;
    } else {
      String formattedDate = DateFormat('yyyy/MM/dd').format(time);
      return formattedDate;
    }
  }

  static String getMonthCurrent({bool isMonthName = false}) {
    return isMonthName
        ? DateFormat('MMM').format(DateTime.now())
        : "${DateTime.now().month}";
  }

  static int get getYearCurrent => DateTime.now().year;

  static String formatDefault2AfterDecimalPoint(double n) =>
      n.toStringAsFixed(2);

  static String formatCurrency(num n) {
    String sNum = n.toString();
    int nNum = int.tryParse(sNum.split('.')[0]);
    try {
      if (n is double) {
        return NumberFormat.currency(locale: 'vi')
            .format(nNum)
            .replaceAll('VND', '');
      } else {
        return NumberFormat.currency(locale: 'vi')
            .format(nNum)
            .replaceAll('USD', '')
            .replaceAll('', '');
      }
    } catch (e) {
      return "";
    }
  }

  static String convertTimestampToDate(timeStamp) => formatTime(
      DateTime.fromMillisecondsSinceEpoch((timeStamp?.toInt() ?? 0) * 1000),
      check: false);

  static String getPreviousMonth() {
    final now = DateTime.now();
    final nowYear = now.year;
    final monthYear = now.month;
    final previousMonth = monthYear - 1;
    final String sMonth =
        previousMonth ~/ 10 == 0 ? "0$previousMonth" : "$previousMonth";
    return "$sMonth/$nowYear";
  }

  static String removeAllEmojiCharacter(String str) {
    final RegExp regExp = RegExp(
        r'(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])');
    if (str.contains(regExp)) {
      str = str.replaceAll(regExp, '');
    }
    return str;
  }

  static String formatDeviceTokenTopicForIOS(String deviceToken) {
    final List<String> validString = ['-', '_', '.', '~', '%'];
    final List<String> src = deviceToken.split('');
    final size = src.length;
    for (int i = 0; i < size; i++) {
      final int charCodeCurrent = src[i].codeUnitAt(0);
      if ((charCodeCurrent >= 48 && charCodeCurrent <= 57) ||
          (charCodeCurrent >= 65 && charCodeCurrent <= 90) ||
          (charCodeCurrent >= 97 && charCodeCurrent <= 122)) {
      } else {
        if (validString.indexOf(src[i]) == -1) {
          src[i] = '';
        }
      }
    }
    return src.join();
  }

  static String removeCharacterSpecial(String n,
      {List<String> except = const []}) {
    final List<String> str = n.split((''));
    final sizeStr = str.length;
    for (int i = 0; i < sizeStr; i++) {
      if ((except?.indexOf(str[i]) == -1 ?? true) &&
          (([
                    '!',
                    '#',
                    '%',
                    '^',
                    '&',
                    '\$',
                    '\'',
                    '(',
                    ')',
                    '_',
                    '×',
                    '₫',
                    '?',
                    '\"',
                    '+',
                    '-',
                    '~',
                    '*',
                    '÷',
                    ':',
                    ';',
                    '{',
                    '}',
                    '|',
                    ',',
                    '[',
                    ']',
                    '=',
                    '<',
                    '>',
                    '€',
                    '™',
                    '°',
                    '`',
                    '¿',
                    '©',
                    '£',
                    '®',
                    '¥',
                    '¶',
                    '´',
                    '⁋',
                    '±',
                    '◯',
                    '◼',
                    '☆',
                    '⚬',
                    '●',
                    '■',
                    '♤',
                    '♡',
                    '◇',
                    '♧',
                    '《',
                    '》',
                    '¤',
                    '@',
                  ].indexOf(str[i]) !=
                  -1) ||
              str[i].codeUnitAt(0) == 92 ||
              str[i].codeUnitAt(0) == 47 ||
              str[i].codeUnitAt(0) == 44 ||
              str[i].codeUnitAt(0) == 46)) {
        str[i] = '';
      }
    }
    return str.join();
  }

  static String formatThousandsNumber(num input) {
    final formatter = new NumberFormat("#,###.###", "en_US");
    return formatter.format(input);
  }
}
