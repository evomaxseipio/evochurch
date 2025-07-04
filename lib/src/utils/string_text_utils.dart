// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../constants/constant_index.dart';

double getTotalFromList(String key, List<Map<String, dynamic>> list) {
  double total = 0;

  for (var map in list) {
    total += double.parse(map[key]);
  }
  return total;
}

String formatCurrency(String value) {
  if (value.isEmpty) {
    return '';
  }
  try {
    double number = double.parse(value);
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'RD\$ ',
      decimalDigits: 2,
    );
    return formatter.format(number);
  } catch (e) {
    return value;
  }
  
}

String formatDouble(double value) {
  final formatter = NumberFormat("#,##0.00", "en_US");
  return formatter.format(value);
}

String formatDate(String dateToConvert) {
  try {
    DateTime? date = DateTime.tryParse(dateToConvert);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date!);
  } catch (e) {
    return dateToConvert;
  }
}

String convertDateFormat(String dateString) {
  try {
    // Parse the input date string
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateString);

    // Format the date to 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return formattedDate;
  } catch (e) {
    throw Exception('Error parsing date: $e');
  }
}

String textUpper(String text) {
  final temptext = convertUnderscoreToSpace(text.split('/').last);
  return temptext;
}

String convertUnderscoreToSpace(String text) {
  return text.replaceAll(RegExp(r'[_-]'), ' ').replaceAllMapped(
      RegExp(r'\b\w'), (match) => match.group(0)!.toUpperCase());
}

formTitle(String text, double fontSize,
    [FontWeight fontWeight = FontWeight.w500, Color color = Colors.grey]) {
  return Text(
    text,
    style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
  );
}

class CustomDateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/', oldValue);
    return newValue.copyWith(
        text: text, selection: _updateCursorPosition(text, oldValue));
  }
}

Widget customColumnTitle(String key, String value,
    {double? size,
    FontWeight fontWeight = FontWeight.w500,
    Color keyColor = EvoColor.black,
    Color valueColor = EvoColor.black}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      formTitle(value, size ?? 12, fontWeight, valueColor),
      formTitle(key, size ?? 14, FontWeight.bold, keyColor)
    ],
  );
}

