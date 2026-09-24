import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/gold_model.dart';
import '../../../utility/utility.dart';

part 'gold.freezed.dart';

part 'gold.g.dart';

@freezed
class GoldState with _$GoldState {
  const factory GoldState({
    @Default(<GoldModel>[]) List<GoldModel> goldList,
    @Default(<String, GoldModel>{}) Map<String, GoldModel> goldMap,
    @Default(false) bool goldFlag,
  }) = _GoldState;
}

@Riverpod(keepAlive: true)
class Gold extends _$Gold {
  final Utility utility = Utility();

  @override
  GoldState build() => const GoldState();

  //============================================== api

  ///
  Future<GoldState> fetchAllGold() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<GoldModel> list = <GoldModel>[];
      final Map<String, GoldModel> map = <String, GoldModel>{};

      final dynamic value = await client.post(path: APIPath.getgolddata);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final GoldModel val = GoldModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        map['${val.year}-${val.month}-${val.day}'] = val;
      }

      return state.copyWith(goldList: list, goldMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（gold）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllGoldData() async {
    try {
      final GoldState newState = await fetchAllGold();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
