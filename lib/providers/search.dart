import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super("");

  void setSearchKeys(String key) {
    state = key;
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, String>((ref) => SearchNotifier());
