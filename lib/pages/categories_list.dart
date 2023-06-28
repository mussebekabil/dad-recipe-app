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
    double sideMargin = container.width < Breakpoints.sm
        ? container.width * 0.05
        : container.width * 0.15;
    final axisCount = container.width < Breakpoints.lg ? 1 : 2;
    return futureCategories.when(
      loading: () => const Center(
          child: SizedBox(
              height: 150, width: 150, child: CircularProgressIndicator())),
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
                  padding: EdgeInsets.fromLTRB(sideMargin, 0, sideMargin, 0),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: axisCount,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    bool evenIndex = index % 2 == 0;
                    double vMargin =
                        container.width <= Breakpoints.sm ? 10.0 : 25;
                    return Card(
                        margin: container.width < Breakpoints.lg
                            ? EdgeInsets.fromLTRB(0, vMargin, 0, vMargin)
                            : EdgeInsets.fromLTRB(evenIndex ? 0 : 25, vMargin,
                                evenIndex ? 25 : 0, vMargin),
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(categoryProvider.notifier)
                                .setSelectedCategory(category);
                            ref
                                .read(selectedIndexProvider.notifier)
                                .setSelectedIndex(2);
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
