import 'package:dad_recipe_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category.dart';
import '../providers/navigation.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);

    return futureCategories.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (categories) {
        return Expanded(
            child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 1.2),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
                child: InkWell(
              onTap: () {
                ref
                    .read(categoryProvider.notifier)
                    .setSelectedCategory(category);
                ref.read(selectedIndexProvider.notifier).setSelectedIndex(3);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[100],
                child: Column(
                    children: [const Placeholder(), Text(category.name)]),
              ),
            ));
          },
        ));
      },
    );
  }
}
