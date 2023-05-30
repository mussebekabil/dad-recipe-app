class Recipe {
  final String id;
  final String name;
  final String ingredients;
  final String steps;

  Recipe(this.id, this.name, this.ingredients, this.steps);

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Recipe(id, data['name'], data['ingredients'], data['steps']);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'ingredients': ingredients, 'steps': steps};
  }
}
