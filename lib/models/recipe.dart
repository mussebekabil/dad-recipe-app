class Recipe {
  final String id;
  final String name;
  final String ingredients;
  final String steps;
  final String categoryId;

  Recipe(this.id, this.name, this.ingredients, this.steps, this.categoryId);

  factory Recipe.fromFirestore(
      Map<String, dynamic> data, String id, String ctgId) {
    return Recipe(id, data['name'], data['ingredients'], data['steps'], ctgId);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'ingredients': ingredients, 'steps': steps};
  }
}
