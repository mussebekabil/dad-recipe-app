import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

class NavigationNotifier extends StateNotifier<int> {
  final SharedPreferences prefs;
  NavigationNotifier(this.prefs) : super(0) {
    _initialize();
  }

  _initialize() {
    state = prefs.getInt('selectedIndex') ?? 0;
  }

  setSelectedIndex(int newIndex) {
    state = newIndex;
    prefs.setInt('selectedIndex', newIndex);
  }
}

final selectedIndexProvider = StateNotifierProvider<NavigationNotifier, int>(
    (ref) => NavigationNotifier(ref.watch(sharedPreferencesProvider)));
