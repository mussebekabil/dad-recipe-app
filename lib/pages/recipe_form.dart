import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe.dart';
import '../providers/category.dart';
import '../models/category.dart';
import '../utils/breakpoints.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecipeForm extends ConsumerStatefulWidget {
  const RecipeForm({super.key});

  @override
  ConsumerState<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeData {
  String? ctgId;
  String name = '';
  String ingredients = '';
  String steps = '';

  void reset() {
    name = '';
    ingredients = '';
    steps = '';
  }
}

class _RecipeFormState extends ConsumerState<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _RecipeData _data = _RecipeData();

  void submit() {
    // First validate form.
    if (_data.ctgId == null ||
        _data.name == '' ||
        _data.ingredients == '' ||
        _data.steps == '') {
      Fluttertoast.showToast(
          msg: 'Please fill all the required fields!',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          webBgColor: "linear-gradient(to right, #FF0000, #FB9782)",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

      ref
          .watch(recipesProvider.notifier)
          .addRecipe(_data.ctgId!, _data.name, _data.ingredients, _data.steps);
      _data.reset();
      _formKey.currentState!.reset();
      Fluttertoast.showToast(
          msg: 'Recipe created successfully!',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          textColor: Colors.white);
    }
  }

  updatedSelectedCtg(String ctgId) {
    setState(() {
      _data.ctgId = ctgId;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    AsyncValue<List<Category>> futureCategories =
        ref.watch(categoriesFutureProvider);
    final container = MediaQuery.of(context).size;
    double sideMargin = container.width < Breakpoints.md
        ? container.width * 0.05
        : container.width * 0.15;

    return futureCategories.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (categories) {
          return Container(
            padding: EdgeInsets.fromLTRB(sideMargin, 50, sideMargin, 50),
            child: Column(children: [
              const Text("Create recipe",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                      color: Color.fromRGBO(55, 71, 79, 1))),
              const SizedBox(height: 20),
              Expanded(
                  child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: _data.ctgId,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Category'),
                      onChanged: (String? value) {
                        updatedSelectedCtg(value!);
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((Category ctg) {
                        return DropdownMenuItem<String>(
                          value: ctg.id,
                          child: Text(ctg.name),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: 'Best hamburger ever', labelText: 'Name'),
                        onChanged: (String? value) {
                          _data.name = value!;
                        }),
                    TextFormField(
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration:
                            const InputDecoration(labelText: 'Ingredients'),
                        onChanged: (String? value) {
                          _data.ingredients = value!;
                        }),
                    TextFormField(
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(labelText: 'Steps'),
                        onChanged: (String? value) {
                          _data.steps = value!;
                        }),
                    Container(
                      width: screenSize.width,
                      margin: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: submit,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: const Text('Create recipe',
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                  fontSize: 20,
                                ))),
                      ),
                    )
                  ],
                ),
              ))
            ]),
          );
        });
  }
}
