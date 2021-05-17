/// code model
class CodeModel extends Object {
  final String name;
  final String value;
  final List<dynamic>? children;

  CodeModel({required this.name, required this.value, this.children});

  // The json to model
  factory CodeModel.fromJson(Map<String, dynamic> json) => CodeModel(
      name: json['name'] as String,
      value: json['value'] as String,
      children: json['children'] != null
          ? CodeModelList.fromJson(json['children']).list
          : null);

  // The model to json
  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}

class CodeModelList {
  List<CodeModel> list;

  CodeModelList(this.list);

  factory CodeModelList.fromJson(List json) =>
      CodeModelList(json.map((item) => CodeModel.fromJson((item))).toList());
}
