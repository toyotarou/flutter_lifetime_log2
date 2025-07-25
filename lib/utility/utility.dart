import 'package:flutter/material.dart';

class Utility {
  /// 背景取得
  // ignore: always_specify_types
  Widget getBackGround({context}) {
    return Image.asset(
      'assets/images/bg.jpg',
      fit: BoxFit.fitHeight,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  ///
  void showError(String msg) {
    ScaffoldMessenger.of(
      NavigationService.navigatorKey.currentContext!,
    ).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  ///
  Color getYoubiColor({required String date, required String youbiStr, required List<String> holiday}) {
    Color color = Colors.black.withValues(alpha: 0.2);

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

  ///
  Color getLifetimeRowBgColor({required String value, required bool textDisplay}) {
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
    }

    return Colors.transparent;
  }

  ///
  List<Color> getTwelveColor() {
    return <Color>[
      const Color(0xffdb2f20),
      const Color(0xffefa43a),
      const Color(0xfffdf551),
      const Color(0xffa6c63d),
      const Color(0xff439638),
      const Color(0xff469c9e),
      const Color(0xff48a0e1),
      const Color(0xff3070b1),
      const Color(0xff020c75),
      const Color(0xff931c7a),
      const Color(0xffdc2f81),
      const Color(0xffdb2f5c),
    ];
  }

  /// 銀行名取得
  Map<String, String> getBankName() {
    final Map<String, String> bankNames = <String, String>{};

    bankNames['bank_a'] = 'みずほ';
    bankNames['bank_b'] = '住友547';
    bankNames['bank_c'] = '住友259';
    bankNames['bank_d'] = 'UFJ';
    bankNames['bank_e'] = '楽天';

    bankNames['pay_a'] = 'Suica1';
    bankNames['pay_b'] = 'PayPay';
    bankNames['pay_c'] = 'PASUMO';
    bankNames['pay_d'] = 'Suica2';
    bankNames['pay_e'] = 'メルカリ';
    bankNames['pay_f'] = '楽天キャッシュ';

    return bankNames;
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
