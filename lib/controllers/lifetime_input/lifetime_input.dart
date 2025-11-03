import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utils/ui_utils.dart';

part 'lifetime_input.freezed.dart';

part 'lifetime_input.g.dart';

@freezed
class LifetimeInputState with _$LifetimeInputState {
  const factory LifetimeInputState({
    @Default('') String selectedInputChoiceChip,
    @Default(-1) int itemPos,
    @Default(<String>[]) List<String> lifetimeStringList,
  }) = _LifetimeInputState;
}

@riverpod
class LifetimeInput extends _$LifetimeInput {
  ///
  @override
  LifetimeInputState build() {
    // ignore: always_specify_types
    final List<String> list = List.generate(24, (int index) => '');

    return LifetimeInputState(lifetimeStringList: list);
  }

  ///
  void setSelectedInputChoiceChip({required String item}) => state = state.copyWith(selectedInputChoiceChip: item);

  ///
  void setItemPos({required int pos}) => state = state.copyWith(itemPos: pos);

  ///
  Future<void> setLifetimeStringList({required int pos, required String item}) async {
    final List<String> items = <String>[...state.lifetimeStringList];
    items[pos] = item;
    state = state.copyWith(lifetimeStringList: items);
  }

  ///
  Future<void> inputLifetime({required String date}) async {
    final HttpClient client = ref.read(httpClientProvider);

    final List<String?> items = <String?>[...state.lifetimeStringList];

    final Map<String, dynamic> uploadData = <String, dynamic>{};
    uploadData['date'] = date;
    uploadData['lifetime'] = items.join('|');

    // ignore: always_specify_types
    await client.post(path: APIPath.insertLifetime, body: uploadData).then((value) {}).catchError((error, _) {
      UiUtils.showError('予期せぬエラーが発生しました');
    });
  }
}
