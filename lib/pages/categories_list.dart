import 'package:dad_recipe_app/models/category.dart';
import 'package:dad_recipe_app/utils/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category.dart';
import '../providers/navigation.dart';
import '../utils/string_extension.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);
    final container = MediaQuery.of(context).size;
    final axisCount = container.width < Breakpoints.md
        ? 1
        : container.width < Breakpoints.xl
            ? 2
            : 3;
    return futureCategories.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (categories) {
        return Column(children: <Widget>[
          const SizedBox(height: 20),
          const Text("Categories",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w200,
                  color: Color.fromRGBO(55, 71, 79, 1))),
          const SizedBox(height: 20),
          Expanded(
              child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: axisCount,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Card(
                        margin: const EdgeInsets.all(50.0),
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(categoryProvider.notifier)
                                .setSelectedCategory(category);
                            ref
                                .read(selectedIndexProvider.notifier)
                                .setSelectedIndex(3);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AspectRatio(
                                aspectRatio: 18.0 / 13.0,
                                child: Placeholder(),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 12.0, 16.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 25),
                                    Center(
                                        child: Text(category.name.capitalize(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color.fromRGBO(
                                                    55, 71, 79, 1),
                                                fontWeight: FontWeight.w200)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  }))
        ]);
      },
    );
  }
}
