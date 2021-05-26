import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cookbook/src/componets/util.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/componets/image_picker.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class AddRecipePage extends StatefulWidget {
  AddRecipePage(this._serverController, {this.recipe});
  final ServerController _serverController;
  final Recipe recipe;

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final formKey = GlobalKey<FormState>();
  bool editing = false;

  String name = '';
  String description = '';
  List<String> ingredients = [];
  List<String> steps = [];
  PickedFile photo;

  final ingredientControler = TextEditingController();
  final stepControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
                imageFile: photo,
                onImageSelected: (PickedFile file) {
                  setState(() {
                    photo = file;
                  });
                }),
            SizedBox(
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: 70,
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, mediaQuery.size.height * 0.25),
                child: ListView(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 250),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: name,
                              decoration: InputDecoration(
                                  labelText: 'Nombre de la receta'),
                              onSaved: (value) {
                                this.name = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Este campo es obligatorio';
                                else
                                  return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: description,
                              decoration: InputDecoration(
                                labelText: 'Descripción',
                              ),
                              maxLines: 6,
                              onSaved: (value) {
                                this.description = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Este campo es obligatorio';
                                else
                                  return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ListTile(
                              title: Text('Ingredientes'),
                              trailing: FloatingActionButton(
                                heroTag: 'uno',
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () => _ingredientDialog(context),
                              ),
                            ),
                            SizedBox(height: 20),
                            getIngredients(),
                            SizedBox(height: 20),
                            ListTile(
                              title: Text('Pasos'),
                              trailing: FloatingActionButton(
                                heroTag: 'dos',
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () => _stepDialog(context),
                              ),
                            ),
                            SizedBox(height: 20),
                            getSteps(),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                              onPressed: _onSave,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Guardar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    editing = widget.recipe != null;

    if (editing) {
      name = widget.recipe.name;
      description = widget.recipe.description;
      ingredients = widget.recipe.ingredients;
      steps = widget.recipe.steps;
      photo = PickedFile(widget.recipe.photo.path);
    }
  }

  Future<void> _onSave() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      if (photo == null) {
        showSnacbar(context, 'Seleciona una imágen por favor', Colors.orange);
        return;
      }
      if (ingredients.length == 0) {
        showSnacbar(context, 'No agregaste ingredientes', Colors.orange);
        return;
      }
      if (steps.length == 0) {
        showSnacbar(context, 'No agregaste pasos', Colors.orange);
        return;
      }

      final nRecipe = Recipe(
        name: name,
        description: description,
        ingredients: ingredients,
        steps: steps,
        photo: File(photo.path),
        user: widget._serverController.loggedUser,
        date: editing ? widget.recipe.date : DateTime.now(),
      );

      bool state = false;

      if (editing) {
        nRecipe.id = widget.recipe.id;
        state = await widget._serverController.updateRecipe(nRecipe);
      } else {
        final recipe = await widget._serverController.addRecipe(nRecipe);
        state = recipe != null;
      }

      if (state) {
        Navigator.pop(context, nRecipe);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Receta ${editing ? 'actualizada' : 'guardada'} exitosamente',
              ),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else
        showSnacbar(
            context,
            'No se pudo ${editing ? 'actualizar' : 'guardar'} la receta',
            Colors.orange);
    }
  }

  Widget getIngredients() {
    if (ingredients.length == 0) {
      return Text(
        'Lista vacía',
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: [
          for (var i = 0; i < ingredients.length; i++)
            IngredienttWidget(
                i, ingredients[i], _onIngredientDelete, _onIngredientEdit)
        ],
      );
    }
  }

  _onIngredientDelete(int index) {
    questionDialog(context, '¿Seguro que desea eliminar el ingrediente?', () {
      setState(() {
        ingredients.removeAt(index);
      });
    });
    setState(() {});
  }

  _onIngredientEdit(int index) {
    _ingredientDialog(context, index: index);
  }

  _ingredientDialog(BuildContext context, {int index}) {
    final bool editing = index != null;
    final textController =
        TextEditingController(text: editing ? ingredients[index] : null);

    final _onProcess = () {
      if (textController.text.isEmpty) {
        showSnacbar(context, 'El campo está vacío', Colors.orange);
      } else {
        setState(() {
          if (editing)
            ingredients[index] = textController.text;
          else
            ingredients.add(textController.text);
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            title: Text('${editing ? 'Editando' : 'Agregando'} ingrediente'),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Ingrediente'),
              onEditingComplete: _onProcess,
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(editing ? 'Actualizar' : 'Guardar'),
                onPressed: _onProcess,
              ),
            ],
          );
        });
  }

  Widget getSteps() {
    if (steps.length == 0) {
      return Text(
        'Lista vacía',
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            IngredienttWidget(i, steps[i], _onStepDelete, _onStepEdit)
        ],
      );
    }
  }

  _onStepDelete(int index) {
    questionDialog(context, '¿Seguro que desea eliminar el paso?', () {
      setState(() {
        steps.removeAt(index);
      });
    });
  }

  _onStepEdit(int index) {
    _stepDialog(context, index: index);
  }

  _stepDialog(BuildContext context, {int index}) {
    final bool editing = index != null;
    final textController =
        TextEditingController(text: editing ? steps[index] : null);

    final _onProcess = () {
      print('SI');
      if (textController.text.isEmpty) {
        showSnacbar(context, 'El campo está vacío', Colors.orange);
      } else {
        setState(() {
          if (editing)
            steps[index] = textController.text;
          else
            steps.add(textController.text);
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            title: Text('${editing ? 'Editando' : 'Agregando'} paso'),
            content: TextField(
              maxLines: 6,
              controller: textController,
              decoration: InputDecoration(labelText: 'Paso'),
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(editing ? 'Actualizar' : 'Guardar'),
                onPressed: _onProcess,
              ),
            ],
          );
        });
  }

  questionDialog(BuildContext context, String message, VoidCallback callback) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(15),
            title: Text(message),
            actions: [
              TextButton(
                child: Text('Si'),
                onPressed: () {
                  callback();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}

typedef OnIngredientDeleteCallback = void Function(int index);

class IngredienttWidget extends StatelessWidget {
  IngredienttWidget(this.index, this.ingredientName,
      this.onIngredientDeleteCallback, this.onIngredientEditCallback);
  final int index;
  final String ingredientName;
  final OnIngredientDeleteCallback onIngredientDeleteCallback;
  final OnIngredientDeleteCallback onIngredientEditCallback;

  @override
  Widget build(BuildContext context) {
    Color backgroupColor = Theme.of(context).scaffoldBackgroundColor;

    if ((index % 2) == 1) {
      if (Theme.of(context).brightness == Brightness.dark)
        backgroupColor = Colors.grey[800];
      else
        backgroupColor = Colors.grey[300];
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroupColor,
      ),
      child: ListTile(
          leading: Text(
            '${index + 1}',
            style: TextStyle(fontSize: 16),
          ),
          title: Text(
            ingredientName,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => onIngredientEditCallback(index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onIngredientDeleteCallback(index),
              ),
            ],
          )),
    );
  }
}
