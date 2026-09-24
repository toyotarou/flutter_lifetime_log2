import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

extension ContextEx on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorTheme => Theme.of(this).colorScheme;

  /// MediaQuery.sizeOf はサイズ変化時のみ再構築される（キーボード表示等で全体が再構築されない）
  Size get screenSize => MediaQuery.sizeOf(this);

  void showKeyboard(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }
}

/// DateFormat / NumberFormat は生成コストが高いため、使い回す（build中に大量に呼ばれる）
final DateFormat _fmtYmd = DateFormat('yyyy-MM-dd');
final DateFormat _fmtYm = DateFormat('yyyy-MM');
final DateFormat _fmtMd = DateFormat('MM-dd');
final DateFormat _fmtY = DateFormat('yyyy');
final DateFormat _fmtM = DateFormat('MM');
final DateFormat _fmtD = DateFormat('dd');
final DateFormat _fmtYoubi = DateFormat('EEEE');
final DateFormat _fmtDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
final NumberFormat _fmtCurrency = NumberFormat('#,###');

extension DateTimeEx on DateTime {
  String get yyyymmdd => _fmtYmd.format(this);

  String get yyyymm => _fmtYm.format(this);

  String get mmdd => _fmtMd.format(this);

  String get yyyy => _fmtY.format(this);

  String get mm => _fmtM.format(this);

  String get dd => _fmtD.format(this);

  String get youbiStr => _fmtYoubi.format(this);

  // ===== ここから追記：日付比較を“日単位”で扱うためのヘルパ =====

  /// 時刻を切り捨てた "日付のみ"（00:00:00）を返す
  DateTime get dateOnly => DateTime(year, month, day);

  /// 同じ日付か（時刻は無視）
  bool isSameDate(DateTime other) => dateOnly.isAtSameMomentAs(other.dateOnly);

  /// 厳密に「前の日付」か（<、同日は含まない）
  bool isBeforeDate(DateTime other) => dateOnly.isBefore(other.dateOnly);

  /// 厳密に「後の日付」か（>、同日は含まない）
  bool isAfterDate(DateTime other) => dateOnly.isAfter(other.dateOnly);

  /// 「前または同じ日付」か（<=）
  bool isBeforeOrSameDate(DateTime other) => isBeforeDate(other) || isSameDate(other);

  /// 「後または同じ日付」か（>=）
  bool isAfterOrSameDate(DateTime other) => isAfterDate(other) || isSameDate(other);

  /// 範囲内かどうか（閉区間: start <= this <= end）
  bool isBetweenDatesInclusive(DateTime start, DateTime end) => isAfterOrSameDate(start) && isBeforeOrSameDate(end);

  /// 範囲内かどうか（開区間: start < this < end）
  bool isBetweenDatesExclusive(DateTime start, DateTime end) => isAfterDate(start) && isBeforeDate(end);

  // ===== 追記ここまで =====
}

const int _fullLengthCode = 65248;

final RegExp _halfAlnumRegex = RegExp(r'^[a-zA-Z0-9]+$');
final RegExp _fullAlnumRegex = RegExp(r'^[Ａ-Ｚａ-ｚ０-９]+$');

extension StringEx on String {
  DateTime toDateTime() => _fmtDateTime.parseStrict(this);

  int toInt({int defaultValue = 0}) {
    return int.tryParse(this) ?? defaultValue;
  }

  String toCurrency() {
    final int? val = int.tryParse(this);
    if (val == null) {
      return this;
    }
    return _fmtCurrency.format(val);
  }

  double toDouble({double defaultValue = 0.0}) {
    return double.tryParse(this) ?? defaultValue;
  }

  String alphanumericToFullLength() {
    final Iterable<String> string = runes.map<String>((int rune) {
      final String char = String.fromCharCode(rune);
      return _halfAlnumRegex.hasMatch(char) ? String.fromCharCode(rune + _fullLengthCode) : char;
    });
    return string.join();
  }

  String alphanumericToHalfLength() {
    final Iterable<String> string = runes.map<String>((int rune) {
      final String char = String.fromCharCode(rune);
      return _fullAlnumRegex.hasMatch(char) ? String.fromCharCode(rune - _fullLengthCode) : char;
    });
    return string.join();
  }
}

// ignore: strict_raw_type, always_specify_types
extension ListIndexCheck on List {
  bool isInRange(int i) => i >= 0 && i < length;
}
