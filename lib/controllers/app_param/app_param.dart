import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/lifetime_item_model.dart';
import '../../models/money_model.dart';
import '../../models/walk_model.dart';
import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default(<String>[]) List<String> keepHolidayList,
    @Default(<String, WalkModel>{}) Map<String, WalkModel> keepWalkModelMap,
    @Default(<String, MoneyModel>{}) Map<String, MoneyModel> keepMoneyMap,
    @Default(<LifetimeItemModel>[]) List<LifetimeItemModel> keepLifetimeItemList,
  }) = _AppParamState;
}

@riverpod
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setKeepHolidayList({required List<String> list}) => state = state.copyWith(keepHolidayList: list);

  ///
  void setKeepWalkModelMap({required Map<String, WalkModel> map}) => state = state.copyWith(keepWalkModelMap: map);

  ///
  void setKeepMoneyMap({required Map<String, MoneyModel> map}) => state = state.copyWith(keepMoneyMap: map);

  ///
  void setKeepLifetimeItemList({required List<LifetimeItemModel> list}) =>
      state = state.copyWith(keepLifetimeItemList: list);
}
