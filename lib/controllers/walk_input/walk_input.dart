import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../models/walk_model.dart';
import '../../utils/ui_utils.dart';

part 'walk_input.freezed.dart';

part 'walk_input.g.dart';

@freezed
class WalkInputState with _$WalkInputState {
  const factory WalkInputState({
    @Default(<WalkModel>[]) List<WalkModel> walkList,
    @Default(<String, WalkModel>{}) Map<String, WalkModel> walkMap,
  }) = _WalkInputState;
}

@riverpod
class WalkInput extends _$WalkInput {
  ///
  @override
  WalkInputState build() => const WalkInputState();

  ///
  Future<void> inputWalkRecord({required String date, required String steps, required String distance}) async {
    final HttpClient client = ref.read(httpClientProvider);

    final Map<String, dynamic> uploadData = <String, dynamic>{};
    uploadData['date'] = date;
    uploadData['step'] = steps;
    uploadData['distance'] = distance;

    // ignore: always_specify_types
    await client.post(path: APIPath.insertWalkRecord, body: uploadData).then((value) {}).catchError((error, _) {
      UiUtils.showError('予期せぬエラーが発生しました');
    });
  }
}
