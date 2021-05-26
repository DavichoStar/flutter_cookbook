import 'package:flutter/material.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class MyDrawer extends StatelessWidget {
  final ServerController _serverController;

  const MyDrawer(this._serverController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://www.setaswall.com/wp-content/uploads/2017/06/Material-Backgrounds-07-2048-x-1197.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              _serverController.loggedUser.nickname,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: FileImage(_serverController.loggedUser.photo),
            ),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('register',
                  arguments: _serverController.loggedUser);
            },
          ),
          ListTile(
            title: Text(
              'Mis Recetas',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.book,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('recipes');
            },
          ),
          ListTile(
            title: Text(
              'Favoritos',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('favorites');
            },
          ),
          ListTile(
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).accentColor,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }
}
