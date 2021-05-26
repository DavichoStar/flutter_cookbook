import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_cookbook/src/services/server_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.context, this._serverController, {Key key}) : super(key: key);
  final BuildContext context;
  final ServerController _serverController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username;
  String password;
  String _errorMessage;

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    widget._serverController.init(widget.context);
  }

  void _login(BuildContext context) async {
    if (!_loading && _formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _loading = true;
        _errorMessage = null;
      });

      User user = await widget._serverController.login(username, password);
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('home', arguments: user);
      } else {
        setState(() {
          _errorMessage = 'Usuario o contraseña incorrecta';
          _loading = false;
        });
      }
    }
  }

  _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed('register');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      //backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.cyan[300], Colors.cyan[800]]),
              ),
              child: Image.asset(
                'assets/logo.png',
                color: Colors.white,
                height: mediaQuery.size.height * 0.15,
              ),
            ),
            Transform.translate(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Usuario:'),
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
                          ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 20),
                              ),
                            ),
                            onPressed: () => _login(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Iniciar Sesión',
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
                                  )
                              ],
                            ),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Text('¿No estas registrado?')),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () => _showRegister(context),
                                child: Text('Registrarse'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
