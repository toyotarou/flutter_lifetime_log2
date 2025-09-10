import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utility/utility.dart';

part 'toushi_shintaku_input.freezed.dart';

part 'toushi_shintaku_input.g.dart';

@freezed
class ToushiShintakuInputState with _$ToushiShintakuInputState {
  const factory ToushiShintakuInputState({
    @Default(<String>[]) List<String> relationalIdList,
    @Default(<Map<String, int>>[]) List<Map<String, int>> relationalIdMapList,
  }) = _ToushiShintakuInputState;
}

@Riverpod(keepAlive: true)
class ToushiShintakuInput extends _$ToushiShintakuInput {
  final Utility utility = Utility();

  ///
  @override
  ToushiShintakuInputState build() {
    // ignore: always_specify_types
    final List<Map<String, int>> list = List.generate(20, (int index) => <String, int>{'': 0});
    // ignore: always_specify_types
    final List<String> list2 = List.generate(20, (int index) => '');

    return ToushiShintakuInputState(relationalIdMapList: list, relationalIdList: list2);
  }

  ///
  void clearRelationalIdList() {
    // ignore: always_specify_types
    final List<String> list2 = List.generate(20, (int index) => '');

    state = state.copyWith(relationalIdList: list2);
  }

  ///
  Future<void> setInputValue({required int pos, required int relationalId, required int id}) async {
    final List<Map<String, int>> list = <Map<String, int>>[...state.relationalIdMapList];
    final Map<String, int> map = <String, int>{id.toString(): relationalId};
    list[pos] = map;

    final List<String> list2 = <String>[...state.relationalIdList];
    list2[pos] = relationalId.toString();

    state = state.copyWith(relationalIdMapList: list, relationalIdList: list2);
  }

  ///
  Future<void> updateToushiShintakuRelationalId({required Map<String, int> updateData}) async {
    final HttpClient client = ref.read(httpClientProvider);

    final Map<String, dynamic> uploadData = <String, dynamic>{};
    uploadData['updateData'] = updateData;

    // ignore: always_specify_types
    await client.post(path: APIPath.updateToushiShintakuRelationalId, body: uploadData).then((value) {}).catchError((
      // ignore: always_specify_types
      error,
      _,
    ) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
