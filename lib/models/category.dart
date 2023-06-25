import 'dart:convert';

class Category {
  String id;
  final String name;

  Category(this.id, this.name);

  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(id, data['name']);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name};
  }

  factory Category.fromJson(String data) {
    Map<String, dynamic> dataMap = jsonDecode(data) as Map<String, dynamic>;
    return Category(dataMap['id'], dataMap['name']);
  }

  String toJson() {
    return jsonEncode({'id': id, 'name': name});
  }
}
