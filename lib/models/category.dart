class Category {
  final String id;
  final String name;

  Category(this.id, this.name);

  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(id, data['name']);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name};
  }
}
