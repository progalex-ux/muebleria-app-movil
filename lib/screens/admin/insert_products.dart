// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:camilamuebleria/routes/app_routes.dart';

class InsertProducts extends StatefulWidget {
  const InsertProducts({super.key});

  @override
  _InsertProductsState createState() => _InsertProductsState();
}

class _InsertProductsState extends State<InsertProducts> {
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  File? imagepath;
  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = ImagePicker();

  Future<void> uploadImage() async {
    try {
      String url = "http://192.168.1.74/register_users_api/insert_products.php";
      var res = await http.post(Uri.parse(url), body: {
        "price": price.text,
        "description": description.text,
        "data": imagedata!,
        "name": imagename!,
      });
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        setState(() {
          price.clear();
          description.clear();
          imagepath = null;
          imagename = null;
          imagedata = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Producto registrado exitosamente"),
          duration: Duration(seconds: 2),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Hubo un problema al registrar el producto"),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<void> getImage() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (getImage != null) {
      setState(() {
        imagepath = File(getImage.path);
        imagename = getImage.path.split('/').last;
        imagedata = base64Encode(imagepath!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar un producto',
          style: TextStyle(color: Colors.white,),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              SizedBox(
                height: 200,
                child: imagepath != null
                    ? Image.file(imagepath!)
                    : const Text('Ninguna imagen seleccionada'),
              ),
              ElevatedButton(
                onPressed: getImage,
                child: const Text('Seleccionar una imagen'),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: price,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingresa un precio',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingresa la descripción',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadImage,
                child: const Text('Registrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.view);
                },
                child: const Text('Ver productos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
