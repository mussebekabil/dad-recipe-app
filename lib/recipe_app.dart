import 'package:dad_recipe_app/models/recipe.dart';
import 'package:dad_recipe_app/pages/recipe.dart';
import 'package:dad_recipe_app/providers/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/recipes_list.dart';
import 'pages/recipe_form.dart';
import 'pages/home.dart';
import 'pages/category.dart';
import 'providers/navigation.dart';
import 'providers/recipe.dart';
import 'providers/user.dart';
import 'providers/search.dart';

class RecipeApp extends ConsumerStatefulWidget {
  const RecipeApp({super.key});

  @override
  ConsumerState<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends ConsumerState<RecipeApp> {
  late bool _searchBoolean = false;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    RecipeForm(),
    CategoryListScreen(),
    RecipesListScreen(),
    RecipeScreen()
  ];

  Widget _searchTextField() => TextField(
        onChanged: (String s) =>
            ref.watch(searchProvider.notifier).setSearchKeys(s),
        autofocus: true,
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintText: 'Search recipe by name ...',
          hintStyle: TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    final asyncUser = ref.watch(userProvider);

    return asyncUser.when(data: (user) {
      return Scaffold(
        appBar: AppBar(
          title: !_searchBoolean
              ? const Text('DAD Recipe App')
              : _searchTextField(),
          actions: <Widget>[
            !_searchBoolean
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        ref
                            .read(selectedIndexProvider.notifier)
                            .setSelectedIndex(3);
                        _searchBoolean = true;
                        ref.watch(searchProvider.notifier).setSearchKeys("");
                      });
                    })
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
                        ref.watch(searchProvider.notifier).setSearchKeys("");
                      });
                    }),
            user == null
                ? TextButton(
                    style: style,
                    onPressed: () async {
                      await FirebaseAuth.instance.signInAnonymously();
                    },
                    child: const Text('Login anonymously'),
                  )
                : TextButton(
                    style: style,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Logout'),
                  ),
          ],
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(categoryProvider);
              ref.refresh(categoriesFutureProvider);
              await ref.read(categoriesFutureProvider.future);
              ref.refresh(recipesFutureProvider);
              await ref.read(recipesFutureProvider.future);
            },
            child: Column(children: [
              Expanded(
                child: Center(child: _widgetOptions.elementAt(selectedIndex)),
              ),
              user == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: (() {}),
                      icon: const Icon(Icons.add_circle,
                          semanticLabel: 'Add new recipe',
                          size: 40.0,
                          color: Color.fromRGBO(55, 71, 79, 1))),
              const SizedBox(height: 20)
            ])),
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
          selectedItemColor: Color.fromRGBO(255, 143, 0, 1),
          unselectedItemColor: Color.fromRGBO(55, 71, 79, 1),
          onTap: (int index) =>
              ref.read(selectedIndexProvider.notifier).setSelectedIndex(index),
        ),
      );
    }, error: (error, stackTrace) {
      return const Center(child: Text("Something went wrong.."));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
