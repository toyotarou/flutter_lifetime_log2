import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/invest_model.dart';
import '../../../utility/utility.dart';

part 'invest_names.freezed.dart';

part 'invest_names.g.dart';

@freezed
class InvestNamesState with _$InvestNamesState {
  const factory InvestNamesState({
    @Default(<InvestNameModel>[]) List<InvestNameModel> investNamesList,
    @Default(<String, List<InvestNameModel>>{}) Map<String, List<InvestNameModel>> investNamesMap,
  }) = _InvestNamesState;
}

@Riverpod(keepAlive: true)
class InvestNames extends _$InvestNames {
  final Utility utility = Utility();

  @override
  InvestNamesState build() => const InvestNamesState();

  //============================================== api

  ///
  Future<InvestNamesState> fetchAllInvestNames() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<InvestNameModel> list = <InvestNameModel>[];

      final Map<String, List<InvestNameModel>> map = <String, List<InvestNameModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllInvestNames).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final InvestNameModel val = InvestNameModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map[val.kind] ??= <InvestNameModel>[]).add(val);
        }
      });

      return state.copyWith(investNamesList: list, investNamesMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllInvestNamesData() async {
    try {
      final InvestNamesState newState = await fetchAllInvestNames();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
