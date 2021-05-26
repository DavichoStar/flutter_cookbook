import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';

class TabIngredinetsWidget extends StatelessWidget {
  TabIngredinetsWidget(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      children: <Widget>[
        Text(
          recipe.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Text(
          recipe.description,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 25),
        Text(
          'Ingredientes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var ingredinet in recipe.ingredients) _ItemList(ingredinet),
          ],
        ),
      ],
    );
  }
}

class _ItemList extends StatelessWidget {
  _ItemList(this.recipe);
  final String recipe;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: Theme.of(context).accentColor,
        size: 15,
      ),
      title: Text(recipe),
    );
  }
}
