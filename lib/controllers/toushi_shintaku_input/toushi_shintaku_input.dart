import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utility/utility.dart';

part 'toushi_shintaku_input.freezed.dart';

part 'toushi_shintaku_input.g.dart';

@freezed
class ToushiShintakuInputState with _$ToushiShintakuInputState {
  const factory ToushiShintakuInputState({@Default(<Map<int, int>>[]) List<Map<int, int>> relationalIdMapList}) =
      _ToushiShintakuInputState;
}

@Riverpod(keepAlive: true)
class ToushiShintakuInput extends _$ToushiShintakuInput {
  final Utility utility = Utility();

  ///
  @override
  ToushiShintakuInputState build() {
    // ignore: always_specify_types
    final List<Map<int, int>> list = List.generate(20, (int index) => <int, int>{0: 0});

    return ToushiShintakuInputState(relationalIdMapList: list);
  }

  ///
  Future<void> setInputValue({required int pos, required int relationalId, required int id}) async {
    final List<Map<int, int>> list = <Map<int, int>>[...state.relationalIdMapList];
    final Map<int, int> map = <int, int>{id: relationalId};
    list[pos] = map;
    state = state.copyWith(relationalIdMapList: list);
  }

  // ///
  // Future<void> updateToushiShintakuRelationalId({required Map<String, int> updateData}) async {
  //   final HttpClient client = ref.read(httpClientProvider);
  //
  //   final Map<String, dynamic> uploadData = <String, dynamic>{};
  //   uploadData['updateData'] = updateData;
  //
  //   // ignore: always_specify_types
  //   await client.post(path: APIPath.updateToushiShintakuRelationalId, body: uploadData).then((value) {}).catchError((
  //     // ignore: always_specify_types
  //     error,
  //     _,
  //   ) {
  //     utility.showError('予期せぬエラーが発生しました');
  //   });
  // }
  //
  //
  //
  //
  //
}
