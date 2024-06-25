// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camilamuebleria/routes/app_routes.dart';
import 'package:http/http.dart' as http;
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController mail = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;
  final formKey = GlobalKey<FormState>();

  
  Future<void> insertrecord() async {
  if (user.text.isNotEmpty && mail.text.isNotEmpty && password.text.isNotEmpty) {
    try {
      String uri = "http://192.168.1.74/register_users_api/insert_record.php";
      var res = await http.post(Uri.parse(uri), body: {
        "user": user.text,
        "mail": mail.text,
        "password": password.text
      });

      var response = jsonDecode(res.body);
      if (response["success"]) { 
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario registrado exitosamente")),
        );
        user.text = "";
        mail.text = "";
        password.text = "";
        Navigator.pushNamed(context, AppRoutes.login);
      } else {
        String message = response["message"].toString().toLowerCase();
        String alertMessage = "La contraseña debe contener como mínimo 8 caracteres, 1 mayúscula, 1 número, 1 carácter especial y no debe contener secuencias de números (por ejemplo, 123).";

        if (message.contains("usuario")) {
          alertMessage = "El usuario ya está en uso.";
        } else if (message.contains("correo")) {
          alertMessage = "El correo electrónico ya está en uso / correo invalido";
        } 

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(alertMessage)),
        );
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocurrió un error al procesar la solicitud")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Registro', style: TextStyle(fontSize: 30),),

              const SizedBox(height: 25,),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                  children: [
                
                    TextFormField(
                    validator: (value) {
                      if(value!.isEmpty) {
                        return 'Usuario Obligatorio';
                      }
                      return null;
                    },
                    controller: user,
                    decoration: const InputDecoration(
                      hintText: 'Usuario',
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        )
                      )
                     ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                    validator: (value) {
                      if(value!.isEmpty) {
                        return 'Correo Obligatorio';
                      }
                      return null;
                    },
                    controller: mail,
                    decoration: const InputDecoration(
                      hintText: 'Correo Electronico',
                      icon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        )
                      ),
                     ),
                     keyboardType: TextInputType.emailAddress,
                    ),
                
                    const SizedBox(height: 15,),
                    TextFormField(
                    obscureText: isVisible,
                    validator: (value) {
                      if(value!.isEmpty) {
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
                        )
                      ),
                      suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                      }, icon: Icon(isVisible? Icons.visibility_off : Icons.visibility)),
                     ),
                     keyboardType: TextInputType.text,
                  
                    ),
                
                    const SizedBox(height: 15,),
                
                    Container(
                      width: MediaQuery.of(context).size.width *.4,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                         color: Colors.green
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                              insertrecord();
                            } 
                            },
                
                            
                        child:const Text('Registrar', style: TextStyle(color: Colors.white),)),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Ya tienes una cuenta?'),
                        TextButton(onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child:const Text('Ingresa aqui'))
                      ],
                    )
                
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

