import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/salary_model.dart';

class SalaryListAlert extends ConsumerStatefulWidget {
  const SalaryListAlert({super.key});

  @override
  ConsumerState<SalaryListAlert> createState() => _SalaryListAlertState();
}

class _SalaryListAlertState extends ConsumerState<SalaryListAlert> with ControllersMixin<SalaryListAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('salary list'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displaySalaryList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displaySalaryList() {
    final List<Widget> list = <Widget>[];

    final List<String> yearmonthList = <String>[];
    appParamState.keepSalaryMap.forEach((String key, List<SalaryModel> value) {
      if (!yearmonthList.contains('${key.split('-')[0]}-${key.split('-')[1]}')) {
        yearmonthList.add('${key.split('-')[0]}-${key.split('-')[1]}');
      }
    });

    String keepYear = '';
    final List<String> yearEndMonth = <String>[];
    for (int i = 0; i < yearmonthList.length; i++) {
      if (yearmonthList[i].split('-')[0].toInt() > 2023) {
        if (keepYear != yearmonthList[i].split('-')[0] && i > 0) {
          yearEndMonth.add(yearmonthList[i - 1]);
        }

        keepYear = yearmonthList[i].split('-')[0];
      }
    }

    yearEndMonth.add(
      '${appParamState.keepSalaryMap.entries.last.key.split('-')[0]}-${appParamState.keepSalaryMap.entries.last.key.split('-')[1]}',
    );

    keepYear = '';
    int yearSum = 0;
    int i = 0;
    appParamState.keepSalaryMap.forEach((String key, List<SalaryModel> value) {
      if (key.split('-')[0].toInt() >= 2023) {
        if (key.split('-')[0] != keepYear && i != 0) {
          yearSum = 0;
        }

        for (final SalaryModel element in value) {
          list.add(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),

              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text(element.yearmonth), Text(element.company)],
                    ),
                    Text(element.salary.toString().toCurrency()),
                  ],
                ),
              ),
            ),
          );

          yearSum += element.salary;
        }

        if (yearEndMonth.contains('${key.split('-')[0]}-${key.split('-')[1]}')) {
          list.add(
            Container(
              decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.1)),
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const SizedBox.shrink(), Text(yearSum.toString().toCurrency())],
              ),
            ),
          );
        }

        keepYear = key.split('-')[0];

        i++;
      }
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
