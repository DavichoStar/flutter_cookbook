import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/componets/recipe_widget.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class RecipesPage extends StatefulWidget {
  RecipesPage(this._serverController);
  final ServerController _serverController;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Recetas'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget._serverController.getUserRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;

            if (list.length == 0)
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info, size: 120),
                      Text(
                        'No se ha encontrado recetas en su biblioteca, puede agregarlas desde la pantalla principal.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            else
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Recipe recipe = list[index];

                  return RecipeWidget(
                    recipe: recipe,
                    serverController: widget._serverController,
                    onChange: () => setState(() {}),
                  );
                },
              );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
