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

    final Response response = await _track(
      () => _client.post(uri, headers: _headers, body: json.encode(body)).timeout(const Duration(seconds: 15)),
    );

    return _decode(response);
  }

  ///
  Future<dynamic> getByPath({required String path, Map<String, dynamic>? queryParameters}) async {
    final Response response = await _track(
      () => _client.get(Uri.parse(path), headers: _headers).timeout(const Duration(seconds: 30)),
    );

    return _decode(response);
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
