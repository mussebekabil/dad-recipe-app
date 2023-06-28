import 'package:dad_recipe_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe.dart';
import '../utils/breakpoints.dart';
import '../utils/string_extension.dart';
import 'recipe.dart';

class FeaturedRecipeScreen extends ConsumerWidget {
  const FeaturedRecipeScreen({super.key});

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
    double sideMargin = container.width < Breakpoints.md
        ? container.width * 0.05
        : container.width * 0.15;
    return futureRecipe.when(
        loading: () => const Center(
            child: SizedBox(
                height: 150, width: 150, child: CircularProgressIndicator())),
        error: (err, stack) => Text('Error: $err'),
        data: (recipe) {
          return Container(
              padding: EdgeInsets.fromLTRB(sideMargin, 50, sideMargin, 50),
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeScreen(recipe, true)));
                  },
                  child: Column(children: [
                    const Placeholder(),
                    const SizedBox(height: 50),
                    Text(recipe.name.capitalize(),
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w200,
                            color: Color.fromRGBO(55, 71, 79, 1))),
                    const SizedBox(height: 20),
                  ]),
                ),
              ));
        });
  }
}
