import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';
import '../models/category.dart';
import '../providers/category.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  void setRecipes(List<Recipe> recipes) {
    state = recipes;
  }

  void addRecipe(
      String ctgId, String name, String ingredients, String steps) async {
    final newRecipe = Recipe('', name, ingredients, steps, ctgId).toFirestore();

    final noteRef = await _firestore
        .collection('category')
        .doc(ctgId)
        .collection('recipes')
        .add(newRecipe);
    final recipe = Recipe.fromFirestore(newRecipe, noteRef.id, ctgId);

    state = [...state, recipe];
  }

  void deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
    state = state.where((recipe) => recipe.id != id).toList();
  }
}

final recipesProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>(
    (ref) => RecipeNotifier());

Future<List<Recipe>> fetchRecipes(String categoryId) async {
  final snapshot = await _firestore
      .collection('category')
      .doc(categoryId)
      .collection('recipes')
      .get();
  return snapshot.docs.map((doc) {
    return Recipe.fromFirestore(doc.data(), doc.id, categoryId);
  }).toList();
}

final recipesFutureProvider = FutureProvider<List<Recipe>>((ref) async {
  Category? ctg = await ref.watch(categoryFutureProvider.future);
  List<Recipe> recipes = [];

  if (ctg == null) {
    final categories = await fetchCategories();
    for (var ctg in categories) {
      final recipesForCtg = await fetchRecipes(ctg.id);
      ref.watch(recipesProvider.notifier).setRecipes(recipesForCtg);
      recipes = [
        ...recipes,
        ...recipesForCtg,
      ];
    }
  } else {
    final recipesForCtg = await fetchRecipes(ctg.id);

    ref.watch(recipesProvider.notifier).setRecipes(recipesForCtg);
    recipes = [...recipesForCtg];
  }
  return recipes;
});

final featuredRecipeFutureProvider = FutureProvider<Recipe>((ref) async {
  Category featuredCtg = await pickRandomCategory();
  final recipes = await fetchRecipes(featuredCtg.id);

  return (recipes..shuffle()).first;
});
