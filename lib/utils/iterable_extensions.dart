/// Kotlin の sumBy 的な汎用集計
extension IterableSumBy<T> on Iterable<T> {
  int sumByInt(int Function(T e) selector) {
    int sum = 0;
    // ignore: always_specify_types
    for (final e in this) {
      sum += selector(e);
    }
    return sum;
  }
}
