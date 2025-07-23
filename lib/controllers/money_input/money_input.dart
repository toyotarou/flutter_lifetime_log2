import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../models/money_model.dart';
import '../../utility/utility.dart';

part 'money_input.freezed.dart';

part 'money_input.g.dart';

@freezed
class MoneyInputState with _$MoneyInputState {
  const factory MoneyInputState({
    @Default(<MoneyModel>[]) List<MoneyModel> moneyList,
    @Default(<String, MoneyModel>{}) Map<String, MoneyModel> moneyMap,

    ///
    List<OverlayEntry>? firstEntries,
    List<OverlayEntry>? secondEntries,

    Offset? overlayPosition,

    @Default(-1) int pos,
    @Default(<String>[]) List<String> inputValueList,

    @Default(false) bool isReplaceInputValueList,

    @Default('') String replaceInputValueListDate,
  }) = _MoneyInputState;
}

@riverpod
class MoneyInput extends _$MoneyInput {
  final Utility utility = Utility();

  ///
  @override
  MoneyInputState build() {
    // ignore: always_specify_types
    final List<String> list = List.generate(10, (int index) => 0.toString());

    return MoneyInputState(inputValueList: list);
  }

  ///
  void setFirstOverlayParams({required List<OverlayEntry>? firstEntries}) =>
      state = state.copyWith(firstEntries: firstEntries);

  ///
  void setSecondOverlayParams({required List<OverlayEntry>? secondEntries}) =>
      state = state.copyWith(secondEntries: secondEntries);

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  ///
  void setPos({required int pos}) => state = state.copyWith(pos: pos);

  ///
  void setInputValueList({required String value}) {
    final List<String> list = <String>[...state.inputValueList];
    list[state.pos] = value;
    state = state.copyWith(inputValueList: list);
  }

  ///
  void setReplaceInputValueList({required List<String> list}) => state = state.copyWith(inputValueList: list);

  ///
  void setIsReplaceInputValueList({required bool flag}) => state = state.copyWith(isReplaceInputValueList: flag);

  ///
  void setReplaceInputValueListDate({required String date}) => state = state.copyWith(replaceInputValueListDate: date);

  ///
  Future<void> insertMoney({required Map<String, dynamic> uploadData}) async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.moneyinsert, body: uploadData).then((value) {}).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
