import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utility/utility.dart';

part 'spend_input.freezed.dart';

part 'spend_input.g.dart';

@freezed
class SpendInputState with _$SpendInputState {
  const factory SpendInputState({
    @Default(-1) int pos,
    @Default(<String>[]) List<String> inputItemList,
    @Default(<String>[]) List<String> inputValueList,
    @Default(<String>[]) List<String> inputKindList,

    @Default('') String selectedBankKey,
  }) = _SpendInputState;
}

@riverpod
class SpendInput extends _$SpendInput {
  final Utility utility = Utility();

  ///
  @override
  SpendInputState build() {
    // ignore: always_specify_types
    final List<String> list = List.generate(10, (int index) => '');

    // ignore: always_specify_types
    final List<String> list2 = List.generate(10, (int index) => 0.toString());

    // ignore: always_specify_types
    final List<String> list3 = List.generate(10, (int index) => '');

    return SpendInputState(inputItemList: list, inputValueList: list2, inputKindList: list3);
  }

  ///
  void setPos({required int pos}) => state = state.copyWith(pos: pos);

  /// 入力欄を count 個以上に広げる（既存の支出が 10 件を超える日を編集する場合に使う）
  void ensureSlotCount({required int count}) {
    if (state.inputItemList.length >= count &&
        state.inputValueList.length >= count &&
        state.inputKindList.length >= count) {
      return;
    }

    List<String> grow(List<String> src, String fill) => <String>[
      ...src,
      for (int i = src.length; i < count; i++) fill,
    ];

    state = state.copyWith(
      inputItemList: grow(state.inputItemList, ''),
      inputValueList: grow(state.inputValueList, 0.toString()),
      inputKindList: grow(state.inputKindList, ''),
    );
  }

  ///
  void setInputItemList({required int pos, required String item}) {
    final List<String> list = <String>[...state.inputItemList];
    list[pos] = item;
    state = state.copyWith(inputItemList: list);
  }

  ///
  void setInputValueList({required int pos, required String value}) {
    final List<String> list = <String>[...state.inputValueList];
    list[pos] = value;
    state = state.copyWith(inputValueList: list);
  }

  ///
  void setInputKindList({required int pos, required String kind}) {
    final List<String> list = <String>[...state.inputKindList];
    list[pos] = kind;
    state = state.copyWith(inputKindList: list);
  }

  ///
  Future<void> insertSpend({
    required List<Map<String, dynamic>> insertDataDaily,
    required List<Map<String, dynamic>> insertDataCredit,
  }) async {
    final HttpClient client = ref.read(httpClientProvider);

    final Map<String, dynamic> uploadData = <String, dynamic>{};
    uploadData['insertDataDaily'] = insertDataDaily;
    uploadData['insertDataCredit'] = insertDataCredit;

    try {
      await client.post(path: APIPath.insertSpend, body: uploadData);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（spend_input）', error: e);
    }
  }
}
