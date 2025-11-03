import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utils/ui_utils.dart';

part 'bank_input.freezed.dart';

part 'bank_input.g.dart';

@freezed
class BankInputState with _$BankInputState {
  const factory BankInputState({
    @Default(-1) int pos,
    @Default(<String>[]) List<String> inputDateList,
    @Default(<String>[]) List<String> inputBankList,
    @Default(<String>[]) List<String> inputValueList,

    @Default('') String selectedBankKey,
  }) = _BankInputState;
}

@riverpod
class BankInput extends _$BankInput {
  ///
  @override
  BankInputState build() {
    // ignore: always_specify_types
    final List<String> list = List.generate(10, (int index) => '');

    // ignore: always_specify_types
    final List<String> list2 = List.generate(10, (int index) => 0.toString());

    // ignore: always_specify_types
    final List<String> list3 = List.generate(10, (int index) => '');

    return BankInputState(inputBankList: list, inputValueList: list2, inputDateList: list3);
  }

  ///
  void setPos({required int pos}) => state = state.copyWith(pos: pos);

  ///
  void setInputDateList({required int pos, required String date}) {
    final List<String> list = <String>[...state.inputDateList];
    list[pos] = date;
    state = state.copyWith(inputDateList: list);
  }

  ///
  void setInputBankList({required int pos, required String bank}) {
    final List<String> list = <String>[...state.inputBankList];
    list[pos] = bank;
    state = state.copyWith(inputBankList: list);
  }

  ///
  void setInputValueList({required int pos, required String value}) {
    final List<String> list = <String>[...state.inputValueList];
    list[pos] = value;
    state = state.copyWith(inputValueList: list);
  }

  ///
  Future<void> updateBankMoney({required Map<String, dynamic> uploadData}) async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.updateBankMoney, body: uploadData).then((value) {}).catchError((error, _) {
      UiUtils.showError('予期せぬエラーが発生しました');
    });
  }

  ///
  void setSelectedBankKey({required String key}) => state = state.copyWith(selectedBankKey: key);
}
