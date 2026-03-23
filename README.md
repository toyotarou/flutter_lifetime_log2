# flutter_lifetime_log2

**LIFETIME LOG** — 日々の生活データを網羅的に記録・可視化する Flutter 製の個人ライフログアプリです。
家計・資産・投資・労働・健康・行動・趣味など、人生のあらゆる側面をひとつのアプリで一元管理します。

---

## 主な機能

### ライフログ
- **ライフタイム記録** — 人生の出来事・マイルストーンをタイムライン形式で管理
- **週次・月次ヒストリー** — 週・月単位でライフログをふり返るカレンダービュー
- **年次イベント** — 年ごとのスパンで記録したイベントの一覧表示
- **アイテム検索** — 登録済みライフタイムアイテムのキーワード検索

### 家計・支出
- **支出記録** — 日付・カテゴリ・金額を紐付けて支出を記録
- **月次支出集計** — 月別の支出サマリー・グラフ・ピックアップ表示
- **年次支出集計** — 年別支出の推移・クロス集計表
- **同日比較** — 過去の同月同日の支出と比較表示
- **クレジットカード** — 月次クレジット利用明細・カレンダー・棒グラフ表示
- **モバイルSuicaチャージ履歴** — チャージ記録の一覧表示
- **Amazon購入履歴** — Amazon での購入記録管理

### 資産・投資
- **手持ち現金** — 現金残高の記録・グラフ・推移表示
- **銀行口座** — 銀行残高の入力・月末残高・月次推移
- **給与** — 給与明細データの記録・一覧表示
- **株式** — 株式投資の記録・銘柄管理
- **投資信託（投資信託）** — 投資信託データの記録・更新
- **ゴールド** — 金の保有・価格記録
- **ファンド** — ファンド投資の関連データ管理
- **資産詳細グラフ** — 月次・年次・詳細な資産グラフ（割合・推移）
- **週次資産平均** — 週ごとの資産平均の追跡

### 健康・行動
- **ウォーキング** — 歩行記録（日付・歩数・距離）の入力・一覧
- **天気** — 日ごとの天気記録

### 位置情報・地図
- **GPS位置情報** — 記録した位置情報の月次・全期間マップ表示（OpenStreetMap）
- **逆ジオコーディング** — 緯度・経度から住所を取得
- **東京市区町村マップ** — 東京都の市区町村データをマップに重ね表示

### 交通・お寺
- **交通機関** — 利用駅・路線の記録、ルート情報表示
- **お寺** — お寺の一覧・写真・訪問日・地図上のマーカー・道案内表示

### スタンプラリー（東京メトロ）
- **全駅スタンプラリー** — 東京メトロ全駅のスタンプ取得状況管理
- **20周年スタンプラリー** — メトロ20周年記念スタンプラリーの進捗管理
- **ポケポケスタンプラリー** — ポケポケスタンプラリーの記録
- **地図表示** — スタンプ取得駅の地図可視化

### 占い・タロット
- **フォーチュン** — 占い結果の記録・表示
- **タロットカード** — カード情報・引いた履歴の管理

### 勤務管理
- **勤務時間** — 月次・年次の勤務時間記録・表示
- **職歴** — 職歴・雇用契約情報の管理

---

## 技術スタック

| カテゴリ | 技術 |
|---|---|
| フレームワーク | [Flutter](https://flutter.dev/) (Dart SDK ^3.8.1) |
| 状態管理 | [Riverpod](https://riverpod.dev/) (hooks_riverpod / riverpod_annotation) |
| データ取得 | HTTP API（`http` パッケージ + `.env` による接続先管理） |
| コード生成 | freezed / json_serializable / riverpod_generator / build_runner |
| 地図 | [flutter_map](https://pub.dev/packages/flutter_map) + [latlong2](https://pub.dev/packages/latlong2) (OpenStreetMap) |
| グラフ | [fl_chart](https://pub.dev/packages/fl_chart) |
| 画像 | [cached_network_image](https://pub.dev/packages/cached_network_image) + [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager) |
| UI | [flutter_carousel_slider](https://pub.dev/packages/flutter_carousel_slider), [dotted_line](https://pub.dev/packages/dotted_line), [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) |
| 環境変数 | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) |

---

## 対応プラットフォーム

- Android
- iOS
- macOS
- Windows
- Linux

---

## データモデル一覧

| モデル | 概要 |
|---|---|
| `LifetimeModel` | ライフタイムイベント記録 |
| `WalkModel` | 歩行・健康記録 |
| `MoneyModel` | 手持ち現金残高 |
| `MoneySpendModel` | 支出記録 |
| `WorkTimeModel` | 勤務時間 |
| `SalaryModel` | 給与データ |
| `GoldModel` | ゴールド保有・価格 |
| `StockModel` | 株式投資 |
| `ToushiShintakuModel` | 投資信託 |
| `FundModel` | ファンド投資 |
| `CreditSummaryModel` | クレジットカード利用サマリー |
| `GeolocModel` | GPS位置情報 |
| `TempleModel` | お寺情報 |
| `TransportationModel` | 交通機関・駅 |
| `StampRallyModel` | スタンプラリー進捗 |
| `AmazonPurchaseModel` | Amazon購入履歴 |
| `TimePlaceModel` | 時間・場所の記録 |
| `WeatherModel` | 天気記録 |
| `FortuneModel` | 占い結果 |
| `TarotModel` / `TarotHistoryModel` | タロットカード・履歴 |
| `InvestModel` | 投資データ |

---

## プロジェクト構成

```
lib/
├── main.dart                  # エントリーポイント・全データ初期取得
├── controllers/               # Riverpodコントローラー・Mixin
├── models/                    # Freezedデータモデル
├── data/http/                 # HTTP通信層（API呼び出し）
├── screens/
│   ├── home_screen.dart       # ホーム画面（メインUI）
│   ├── components/            # 各機能ダイアログ・アラート（50+コンポーネント）
│   ├── page/                  # フルページ画面
│   └── parts/                 # 共通UIパーツ
├── const/                     # 定数定義
├── enums/                     # 列挙型
├── extensions/                # 拡張メソッド
├── mixin/                     # Mixinクラス
└── utility/                   # ユーティリティ
assets/
├── images/                    # 画像リソース
└── json/                      # 東京市区町村データ等のJSONファイル
.env                           # API接続先など環境変数（要作成）
```

---

## セットアップ

### 前提条件

- Flutter SDK (Dart ^3.8.1)
- バックエンド API サーバー（データはすべてHTTP経由で取得）

### インストール手順

```bash
# リポジトリをクローン
git clone https://github.com/toyotarou/flutter_lifetime_log2.git
cd flutter_lifetime_log2

# 依存パッケージをインストール
flutter pub get

# コード生成（Freezed / Riverpod）
dart run build_runner build --delete-conflicting-outputs

# 環境変数ファイルを作成
cp .env.example .env   # または直接 .env を作成してAPIエンドポイントを設定

# アプリを実行
flutter run
```

### 環境変数（`.env`）

`.env` ファイルにバックエンドの接続先を設定してください。

```
API_BASE_URL=https://your-api-server.example.com
```

---

## ライセンス

このプロジェクトはプライベートリポジトリです (`publish_to: 'none'`)。
