import 'package:dad_recipe_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Recipe> futureRecipe = ref.watch(featuredRecipeFutureProvider);

    return futureRecipe.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (recipe) {
          return Container(
            padding: const EdgeInsets.all(50),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  const Placeholder(),
                  const SizedBox(height: 10),
                  Text(recipe.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 32.0,
                        letterSpacing: 1.2,
                      )),
                  const SizedBox(height: 10),
                  Text(recipe.ingredients),
                  Text(recipe.steps)
                ])),
          );
        });
  }
}
