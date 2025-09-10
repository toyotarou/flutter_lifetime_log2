import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../utility/utility.dart';

part 'toushi_shintaku_input.freezed.dart';

part 'toushi_shintaku_input.g.dart';

@freezed
class ToushiShintakuInputState with _$ToushiShintakuInputState {
  const factory ToushiShintakuInputState({@Default(<String, int>{}) Map<String, int> relationalIdMap}) =
      _ToushiShintakuInputState;
}

@Riverpod(keepAlive: true)
class ToushiShintakuInput extends _$ToushiShintakuInput {
  final Utility utility = Utility();

  ///
  @override
  ToushiShintakuInputState build() => const ToushiShintakuInputState();

  ///
  Future<void> setInputValue({required int relationalId, required int id}) async {
    final Map<String, int> map = <String, int>{...state.relationalIdMap};
    map[id.toString()] = relationalId;
    state = state.copyWith(relationalIdMap: map);
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
