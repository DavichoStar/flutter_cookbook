import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/componets/tab_ingredients_widget.dart';
import 'package:flutter_cookbook/src/componets/tab_preparation_widget.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage(this.recipe, this._serverController);
  Recipe recipe;
  final ServerController _serverController;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool favorite;

  @override
  void initState() {
    super.initState();
    loadState();
  }

  void loadState() async {
    final state = await widget._serverController.getIsFavorite(widget.recipe);
    setState(() {
      favorite = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(widget.recipe.name),
                expandedHeight: 320,
                pinned: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(widget.recipe.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                bottom: TabBar(
                  labelColor: Colors.white,
                  indicatorWeight: 4,
                  tabs: [
                    Tab(
                      child: Text(
                        'Ingredientes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Preparación',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (widget._serverController.loggedUser.id ==
                      widget.recipe.user.id)
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final nRecipe = await Navigator.pushNamed(
                              context, 'edit_recipe',
                              arguments: widget.recipe);
                          setState(() {
                            widget.recipe = nRecipe;
                          });
                        }),
                  if (widget._serverController.loggedUser.id !=
                      widget.recipe.user.id)
                    getFavoriteWidget(),
                  IconButton(
                      icon: Icon(Icons.help),
                      onPressed: () {
                        _showAboutIt(context);
                      }),
                ],
              )
            ];
          },
          body: TabBarView(
            children: [
              TabIngredinetsWidget(widget.recipe),
              TabPreparationWidget(widget.recipe),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFavoriteWidget() {
    if (favorite != null) {
      if (favorite)
        return IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () async {
              await widget._serverController.deleteFavorite(widget.recipe);
              setState(() {
                favorite = false;
              });
            });
      else
        return IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () async {
              await widget._serverController.addFavorite(widget.recipe);
              setState(() {
                favorite = true;
              });
            });
    } else
      return Container(
        margin: EdgeInsets.all(15),
        child: SizedBox(
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
  }

  void _showAboutIt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acerca de la Receta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Nombre: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(widget.recipe.name),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Usuario: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(widget.recipe.user.nickname),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Fecha de publicación: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${widget.recipe.date.day}/${widget.recipe.date.month}/${widget.recipe.date.year}',
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
