// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:camilamuebleria/routes/app_routes.dart';
import 'package:intl/intl.dart';

class InsertProducts extends StatefulWidget {
  const InsertProducts({super.key});

  @override
  _InsertProductsState createState() => _InsertProductsState();
}

class _InsertProductsState extends State<InsertProducts> {
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  NumberFormat numberFormat = NumberFormat("#,###");

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

  void onTabTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.insert);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.view);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agrega un producto',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              SizedBox(
                height: 180,
                child:
                    imagepath != null ? Image.file(imagepath!) : const Text(''),
              ),
              ElevatedButton(
                onPressed: getImage,
                child: const Text('Seleccionar una imagen'),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: price,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'Ingresa un precio',
                    filled: true,
                    fillColor: const Color.fromARGB(26, 76, 175, 79),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onChanged: (value) {
                    String formattedValue = numberFormat
                        .format(int.parse(value.replaceAll(',', '')));
                    price.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset: formattedValue.length),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                    hintText: 'Ingresa la descripcion',
                    filled: true,
                    fillColor: const Color.fromARGB(26, 76, 175, 79),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Agregar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        elevation: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Insertar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Ver',
          ),
        ],
      ),
    );
  }
}
