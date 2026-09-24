// ignore_for_file: public_member_api_docs, depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

import 'path.dart';

///////////////////////////////////////////////////////////////////
final Provider<HttpClient> httpClientProvider = Provider<HttpClient>(
  // ignore: deprecated_member_use
  (ProviderRef<HttpClient> ref) => HttpClient(),
);

/// このサイズ（バイト）を超えるレスポンスは別 isolate で JSON デコードし、UI スレッドのカクつきを防ぐ
const int _isolateDecodeThresholdBytes = 64 * 1024;

/// データを書き込む API（失敗しても自動で再試行しない。二重登録を防ぐため）
const Set<APIPath> _writeApiPaths = <APIPath>{
  APIPath.insertLifetime,
  APIPath.insertWalkRecord,
  APIPath.moneyinsert,
  APIPath.updateBankMoney,
  APIPath.insertDailyStockData,
  APIPath.insertSpend,
  APIPath.updateToushiShintakuRelationalId,
};

/// 読み込み系 API が失敗した時の再試行回数と待ち時間（1回目の失敗後 1 秒、2回目の失敗後 2 秒待つ）
const int _maxRetryCount = 2;

const Map<String, String> _headers = <String, String>{'content-type': 'application/json'};

/// isolate で実行するため、トップレベル関数にしている
dynamic _decodeJsonBytes(Uint8List bytes) {
  final String bodyString = utf8.decode(bytes);

  if (bodyString.isEmpty) {
    throw const FormatException('empty body');
  }

  return jsonDecode(bodyString);
}

////////////////////
class HttpClient {
  HttpClient() : _client = Client();

  final Client _client;

  /// 通信中のリクエスト数。画面側で ValueListenableBuilder を使い、0 より大きい間は読み込み中表示を出す
  final ValueNotifier<int> inFlightCount = ValueNotifier<int>(0);

  /// 通信中カウントを増減しながら request を実行する
  /// （リクエストは initState などビルド中に開始されることがあるため、
  ///   カウント変更＝画面の再構築はマイクロタスクに遅らせてビルド中の setState エラーを避ける）
  Future<Response> _track(Future<Response> Function() request) async {
    Future<void>.microtask(() => inFlightCount.value++);

    try {
      return await request();
    } finally {
      Future<void>.microtask(() => inFlightCount.value--);
    }
  }

  Future<dynamic> post({
    required APIPath path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final Uri uri = Uri.http(Environment.apiEndPoint, '${Environment.apiBasePath}/${path.value}', queryParameters);

    // 読み込み系は一時的な失敗（タイムアウト・通信断・サーバーエラー）なら再試行する。
    // 起動時・再起動時は約30本を同時に取得するため、サーバーが混んで一部が失敗することがある
    final bool isReadApi = !_writeApiPaths.contains(path);

    return _withRetry(
      retry: isReadApi,
      request: () async {
        final Response response = await _track(
          () => _client.post(uri, headers: _headers, body: json.encode(body)).timeout(const Duration(seconds: 30)),
        );

        // 書き込み系は従来どおりステータスで判定しない（挙動を変えない）
        if (isReadApi) {
          _checkStatus(response);
        }

        return _decode(response);
      },
    );
  }

  ///
  Future<dynamic> getByPath({required String path, Map<String, dynamic>? queryParameters}) async {
    // GET は読み込みのみなので、一時的な失敗なら再試行する
    return _withRetry(
      retry: true,
      request: () async {
        final Response response = await _track(
          () => _client.get(Uri.parse(path), headers: _headers).timeout(const Duration(seconds: 30)),
        );

        _checkStatus(response);

        return _decode(response);
      },
    );
  }

  /// retry が true の時、失敗したら少し待って最大 _maxRetryCount 回まで再試行する
  Future<dynamic> _withRetry({required bool retry, required Future<dynamic> Function() request}) async {
    int attempt = 0;

    while (true) {
      try {
        return await request();
      } on Object catch (e) {
        if (!retry || attempt >= _maxRetryCount) {
          rethrow;
        }

        attempt++;
        debugPrint('API retry ($attempt/$_maxRetryCount): $e');

        await Future<void>.delayed(Duration(seconds: attempt));
      }
    }
  }

  /// 5xx（サーバー側の一時的なエラー）は例外にして再試行の対象にする
  void _checkStatus(Response response) {
    if (response.statusCode >= 500) {
      throw Exception('server error ${response.statusCode}');
    }
  }

  ///
  Future<dynamic> _decode(Response response) async {
    final Uint8List bytes = response.bodyBytes;

    try {
      if (bytes.length > _isolateDecodeThresholdBytes) {
        return await compute(_decodeJsonBytes, bytes);
      }

      return _decodeJsonBytes(bytes);
    } on Object catch (_) {
      throw Exception('json parse error');
    }
  }
}

///////////////////////////////////////////////////////////////////
class Environment {
  Environment._();

  static String get apiEndPoint => 'toyohide.work';

  static String get apiBasePath => 'BrainLog/api';
}
