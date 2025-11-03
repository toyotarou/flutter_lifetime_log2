import '../models/temple_model.dart';

/// 寺社ドメイン固有のパース・整形
class TempleUtils {
  TempleUtils._();

  /// 撮影ファイル名から来訪時刻を推定（"yyyy/mm/dd/...._HHmm_...." 想定）
  static String getTempleReachTimeFromTemplePhotoList({required String date, required TempleDataModel temple}) {
    String ret = '-';
    List<String> photoList = <String>[];

    if (temple.templePhotoModelList != null) {
      for (final TemplePhotoModel element in temple.templePhotoModelList!) {
        if (element.date == date) {
          photoList = element.templephotos;
        }
      }
    }

    if (photoList.isNotEmpty) {
      final String firstPhoto = photoList.first;
      final List<String> exFirstPhoto = firstPhoto.split('/');
      final List<String> exFirstPhotoLast = exFirstPhoto[exFirstPhoto.length - 1].split('_');
      final String hour = exFirstPhotoLast[1].substring(0, 2);
      final String minute = exFirstPhotoLast[1].substring(2, 4);
      ret = '$hour:$minute';
    }
    return ret;
  }
}
