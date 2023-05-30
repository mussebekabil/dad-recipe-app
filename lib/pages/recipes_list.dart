import 'package:dad_recipe_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe.dart';

class RecipesListScreen extends ConsumerWidget {
  const RecipesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final recipes = ref.watch(recipeProvider);
    // print(recipes.length);
    //ref.refresh(recipeFutureProvider);
    AsyncValue<List<Recipe>> futureRecipes = ref.watch(recipeFutureProvider);

    return futureRecipes.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (recipes) {
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                child: ListTile(
                  title: Text(recipe.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref
                        .watch(recipesProvider.notifier)
                        .deleteRecipe(recipe.id),
                  ),
                ),
              );
            },
          );
        });
  }
}
