import 'package:dad_recipe_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe.dart';
import '../utils/breakpoints.dart';
import '../utils/string_extension.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});

  Widget textRenderer(String text,
          {double fontSize = 20.0, lineSpacing = 1.4}) =>
      Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              color: const Color.fromRGBO(55, 71, 79, 1),
              fontSize: fontSize,
              letterSpacing: 1.4,
            )),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Recipe> futureRecipe = ref.watch(featuredRecipeFutureProvider);
    final container = MediaQuery.of(context).size;
    double sideMargin = container.width < Breakpoints.md ? 50 : 100;

    return futureRecipe.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (recipe) {
          return Container(
            padding: EdgeInsets.fromLTRB(sideMargin, 50, sideMargin, 50),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  const Placeholder(),
                  const SizedBox(height: 30),
                  textRenderer(recipe.name.capitalize(), fontSize: 30.0),
                  const SizedBox(height: 30),
                  textRenderer("Ingredients", fontSize: 26.0),
                  const SizedBox(height: 20),
                  textRenderer(recipe.ingredients, lineSpacing: 1),
                  const SizedBox(height: 30),
                  textRenderer("Steps", fontSize: 26.0),
                  const SizedBox(height: 20),
                  textRenderer(recipe.steps, lineSpacing: 1)
                ])),
          );
        });
  }
}
