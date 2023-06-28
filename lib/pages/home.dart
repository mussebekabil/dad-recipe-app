import 'package:dad_recipe_app/models/category.dart';
import 'package:dad_recipe_app/pages/featured_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
import '../providers/category.dart';
import '../providers/navigation.dart';
import '../providers/recipe.dart';
import '../utils/breakpoints.dart';
import './recipe.dart';
import '../utils/string_extension.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  List<Widget> ctgCards(List<Category> categories, WidgetRef ref, container) {
    final featuredCtgs = (categories..shuffle()).take(3);

    return List<Widget>.from(featuredCtgs.map((category) => SizedBox(
        width: container.width < Breakpoints.xl ? 450 : 700,
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Card(
                child: InkWell(
              onTap: () {
                ref
                    .read(categoryProvider.notifier)
                    .setSelectedCategory(category);
                ref.read(selectedIndexProvider.notifier).setSelectedIndex(2);
              },
              child: ListTile(
                mouseCursor: MouseCursor.defer,
                contentPadding: const EdgeInsets.all(0),
                title: Row(children: [
                  SizedBox(
                      width: container.width < Breakpoints.xl ? 250 : 300,
                      height: 245,
                      child: const Placeholder()),
                  const SizedBox(width: 20),
                  Text(category.name.capitalize())
                ]),
              ),
            ))))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);
    final container = MediaQuery.of(context).size;
    double sideMargin = container.width < Breakpoints.md
        ? container.width * 0.05
        : container.width * 0.15;

    return futureCategories.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => Text('Error: $err'),
      data: (categories) {
        return SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 50),
            const Text("Featured categories",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w200,
                    color: Color.fromRGBO(55, 71, 79, 1))),
            const SizedBox(height: 20),
            SizedBox(
                height: 300,
                child: Container(
                    margin: EdgeInsets.fromLTRB(sideMargin, 20, sideMargin, 20),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: ctgCards(categories, ref, container)))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  ref.read(selectedIndexProvider.notifier).setSelectedIndex(1),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text('See all categories',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 20,
                      ))),
            ),
            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 50),
            const Text("Recipe of the day",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w200,
                    color: Color.fromRGBO(55, 71, 79, 1))),
            const FeaturedRecipeScreen()
          ],
        ));
      },
    );
  }
}
