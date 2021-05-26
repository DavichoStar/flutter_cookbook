import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/screens/add_recipe_page.dart';
import 'package:flutter_cookbook/src/screens/details_page.dart';
import 'package:flutter_cookbook/src/screens/home_page.dart';
import 'package:flutter_cookbook/src/screens/login_page.dart';
import 'package:flutter_cookbook/src/screens/recipes_page.dart';
import 'package:flutter_cookbook/src/screens/register_page.dart';
import 'package:flutter_cookbook/src/screens/favorites_page.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.cyan,
        accentColor: Colors.cyan[300],
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        accentColor: Colors.cyan[300],
      ),
      themeMode: ThemeMode.system,
      initialRoute: 'login',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) {
            switch (settings.name) {
              case 'login':
                _serverController.loggedUser = null;
                return LoginPage(context, _serverController);
              case 'register':
                User userLogged = settings.arguments;
                return RegisterPage(
                  context,
                  _serverController,
                  userToEdit: userLogged,
                );
              case 'home':
                User userLogged = settings.arguments;
                _serverController.loggedUser = userLogged;
                return HomePage(_serverController);
              case 'favorites':
                return FavoritesPage(_serverController);
              case 'recipes':
                return RecipesPage(_serverController);
              case 'details':
                Recipe recipe = settings.arguments;
                return DetailsPage(recipe, _serverController);
              case 'add_recipe':
                return AddRecipePage(_serverController);
              case 'edit_recipe':
                Recipe recipe = settings.arguments;
                return AddRecipePage(_serverController, recipe: recipe);
              default:
                return LoginPage(context, _serverController);
            }
          },
        );
      },
    );
  }
}
