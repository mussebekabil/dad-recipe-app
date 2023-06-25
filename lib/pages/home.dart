import 'package:dad_recipe_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category.dart';
import './recipe.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);
    final container = MediaQuery.of(context).size;
    return futureCategories.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (categories) {
        final featuredCtgs = (categories..shuffle()).take(3);
        final ctgWidgets = List<Widget>.from(featuredCtgs.map((ctg) => SizedBox(
            width: container.width * 0.3,
            child: Card(
                child: ListTile(
              leading: const SizedBox(
                  height: double.infinity, child: Icon(Icons.category)),
              // width: 200,
              //child: Placeholder()), //Icon(Icons.category),
              title: Text(ctg.name),
            )))));
        return Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
                height: 200,
                child: Container(
                    margin: EdgeInsets.fromLTRB(
                        container.width * 0.05, 20, container.width * 0.05, 20),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: ctgWidgets))),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const RecipeScreen(),
          ],
        );
      },
    );
  }
}
