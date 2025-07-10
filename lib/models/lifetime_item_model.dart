/*
http://toyohide.work/BrainLog/api/getLifetimeRecordItem

*/

class LifetimeItemModel {
  LifetimeItemModel({required this.item});

  factory LifetimeItemModel.fromJson(Map<String, dynamic> json) => LifetimeItemModel(item: json['item'].toString());
  final String item;

  LifetimeItemModel copyWith({String? item}) => LifetimeItemModel(item: item ?? this.item);

  Map<String, dynamic> toJson() => <String, dynamic>{'item': item};
}
