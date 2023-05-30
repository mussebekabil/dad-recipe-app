import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';

// class CategoryNotifier extends StateNotifier<List<Category>> {
//   CategoryNotifier() : super([]) {
//     // _fetchCategories();
//   }

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void _fetchCategories() async {
//     print("fetch cagegory colled");
//     final snapshot = await _firestore.collection('category').get();
//     final categories = snapshot.docs.map((doc) {
//       return Category.fromFirestore(doc.data(), doc.id);
//     }).toList();

//     state = categories;
//   }

//   Future<Category?> pickRandomCategory() async {
//     //if (!state.isEmpty) {
//     //   _fetchCategories();
//     // } else {
//     // if (state.isEmpty) {
//     //   _fetchCategories();
//     // }
//     return state.isEmpty ? null : (state.toList()..shuffle()).first;
//     //}
//     //return null;
//   }
// }

// final categoryProvider =
//     StateNotifierProvider<CategoryNotifier, List<Category>>(
//         (ref) => CategoryNotifier());

final categoriesFutureProvider =
    FutureProvider<List<Category>>((ref) async => await fetchCategories());

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<Category>> fetchCategories() async {
  print("fetch cagegory colled");
  final snapshot = await _firestore.collection('category').get();
  return snapshot.docs.map((doc) {
    return Category.fromFirestore(doc.data(), doc.id);
  }).toList();
}

class CategoryNotifier extends StateNotifier<Category?> {
  CategoryNotifier() : super(null);

  setSelectedCategory(Category category) {
    state = category;
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, Category?>(
    (ref) => CategoryNotifier());

Future<String> pickRandomCategory() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('selectedCtgId')) {
    return prefs.getString('selectedCtgId')!;
  }

  final category = await fetchCategories();
  return (category.toList()..shuffle()).first.id;
}

Future<String> getSelectedCategoryId() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('selectedCtgId')) {
    return prefs.getString('selectedCtgId')!;
  }

  return pickRandomCategory();
}

final categoryFutureProvider = FutureProvider<Category>((ref) async {
  final ctg = ref.watch(categoryProvider);
  if (ctg == null) {
    final category = await fetchCategories();
    final randomCtg = (category.toList()..shuffle()).first;
    ref.watch(categoryProvider.notifier).setSelectedCategory(randomCtg);
    return randomCtg;
  }

  return ctg;
  // final prefs = await SharedPreferences.getInstance();
  // prefs.setString('selectedCtgId', ctgId);
});
