import 'package:dad_recipe_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category.dart';
import '../providers/navigation.dart';
import '../utils/breakpoints.dart';
import './recipe.dart';
import '../utils/string_extension.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  List<Widget> ctgCards(List<Category> categories, WidgetRef ref, container) {
    final featuredCtgs = (categories..shuffle()).take(3);

    return List<Widget>.from(featuredCtgs.map((category) => SizedBox(
        width: container.width < Breakpoints.xl ? 500 : 700,
        child: Card(
            child: InkWell(
          onTap: () {
            ref.read(categoryProvider.notifier).setSelectedCategory(category);
            ref.read(selectedIndexProvider.notifier).setSelectedIndex(3);
          },
          child: ListTile(
            title: Row(children: [
              SizedBox(
                  width: container.width < Breakpoints.xl ? 250 : 300,
                  height: 145,
                  child: const Placeholder()),
              const SizedBox(width: 20),
              Text(category.name.capitalize())
            ]),
            trailing: const Icon(Icons.favorite),
          ),
        )))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);
    final container = MediaQuery.of(context).size;
    double sideMargin = container.width < Breakpoints.md ? 50 : 100;
    return futureCategories.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (categories) {
        return SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Featured categories",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w200,
                    color: Color.fromRGBO(55, 71, 79, 1))),
            const SizedBox(height: 20),
            SizedBox(
                height: 200,
                child: Container(
                    margin: EdgeInsets.fromLTRB(sideMargin, 20, sideMargin, 20),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: ctgCards(categories, ref, container)))),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text("Recipe of the day",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w200,
                    color: Color.fromRGBO(55, 71, 79, 1))),
            const RecipeScreen(),
          ],
        ));
      },
    );
  }
}
