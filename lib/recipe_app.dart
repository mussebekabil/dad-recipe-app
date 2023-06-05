import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/recipes_list.dart';
import 'pages/recipe_form.dart';
import 'pages/category.dart';
import 'providers/navigation.dart';
import 'providers/recipe.dart';
import 'providers/user.dart';

class RecipeApp extends ConsumerStatefulWidget {
  const RecipeApp({super.key});

  @override
  ConsumerState<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends ConsumerState<RecipeApp> {
  bool _searchBoolean = false;

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

  Widget _searchTextField() {
    return const TextField(
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
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
  }

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
                        _searchBoolean = true;
                        //_searchIndexList = [];
                      });
                    })
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
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
    }, error: (error, stackTrace) {
      return const Center(child: Text("Something went wrong.."));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
