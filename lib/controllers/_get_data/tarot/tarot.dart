import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/tarot_model.dart';
import '../../../utility/utility.dart';

part 'tarot.freezed.dart';

part 'tarot.g.dart';

/*


{
    "data": [
        {
            "id": 1,
            "name": "The Fool",
            "image": "big00",
            "prof1": "何にも縛られず無限の自由を謳歌する",
            "prof2": "着の身着のまま、身軽な荷物でふらふらと歩く旅人。片手には摘んだ花を持ち、存分に自由を謳歌していることが見て取れます。ただし、足の向かう先に道はありません。犬が危険を忠告していますが、気づく様子はなく…。そんな「愚者」のカードは自由さと同時に、一歩先がどうなるかわからない未知な状態を表しています。無限の可能性に溢れていますが、崖から転落するかもしれません。それでも、「なるようになる」と楽観的な状態を示すカードです。",
            "word_j": "旅立ち / 始まり / 自然 / 巻き返し / 挽回 / 純粋無垢",
            "word_r": "未熟な言動 / 浅はかな言動 / 愚か / 未熟",
            "msg_j": "何がどうなるかわからない",
            "msg_r": "決まってないが故に翻弄される",
            "msg2_j": "欲求に忠実に行動し、未知の世界にも飛び込む無謀さと勇敢さを持つことを示します。",
            "msg2_r": "意味のない行動やコロコロと変わる気分を示します。占い時に集中力が欠けている場合や、未来が未確定の場合に出ることも。",
            "msg3_j": "未知の分野でも怖れる前に行動を起こしましょう。今は“見る前に跳べ”あれこれ考えるより先に本当にやってしまうほうが運命を切り開くことができるタイミングです。「何をやってもうまくいく」という根拠のない自信が大事です。",
            "msg3_r": "状況や空気を読んで、他人の話をよく聞いて行動したい時です。思慮に欠ける無謀な行動は最終的にあなたのためにはならないでしょう。今のままで無理に動けば動くほどうまくいかなくなり、あなたの手には何も残りません。",
            "drawNum": "21 / 1647",
            "drawNum_j": [
                "2021-10-18",
                "2022-04-16",
                "2022-09-22",
                "2023-07-08",
                "2023-07-20",
                "2023-11-06",
                "2023-12-01",
                "2024-02-05",
                "2024-04-01",
                "2024-07-26",
                "2025-04-28",
                "2025-05-14",
                "2025-06-09",
                "2025-09-01"
            ],
            "drawNum_r": [
                "2022-04-06",
                "2022-08-05",
                "2023-04-27",
                "2023-05-10",
                "2023-06-01",
                "2023-11-09",
                "2025-05-09"
            ],
            "feel_j": 9,
            "feel_r": 1
        },


*/

@freezed
class TarotState with _$TarotState {
  const factory TarotState({
    @Default(<TarotModel>[]) List<TarotModel> tarotList,
    @Default(<String, TarotModel>{}) Map<String, TarotModel> tarotMap,
  }) = _TarotState;
}

@Riverpod(keepAlive: true)
class Tarot extends _$Tarot {
  final Utility utility = Utility();

  ///
  @override
  TarotState build() => const TarotState();

  //============================================== api

  ///
  Future<TarotState> fetchAllTarotData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TarotModel> list = <TarotModel>[];
      final Map<String, TarotModel> map = <String, TarotModel>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllTarot).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final TarotModel val = TarotModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          map[val.image] = val;
        }
      });

      return state.copyWith(tarotList: list, tarotMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTarotData() async {
    try {
      final TarotState newState = await fetchAllTarotData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
