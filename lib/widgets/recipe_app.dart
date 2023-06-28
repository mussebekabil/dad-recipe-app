import 'package:dad_recipe_app/pages/recipe.dart';
import 'package:dad_recipe_app/providers/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/recipes_list.dart';
import '../pages/recipe_form.dart';
import '../pages/home.dart';
import '../pages/categories_list.dart';
import '../providers/navigation.dart';
import '../providers/recipe.dart';
import '../providers/user.dart';
import '../providers/search.dart';

class RecipeApp extends ConsumerStatefulWidget {
  const RecipeApp({super.key});

  @override
  ConsumerState<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends ConsumerState<RecipeApp> {
  late bool _searchBoolean = false;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
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

  List<BottomNavigationBarItem> getBottomItems(User? user) {
    if (user != null) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ramen_dining),
          label: 'Recipe list',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Add recipe',
        )
      ];
    }

    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category),
        label: 'Category',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.ramen_dining),
        label: 'Recipe list',
      ),
    ];
  }

  Stack getBodyContent(User? user) {
    if (user != null) {
      return Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          _buildOffstageNavigator(3),
        ],
      );
    }
    return Stack(
      children: [
        _buildOffstageNavigator(0),
        _buildOffstageNavigator(1),
        _buildOffstageNavigator(2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    final asyncUser = ref.watch(userProvider);
    if (selectedIndex != 2) {
      ref.read(categoryProvider.notifier).setSelectedCategory(null);
      setState(() {
        _searchBoolean = false;
      });
    }
    return asyncUser.when(data: (user) {
      return WillPopScope(
          onWillPop: () async {
            final isFirstRouteInCurrentTab =
                !await _navigatorKeys[selectedIndex].currentState!.maybePop();

            // let system handle back button if we're on the first route
            return isFirstRouteInCurrentTab;
          },
          child: Scaffold(
            appBar: AppBar(
              title: !_searchBoolean
                  ? const Text('DAD Recipe App',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 24,
                      ))
                  : _searchTextField(),
              actions: <Widget>[
                !_searchBoolean
                    ? IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          ref
                              .read(selectedIndexProvider.notifier)
                              .setSelectedIndex(2);
                          ref.watch(searchProvider.notifier).setSearchKeys("");
                          setState(() {
                            _searchBoolean = true;
                          });
                        })
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.watch(searchProvider.notifier).setSearchKeys("");
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
                        child: const Text('Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                              fontSize: 20,
                            )),
                      )
                    : TextButton(
                        style: style,
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                              fontSize: 20,
                            )),
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
                child: Stack(
                  children: [
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                    _buildOffstageNavigator(2),
                    _buildOffstageNavigator(3),
                  ],
                )),
            bottomNavigationBar: BottomNavigationBar(
                items: getBottomItems(user),
                currentIndex: selectedIndex > 3 ? 0 : selectedIndex,
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: const Color.fromRGBO(55, 71, 79, 1),
                onTap: (int index) => ref
                    .read(selectedIndexProvider.notifier)
                    .setSelectedIndex(index)),
          ));
    }, error: (error, stackTrace) {
      return const Center(child: Text("Something went wrong.."));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return const [
          HomeScreen(),
          CategoryListScreen(),
          RecipesListScreen(),
          RecipeForm(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Offstage(
      offstage: selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
