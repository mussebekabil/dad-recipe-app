import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/recipes_list.dart';
import 'pages/recipe_form.dart';
import 'pages/category.dart';
import 'providers/navigation.dart';
import 'providers/recipe.dart';

class RecipeApp extends ConsumerWidget {
  const RecipeApp({super.key});
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    RecipeForm(),
    CategoryListScreen(),
    RecipesListScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAD Recipe App'),
        // notificationPredicate: (ScrollNotification notification) {
        //   return notification.depth == 1;
        // },
        // scrolledUnderElevation: 4.0,
        // shadowColor: Theme.of(context).shadowColor,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(recipeFutureProvider);
            await ref.read(recipeFutureProvider.future);
          },
          child: Center(child: _widgetOptions.elementAt(selectedIndex))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ramen_dining),
            label: 'Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_play_list),
            label: 'Recipe list',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blueGrey[800],
        onTap: (int index) =>
            ref.read(selectedIndexProvider.notifier).setSelectedIndex(index),
      ),
    );
  }
}
