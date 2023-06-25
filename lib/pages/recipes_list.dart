import 'package:dad_recipe_app/models/recipe.dart';
import 'package:dad_recipe_app/providers/search.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/category.dart';
import '../providers/recipe.dart';

class RecipesListScreen extends ConsumerStatefulWidget {
  const RecipesListScreen({super.key});

  @override
  ConsumerState<RecipesListScreen> createState() => _RecipesListState();
}

class _RecipesListState extends ConsumerState<RecipesListScreen> {
  String selectedCtgId = "";

  List<DropdownMenuItem<String>> _dropdownOptions(List<Category> categories) {
    const emptyOption = DropdownMenuItem<String>(
      value: "",
      child: Text("All"),
    );
    final ctgOptions = categories.map<DropdownMenuItem<String>>((Category ctg) {
      return DropdownMenuItem<String>(
        value: ctg.id,
        child: Text(ctg.name),
      );
    }).toList();
    ctgOptions.insert(0, emptyOption);

    return ctgOptions;
  }

  Widget _categorySelector(List<Category> categories) {
    return DropdownButtonFormField<String>(
      value: selectedCtgId,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Category'),
      onChanged: (String? value) {
        Category? selectedCtg =
            categories.firstWhereOrNull((ctg) => ctg.id == value!);
        ref.watch(categoryProvider.notifier).setSelectedCategory(selectedCtg);
      },
      items: _dropdownOptions(categories),
    );
  }

  Widget _recipesList(List<Recipe> recipes) {
    String filter = ref.watch(searchProvider);
    List<Recipe> filteredRecipes = recipes
        .where((r) => r.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];
        return Card(
          child: ListTile(
            title: Text(recipe.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  ref.watch(recipesProvider.notifier).deleteRecipe(recipe.id),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);
    AsyncValue<List<Recipe>> futureRecipes = ref.watch(recipesFutureProvider);

    return futureCategories.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (categories) {
          final ctg = ref.read(categoryProvider);
          selectedCtgId = ctg == null ? "" : ctg.id;
          return futureRecipes.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (recipes) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                        height: 150,
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                            child: _categorySelector(categories))),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                            child: _recipesList(recipes))),
                  ],
                );
              });
        });
  }
}
