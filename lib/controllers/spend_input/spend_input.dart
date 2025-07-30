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
  Future<void> insertDataDaily({required Map<String, dynamic> insertData}) async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client
        .post(
          path: APIPath.insertDailySpend,
          body: <String, String>{'record': '${insertData['date']}|${insertData['koumoku']}|${insertData['price']}'},
        )
        // ignore: always_specify_types
        .then((value) {})
        // ignore: always_specify_types
        .catchError((error, _) {
          utility.showError('予期せぬエラーが発生しました');
        });
  }

  ///
  Future<void> insertDataCredit({required Map<String, dynamic> insertData}) async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client
        .post(
          path: APIPath.insertCredit,
          body: <String, String>{'record': '${insertData['date']}|${insertData['item']}|${insertData['price']}'},
        )
        // ignore: always_specify_types
        .then((value) {})
        // ignore: always_specify_types
        .catchError((error, _) {
          utility.showError('予期せぬエラーが発生しました');
        });
  }
}
