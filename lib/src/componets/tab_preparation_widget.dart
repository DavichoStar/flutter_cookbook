import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';

class TabPreparationWidget extends StatelessWidget {
  TabPreparationWidget(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < recipe.steps.length; i++)
              _ItemList(recipe.steps[i], i),
          ],
        ),
      ],
    );
  }
}

class _ItemList extends StatelessWidget {
  _ItemList(this.recipe, this.index);
  final String recipe;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${index + 1}',
        style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25),
      ),
      title: Text(recipe),
    );
  }
}
