import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/componets/my_drawer.dart';
import 'package:flutter_cookbook/src/componets/recipe_widget.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class HomePage extends StatefulWidget {
  HomePage(this._serverController);
  final ServerController _serverController;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cookbook'),
      ),
      drawer: MyDrawer(widget._serverController),
      body: FutureBuilder<List<Recipe>>(
        future: widget._serverController.getRecipesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pushNamed(context, 'add_recipe'),
      ),
    );
  }
}
