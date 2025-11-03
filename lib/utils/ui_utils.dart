import 'package:flutter/material.dart';

/// UI系（背景、SnackBar、色など）。
/// ※ 色判定は将来 ColorScheme 由来に寄せるとテストしやすくなります。
class UiUtils {
  UiUtils._();

  /// 背景画像（暗めで被写体を邪魔しない）
  static Widget background({BuildContext? context}) {
    return Image.asset(
      'assets/images/bg.jpg',
      fit: BoxFit.fitHeight,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  /// どこからでもエラートースト
  static void showError(String msg) {
    ScaffoldMessenger.of(
      NavigationService.navigatorKey.currentContext!,
    ).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  /// 曜日/祝日 色（薄色の背景用）
  static Color youbiColor({required String date, required String youbiStr, required List<String> holiday}) {
    Color color;
    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withValues(alpha: 0.2);
      case 'Saturday':
        color = Colors.blueAccent.withValues(alpha: 0.2);
      default:
        color = Colors.black.withValues(alpha: 0.2);
    }
    if (holiday.contains(date)) {
      color = Colors.greenAccent.withValues(alpha: 0.2);
    }
    return color;
  }

  /// ライフタイム行の背景色（値に応じた色）
  static Color lifetimeRowBgColor({required String value, required bool textDisplay}) {
    final double opa = (!textDisplay) ? 0.4 : 0.2;
    switch (value) {
      case '自宅':
      case '実家':
        return Colors.white.withValues(alpha: opa);
      case '睡眠':
        return Colors.yellowAccent.withValues(alpha: opa);
      case '移動':
        return Colors.green.withValues(alpha: opa);
      case '仕事':
        return Colors.indigo.withValues(alpha: opa);
      case '外出':
      case '旅行':
      case 'イベント':
        return Colors.pinkAccent.withValues(alpha: opa);
      case 'ボクシング':
      case '俳句会':
      case '勉強':
        return Colors.purpleAccent.withValues(alpha: opa);
      case '飲み会':
        return Colors.orangeAccent.withValues(alpha: opa);
      case '歩き':
        return Colors.lightBlueAccent.withValues(alpha: opa);
      case '緊急事態':
        return Colors.redAccent.withValues(alpha: opa);
      default:
        return Colors.transparent;
    }
  }

  /// 24色プリセット（グラフ/帯などに）
  static List<Color> twentyFourColors() => const <Color>[
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFFA726),
    Color(0xFF8E24AA),
    Color(0xFF00ACC1),
    Color(0xFFFDD835),
    Color(0xFF6D4C41),
    Color(0xFFD81B60),
    Color(0xFF3949AB),
    Color(0xFF00897B),
    Color(0xCCFF7043),
    Color(0xFF7CB342),
    Color(0xFF5E35B1),
    Color(0xCC26C6DA),
    Color(0xCCFFEE58),
    Color(0xFFBDBDBD),
    Color(0xCCEF5350),
    Color(0xCC42A5F5),
    Color(0xCC66BB6A),
    Color(0x99FFB74D),
    Color(0xCCAB47BC),
    Color(0xCC26A69A),
    Color(0xCCFF8A65),
  ];

  /// 路線色（未定義は薄黒）
  static Color trainColor({required String trainName}) {
    const Map<String, Color> map = <String, Color>{
      '東京メトロ銀座線': Color(0xFFF19A38),
      '東京メトロ丸ノ内線': Color(0xFFE24340),
      '東京メトロ日比谷線': Color(0xFFB5B5AD),
      '東京メトロ東西線': Color(0xFF4499BB),
      '東京メトロ千代田線': Color(0xFF54B889),
      '東京メトロ有楽町線': Color(0xFFBDA577),
      '東京メトロ半蔵門線': Color(0xFF8B76D0),
      '東京メトロ南北線': Color(0xFF4DA99B),
      '東京メトロ副都心線': Color(0xFF93613A),
    };
    return (map[trainName] ?? Colors.black.withOpacity(0.3)).withOpacity(0.6);
  }

  /// 銀行/決済ニックネーム
  static Map<String, String> bankName() {
    return <String, String>{
      'bank_a': 'みずほ',
      'bank_b': '住友547',
      'bank_c': '住友259',
      'bank_d': 'UFJ',
      'bank_e': '楽天',
      'pay_a': 'Suica1',
      'pay_b': 'PayPay',
      'pay_c': 'PASUMO',
      'pay_d': 'Suica2',
      'pay_e': 'メルカリ',
      'pay_f': '楽天キャッシュ',
    };
  }
}

/// どこからでも Snackbar を出すためのナビゲーションキー
class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
