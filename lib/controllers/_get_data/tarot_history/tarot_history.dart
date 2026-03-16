import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/tarot_history_model.dart';
import '../../../utility/utility.dart';

part 'tarot_history.freezed.dart';

part 'tarot_history.g.dart';

/*

{
    "data": [
        {
            "year": "2021",
            "month": "09",
            "day": "12",
            "id": 54,
            "name": "Swords 4",
            "image": "swords04",
            "reverse": "1",
            "word": "動く / 急ぐ / 行動的 / 躍動的 / 外交的になる"
        },

*/

@freezed
class TarotHistoryState with _$TarotHistoryState {
  const factory TarotHistoryState({
    @Default(<TarotHistoryModel>[]) List<TarotHistoryModel> tarotHistoryList,
    @Default(<String, TarotHistoryModel>{}) Map<String, TarotHistoryModel> tarotHistoryMap,
  }) = _TarotHistoryState;
}

@Riverpod(keepAlive: true)
class TarotHistory extends _$TarotHistory {
  final Utility utility = Utility();

  ///
  @override
  TarotHistoryState build() => const TarotHistoryState();

  //============================================== api

  ///
  Future<TarotHistoryState> fetchAllTarotHistoryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TarotHistoryModel> list = <TarotHistoryModel>[];

      final Map<String, TarotHistoryModel> map = <String, TarotHistoryModel>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.tarothistory).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final TarotHistoryModel val = TarotHistoryModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          map['${val.year}-${val.month}-${val.day}'] = val;
        }
      });

      return state.copyWith(tarotHistoryList: list, tarotHistoryMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTarotHistoryData() async {
    try {
      final TarotHistoryState newState = await fetchAllTarotHistoryData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
