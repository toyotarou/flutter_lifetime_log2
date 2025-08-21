// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../controllers/controllers_mixin.dart';
// import '../../extensions/extensions.dart';
// import '../../models/invest_model.dart';
//
// class AssetsDetailListAlert extends ConsumerStatefulWidget {
//   const AssetsDetailListAlert({super.key, required this.data});
//
//   final InvestNameModel data;
//
//   @override
//   ConsumerState<AssetsDetailListAlert> createState() => _AssetsDetailListAlertState();
// }
//
// class _AssetsDetailListAlertState extends ConsumerState<AssetsDetailListAlert>
//     with ControllersMixin<AssetsDetailListAlert> {
//   ///
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//
//       body: SafeArea(
//         child: DefaultTextStyle(
//           style: const TextStyle(color: Colors.white),
//
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: <Widget>[
//                 Text(widget.data.name),
//
//                 Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
//
//                 Expanded(child: _displayAssetsDetailList()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///
//   Widget _displayAssetsDetailList() {
//     final List<Widget> list = <Widget>[];
//
//     int keepCost = 0;
//     appParamState.keepInvestRecordMap[widget.data.relationalId]?.forEach((InvestRecordModel element) {
//       final Color color = (keepCost != element.cost) ? Colors.yellowAccent : Colors.white;
//
//       list.add(
//         DefaultTextStyle(
//           style: const TextStyle(fontSize: 12),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
//             ),
//             padding: const EdgeInsets.all(5),
//
//             child: Row(
//               children: <Widget>[
//                 Expanded(child: Text(element.date)),
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.topRight,
//                     child: Text(element.cost.toString().toCurrency(), style: TextStyle(fontSize: 12, color: color)),
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Container(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency())),
//                 ),
//
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.topRight,
//                     child: Text((element.price - element.cost).toString().toCurrency()),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//
//       keepCost = element.cost;
//     });
//
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (BuildContext context, int index) => list[index],
//             childCount: list.length,
//           ),
//         ),
//       ],
//     );
//   }
// }
