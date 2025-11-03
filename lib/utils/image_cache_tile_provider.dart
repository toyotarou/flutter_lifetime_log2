import 'dart:ui' as ui;

import 'package:file/src/interface/file.dart'; // ignore: depend_on_referenced_packages, implementation_imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';

/// flutter_map 用: タイル画像を CacheManager 経由で供給
class CachedTileProvider extends TileProvider {
  final BaseCacheManager cacheManager = DefaultCacheManager();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final String url = getTileUrl(coordinates, options);
    return CachedNetworkImage(url, cacheManager: cacheManager);
  }

  @override
  String getTileUrl(TileCoordinates coordinates, TileLayer options) {
    return options.urlTemplate!
        .replaceAll('{z}', coordinates.z.toString())
        .replaceAll('{x}', coordinates.x.toString())
        .replaceAll('{y}', coordinates.y.toString());
  }
}

/// 単純なキャッシュ付 ImageProvider。失敗時は例外を投げるので呼出側でフォールバック推奨
class CachedNetworkImage extends ImageProvider<CachedNetworkImage> {
  CachedNetworkImage(this.url, {required this.cacheManager});

  final String url;
  final BaseCacheManager cacheManager;

  @override
  Future<CachedNetworkImage> obtainKey(ImageConfiguration configuration) => SynchronousFuture<CachedNetworkImage>(this);

  @override
  ImageStreamCompleter loadBuffer(
    CachedNetworkImage key,
    Future<ui.Codec> Function(ui.ImmutableBuffer buffer, {int? cacheWidth, int? cacheHeight}) decode,
  ) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  Future<ImageInfo> _loadAsync(
    CachedNetworkImage key,
    Future<ui.Codec> Function(ui.ImmutableBuffer buffer, {int? cacheWidth, int? cacheHeight}) decode,
  ) async {
    final File file = await cacheManager.getSingleFile(key.url);
    final Uint8List bytes = await file.readAsBytes();

    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final ui.Codec codec = await decode(buffer);
    final ui.FrameInfo frame = await codec.getNextFrame();

    return ImageInfo(image: frame.image);
  }
}
