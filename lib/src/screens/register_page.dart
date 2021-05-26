import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cookbook/src/componets/util.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/componets/image_picker.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage(this.context, this._serverController, {Key key, this.userToEdit})
      : super(key: key);
  final BuildContext context;
  final ServerController _serverController;
  final User userToEdit;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username;
  String password;
  Genrer genrer = Genrer.MALE;

  bool showPassword = false;
  bool editingUser = false;

  PickedFile imageFile;

  @override
  void initState() {
    super.initState();
    editingUser = (widget.userToEdit != null);

    if (editingUser) {
      username = widget.userToEdit.nickname;
      password = widget.userToEdit.password;
      genrer = widget.userToEdit.genrer;
      imageFile = PickedFile(widget.userToEdit.photo.path);
    }
  }

  void _doProcess(BuildContext context) async {
    if (!_loading && _formKey.currentState.validate()) {
      if (imageFile == null) {
        showSnacbar(context, 'Seleciona una imágen por favor', Colors.orange);
        return;
      }

      _formKey.currentState.save();
      setState(() {
        _loading = true;
      });

      User user = User(
          genrer: this.genrer,
          nickname: this.username,
          password: this.password,
          photo: File(this.imageFile.path));
      bool state;

      if (editingUser) {
        user.id = widget.userToEdit.id;
        state = await widget._serverController.updateUser(user);
      } else
        state = await widget._serverController.addUser(user);

      if (state == false) {
        setState(() {
          _loading = false;
        });
        showSnacbar(
            context,
            'No se pudo ${editingUser ? 'actualizar' : 'registrar'} el usuario',
            Colors.orange);
      } else {
        setState(() {
          _loading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Información'),
              content: Text(
                editingUser
                    ? 'Se actualizó tus datos exitosamente'
                    : 'Te has registrado exitosamente',
              ),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            ImagePickerWidget(
                imageFile: imageFile,
                onImageSelected: (PickedFile file) {
                  setState(() {
                    imageFile = file;
                  });
                }),
            SizedBox(
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: 50,
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
                              initialValue: username,
                              decoration:
                                  InputDecoration(labelText: 'Usuario:'),
                              onSaved: (value) {
                                username = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Este campo es obligatorio';
                                else
                                  return null;
                              },
                            ),
                            SizedBox(height: 40),
                            TextFormField(
                              initialValue: password,
                              decoration: InputDecoration(
                                labelText: 'Contraseña:',
                                suffixIcon: IconButton(
                                  icon: Icon(!showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () => setState(
                                      () => showPassword = !showPassword),
                                ),
                              ),
                              obscureText: !showPassword,
                              onSaved: (value) {
                                password = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Este campo es obligatorio';
                                else
                                  return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Género',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RadioListTile(
                                        value: Genrer.MALE,
                                        title: Text('Masculino'),
                                        groupValue: genrer,
                                        onChanged: (value) =>
                                            setState(() => genrer = value),
                                      ),
                                      RadioListTile(
                                        value: Genrer.FEMALE,
                                        title: Text('Femenino'),
                                        groupValue: genrer,
                                        onChanged: (value) =>
                                            setState(() => genrer = value),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(accentColor: Colors.white),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 20),
                                  ),
                                ),
                                onPressed: () => _doProcess(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      editingUser
                                          ? 'Actualizar'
                                          : 'Registrarse',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    if (_loading)
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: const EdgeInsets.only(left: 20),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