String _format(String value, String seperator, TextEditingValue old) {
  var finalString = '';
  var dd = '';
  var mm = '';
  var yyy = '';
  var oldVal = old.text;

  var tempOldval = oldVal;
  var tempValue = value;
  if (!oldVal.contains(seperator) ||
      oldVal.isEmpty ||
      seperator.allMatches(oldVal).length < 2) {
    oldVal += '///';
  }
  if (!value.contains(seperator) || _backSlashCount(value) < 2) {
    value += '///';
  }
  var splitArrOLD = oldVal.split(seperator);
  var splitArrNEW = value.split(seperator);

  for (var i = 0; i < 3; i++) {
    splitArrOLD[i] = splitArrOLD[i].toString().trim();
    splitArrNEW[i] = splitArrNEW[i].toString().trim();
  }
  // block erasing
  if ((splitArrOLD[0].isNotEmpty &&
          splitArrOLD[2].isNotEmpty &&
          splitArrOLD[1].isEmpty &&
          tempValue.length < tempOldval.length &&
          splitArrOLD[0] == splitArrNEW[0] &&
          splitArrOLD[2].toString().trim() ==
              splitArrNEW[1].toString().trim()) ||
      (_backSlashCount(tempOldval) > _backSlashCount(tempValue) &&
          splitArrNEW[1].length > 2) ||
      (splitArrNEW[0].length > 2 && _backSlashCount(tempOldval) == 1) ||
      (_backSlashCount(tempOldval) == 2 &&
          _backSlashCount(tempValue) == 1 &&
          splitArrNEW[0].length > splitArrOLD[0].length)) {
    finalString = tempOldval; // making the old date as it is
  } else {
    if (splitArrNEW[0].length > splitArrOLD[0].length) {
      if (splitArrNEW[0].length < 3) {
        dd = splitArrNEW[0];
      } else {
        for (var i = 0; i < 2; i++) {
          dd += splitArrNEW[0][i];
        }
      }
      if (dd.length == 2 && !dd.contains(seperator)) {
        dd += seperator;
      }
    } else if (splitArrNEW[0].length == splitArrOLD[0].length) {
      if (oldVal.length > value.length && splitArrNEW[1].isEmpty) {
        dd = splitArrNEW[0];
      } else {
        dd = splitArrNEW[0] + seperator;
      }
    } else if (splitArrNEW[0].length < splitArrOLD[0].length) {
      if (oldVal.length > value.length &&
          splitArrNEW[1].isEmpty &&
          splitArrNEW[0].isNotEmpty) {
        dd = splitArrNEW[0];
      } else if (tempOldval.length > tempValue.length &&
          splitArrNEW[0].isEmpty &&
          _backSlashCount(tempValue) == 2) {
        dd += seperator;
      } else {
        if (splitArrNEW[0].isNotEmpty) {
          dd = splitArrNEW[0] + seperator;
        }
      }
    }

    if (dd.isNotEmpty) {
      finalString = dd;
      if (dd.length == 2 &&
          !dd.contains(seperator) &&
          oldVal.length < value.length &&
          splitArrNEW[1].isNotEmpty) {
        if (seperator.allMatches(dd).isEmpty) {
          finalString += seperator;
        }
      } else if (splitArrNEW[2].isNotEmpty &&
          splitArrNEW[1].isEmpty &&
          tempOldval.length > tempValue.length) {
        if (seperator.allMatches(dd).isEmpty) {
          finalString += seperator;
        }
      } else if (oldVal.length < value.length &&
          (splitArrNEW[1].isNotEmpty || splitArrNEW[2].isNotEmpty)) {
        if (seperator.allMatches(dd).isEmpty) {
          finalString += seperator;
        }
      }
    } else if (_backSlashCount(tempOldval) == 2 && splitArrNEW[1].isNotEmpty) {
      dd += seperator;
    }

    if (splitArrNEW[0].length == 3 && splitArrOLD[1].isEmpty) {
      mm = splitArrNEW[0][2];
    }

    if (splitArrNEW[1].length > splitArrOLD[1].length) {
      if (splitArrNEW[1].length < 3) {
        mm = splitArrNEW[1];
      } else {
        for (var i = 0; i < 2; i++) {
          mm += splitArrNEW[1][i];
        }
      }
      if (mm.length == 2 && !mm.contains(seperator)) {
        mm += seperator;
      }
    } else if (splitArrNEW[1].length == splitArrOLD[1].length) {
      if (splitArrNEW[1].isNotEmpty) {
        mm = splitArrNEW[1];
      }
    } else if (splitArrNEW[1].length < splitArrOLD[1].length) {
      if (splitArrNEW[1].isNotEmpty) {
        mm = splitArrNEW[1] + seperator;
      }
    }

    if (mm.isNotEmpty) {
      finalString += mm;
      if (mm.length == 2 && !mm.contains(seperator)) {
        if (tempOldval.length < tempValue.length) {
          finalString += seperator;
        }
      }
    }

    if (splitArrNEW[1].length == 3 && splitArrOLD[2].isEmpty) {
      yyy = splitArrNEW[1][2];
    }

    if (splitArrNEW[2].length > splitArrOLD[2].length) {
      if (splitArrNEW[2].length < 5) {
        yyy = splitArrNEW[2];
      } else {
        for (var i = 0; i < 4; i++) {
          yyy += splitArrNEW[2][i];
        }
      }
    } else if (splitArrNEW[2].length == splitArrOLD[2].length) {
      if (splitArrNEW[2].isNotEmpty) {
        yyy = splitArrNEW[2];
      }
    } else if (splitArrNEW[2].length < splitArrOLD[2].length) {
      yyy = splitArrNEW[2];
    }

    if (yyy.isNotEmpty) {
      if (_backSlashCount(finalString) < 2) {
        if (splitArrNEW[0].isEmpty && splitArrNEW[1].isEmpty) {
          finalString = seperator + seperator + yyy;
        } else {
          finalString = finalString + seperator + yyy;
        }
      } else {
        finalString += yyy;
      }
    } else {
      if (_backSlashCount(finalString) > 1 && oldVal.length > value.length) {
        var valueUpdate = finalString.split(seperator);
        finalString = valueUpdate[0] + seperator + valueUpdate[1];
      }
    }
  }

  return finalString;
}

TextSelection _updateCursorPosition(String text, TextEditingValue oldValue) {
  var endOffset = max(
    oldValue.text.length - oldValue.selection.end,
    0,
  );
  var selectionEnd = text.length - endOffset;
  // print('My log ---> $selectionEnd');
  return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
}

int _backSlashCount(String value) {
  return '/'.allMatches(value).length;
}
