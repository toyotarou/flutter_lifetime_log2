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
  gettrainrecord,
  getBusStopAddress,
  getDupSpot,
  updateBankMoney,
  getAllDailySpend,
  getAllCredit,
  worktimesummary,
  getAllWeather,
  getMoneySpendItem,
  getAllBenefit,
  insertDailyStockData,
  getgolddata,
  getAllStockData,
  getAllToushiShintakuData,
  getTempleDatePhoto,
  getTrain,
  getCreditSummary,
  insertSpend,
  getFund,
  getAllTimePlaceRecord,
  updateToushiShintakuRelationalId,
  getAmazonData,
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

      case APIPath.gettrainrecord:
        return 'gettrainrecord';
      case APIPath.getBusStopAddress:
        return 'getBusStopAddress';
      case APIPath.getDupSpot:
        return 'getDupSpot';

      case APIPath.updateBankMoney:
        return 'updateBankMoney';

      case APIPath.getAllDailySpend:
        return 'getAllDailySpend';
      case APIPath.getAllCredit:
        return 'getAllCredit';

      case APIPath.worktimesummary:
        return 'worktimesummary';

      case APIPath.getAllWeather:
        return 'getAllWeather';

      case APIPath.getMoneySpendItem:
        return 'getMoneySpendItem';

      case APIPath.getAllBenefit:
        return 'getAllBenefit';

      case APIPath.insertDailyStockData:
        return 'insertDailyStockData';
      case APIPath.getgolddata:
        return 'getgolddata';
      case APIPath.getAllStockData:
        return 'getAllStockData';
      case APIPath.getAllToushiShintakuData:
        return 'getAllToushiShintakuData';

      case APIPath.getTempleDatePhoto:
        return 'getTempleDatePhoto';

      case APIPath.getTrain:
        return 'getTrain';

      case APIPath.getCreditSummary:
        return 'getCreditSummary';

      case APIPath.insertSpend:
        return 'insertSpend';
      case APIPath.getFund:
        return 'getFund';

      case APIPath.getAllTimePlaceRecord:
        return 'getAllTimePlaceRecord';

      case APIPath.updateToushiShintakuRelationalId:
        return 'updateToushiShintakuRelationalId';

      case APIPath.getAmazonData:
        return 'getAmazonData';
    }
  }
}
