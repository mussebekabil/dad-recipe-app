import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe.dart';

class RecipeForm extends ConsumerStatefulWidget {
  const RecipeForm({super.key});

  @override
  ConsumerState<RecipeForm> createState() => _RecipeState();
}

class _RecipeData {
  String name = '';
  String ingredients = '';
  String steps = '';

  void reset() {
    name = '';
    ingredients = '';
    steps = '';
  }
}

class _RecipeState extends ConsumerState<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _RecipeData _data = _RecipeData();

  void submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

      ref
          .watch(recipesProvider.notifier)
          .addRecipe(_data.name, _data.ingredients, _data.steps);
      _data.reset();
      _formKey.currentState!.reset();
      //print('Printing the login data.  ${_data}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: 'Best hamburger ever', labelText: 'Name'),
                onSaved: (String? value) {
                  _data.name = value!;
                }),
            TextFormField(
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Ingredients'),
                onSaved: (String? value) {
                  _data.ingredients = value!;
                }),
            TextFormField(
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Steps'),
                onSaved: (String? value) {
                  _data.steps = value!;
                }),
            Container(
              width: screenSize.width,
              margin: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: submit,
                child: const Text(
                  'Create recipe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
