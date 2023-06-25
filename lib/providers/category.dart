import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';

final categoriesFutureProvider =
    FutureProvider<List<Category>>((ref) async => await fetchCategories());
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<Category>> fetchCategories() async {
  final snapshot = await _firestore.collection('category').get();
  return snapshot.docs.map((doc) {
    return Category.fromFirestore(doc.data(), doc.id);
  }).toList();
}

class CategoryNotifier extends StateNotifier<Category?> {
  CategoryNotifier() : super(null) {
    _initialize();
  }

  _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('selectedCtg')) {
      String ctg = prefs.getString('selectedCtg')!;
      state = Category.fromJson(ctg);
    }
  }

  setSelectedCategory(Category? category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (category == null) {
      prefs.clear();
    } else {
      String ctgStr = category.toJson();
      prefs.setString('selectedCtg', ctgStr);
    }

    state = category;
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, Category?>(
    (ref) => CategoryNotifier());

Future<Category> pickRandomCategory() async {
  final categories = await fetchCategories();
  return (categories.toList()..shuffle()).first;
}

final categoryFutureProvider =
    FutureProvider<Category?>((ref) => ref.watch(categoryProvider));
