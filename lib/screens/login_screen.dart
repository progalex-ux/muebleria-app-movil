import 'package:flutter/material.dart';
import 'package:camilamuebleria/routes/app_routes.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;
  final formKey = GlobalKey<FormState>();

  Future<void> iniciarSesion(String correo, String password) async {
    var url = Uri.parse('http://192.168.1.74/register_users_api/login_user.php');
    var response = await http.post(url, body: {
      'mail': correo,
      'password': password,
    });

    if (response.statusCode == 200) {
      String loginResponse = response.body.toLowerCase();
      if (loginResponse == "login exitoso - correo especifico") {
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.insert);
        }
      } else if (loginResponse == "login exitoso") {
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.home);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contraseña o correo incorrecto')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al iniciar sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            const Text('Inicio de sesión', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 25),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Correo Obligatorio';
                        }
                        return null;
                      },
                      controller: mail,
                      decoration: const InputDecoration(
                        hintText: 'Correo Electronico',
                        icon:Icon(Icons.mail),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: isVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Contraseña Obligatoria';
                        }
                        return null;
                      },
                      controller: password,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        icon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * .4,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            iniciarSesion(mail.text, password.text);
                          }
                        },
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Aun no tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: const Text('Registrate'),
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
    );
  }
}
