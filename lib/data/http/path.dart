enum APIPath {
  getholiday,
  getLifetimeRecordItem,
  getLifetimeDateRecord,
  getLifetimeYearlyRecord,
  insertLifetime,
  getGenbaWorkTime,
  worktimemonthdata, //{"date":"2022-01-01"}
  worktimesummary,
  workinggenbaname,
  getAllLifetimeRecord,
  getsalary,
  getmonthlytimeplace,
  moneydl,
  getWalkRecord2,
  insertWalkRecord,
  getmonthSpendItem,
}

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getholiday:
        return 'getholiday';

      case APIPath.getLifetimeRecordItem:
        return 'getLifetimeRecordItem';
      case APIPath.insertLifetime:
        return 'insertLifetime';
      case APIPath.getLifetimeDateRecord:
        return 'getLifetimeDateRecord';
      case APIPath.getLifetimeYearlyRecord:
        return 'getLifetimeYearlyRecord';

      case APIPath.getGenbaWorkTime:
        return 'getGenbaWorkTime';
      case APIPath.worktimemonthdata:
        return 'worktimemonthdata';
      case APIPath.worktimesummary:
        return 'worktimesummary';
      case APIPath.workinggenbaname:
        return 'workinggenbaname';
      case APIPath.getAllLifetimeRecord:
        return 'getAllLifetimeRecord';
      case APIPath.getsalary:
        return 'getsalary';
      case APIPath.getmonthlytimeplace:
        return 'getmonthlytimeplace';
      case APIPath.moneydl:
        return 'moneydl';
      case APIPath.getWalkRecord2:
        return 'getWalkRecord2';
      case APIPath.insertWalkRecord:
        return 'insertWalkRecord';
      case APIPath.getmonthSpendItem:
        return 'getmonthSpendItem';
    }
  }
}
