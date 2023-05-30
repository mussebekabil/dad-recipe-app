import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';
import '../models/category.dart';
import '../providers/category.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  // {
  //   _fetchRecipes();
  // }

  // void _fetchRecipes() async {
  //   String categoryId = await pickRandomCategory();
  //   //await ref.watch(c.notifier).pickRandomCategory();
  //   // if (category != null) {
  //   print("in fetch recipe");
  //   //print(category.id);
  //   final snapshot = await _firestore
  //       .collection('category')
  //       .doc(categoryId)
  //       .collection('recipes')
  //       .get();
  //   final recipes = snapshot.docs.map((doc) {
  //     return Recipe.fromFirestore(doc.data(), doc.id);
  //   }).toList();

  //   state = recipes;
  //   // }
  // }

  void setRecipes(List<Recipe> recipes) {
    state = recipes;
  }

  void addRecipe(String name, String ingredients, String steps) async {
    final newRecipe = Recipe('', name, ingredients, steps).toFirestore();

    final noteRef = await _firestore.collection('recipe').add(newRecipe);
    final recipe = Recipe.fromFirestore(newRecipe, noteRef.id);

    state = [...state, recipe];
  }

  void deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
    state = state.where((recipe) => recipe.id != id).toList();
  }
}

final recipesProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>(
    (ref) => RecipeNotifier());

final recipeFutureProvider = FutureProvider<List<Recipe>>((ref) async {
  String categoryId = await getSelectedCategoryId(); //pickRandomCategory();
  Category ctg = await ref.watch(categoryFutureProvider.future);
  //await ref.watch(c.notifier).pickRandomCategory();
  // if (category != null) {
  print("in fetch recipe $categoryId and ${ctg.id}");
  //print(category.id);

  final snapshot = await _firestore
      .collection('category')
      .doc(ctg.id)
      .collection('recipes')
      .get();
  final recipes = snapshot.docs.map((doc) {
    return Recipe.fromFirestore(doc.data(), doc.id);
  }).toList();

  ref.watch(recipesProvider.notifier).setRecipes(recipes);
  print(recipes.length);
  return recipes;

  //  ctg.when(data: ((data) async {
  //   final snapshot = await _firestore
  //       .collection('category')
  //       .doc(data.id)
  //       .collection('recipes')
  //       .get();
  //   final recipes = snapshot.docs.map((doc) {
  //     return Recipe.fromFirestore(doc.data(), doc.id);
  //   }).toList();

  //   ref.watch(recipesProvider.notifier).setRecepies(recipes);
  //   print(recipes.length);
  //   //return recipes;
  // }));
});
