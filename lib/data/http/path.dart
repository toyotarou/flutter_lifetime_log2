enum APIPath {
  getholiday,
  getAllLifetimeRecord,
  getLifetimeRecordItem,
  getWalkRecord2,
  getAllMoney,
  insertLifetime,
  insertWalkRecord,
  moneyinsert,
  getAllTemple,
  getTempleLatLng,
  getTempleDatePhoto,

  // getGenbaWorkTime,
  // worktimemonthdata, //{"date":"2022-01-01"}
  // worktimesummary,
  // workinggenbaname,

  // getsalary,
  // getmonthlytimeplace,

  //  // getmonthSpendItem,
}

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getholiday:
        return 'getholiday';

      case APIPath.getAllLifetimeRecord:
        return 'getAllLifetimeRecord';

      case APIPath.getLifetimeRecordItem:
        return 'getLifetimeRecordItem';

      case APIPath.getWalkRecord2:
        return 'getWalkRecord2';

      case APIPath.getAllMoney:
        return 'getAllMoney';

      case APIPath.insertLifetime:
        return 'insertLifetime';

      case APIPath.insertWalkRecord:
        return 'insertWalkRecord';

      case APIPath.moneyinsert:
        return 'moneyinsert';

      case APIPath.getAllTemple:
        return 'getAllTemple';
      case APIPath.getTempleLatLng:
        return 'getTempleLatLng';
      case APIPath.getTempleDatePhoto:
        return 'getTempleDatePhoto';

      // case APIPath.getGenbaWorkTime:
      //   return 'getGenbaWorkTime';
      // case APIPath.worktimemonthdata:
      //   return 'worktimemonthdata';
      // case APIPath.worktimesummary:
      //   return 'worktimesummary';
      // case APIPath.workinggenbaname:
      //   return 'workinggenbaname';

      // case APIPath.getsalary:
      //   return 'getsalary';
      // case APIPath.getmonthlytimeplace:
      //   return 'getmonthlytimeplace';

      // case APIPath.getmonthSpendItem:
      //   return 'getmonthSpendItem';
    }
  }
}
