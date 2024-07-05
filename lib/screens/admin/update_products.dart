// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class UpdateProducts extends StatefulWidget {
  final String id;
  final String image;
  final String price;
  final String description;

  const UpdateProducts({
    super.key,
    required this.id,
    required this.image,
    required this.price,
    required this.description,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProductsState createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;

  NumberFormat numberFormat = NumberFormat("#,###");

  @override
  void initState() {
    priceController = TextEditingController(text: widget.price);
    descriptionController = TextEditingController(text: widget.description);
    super.initState();
  }

  Future<void> _uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateRecord() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = "http://192.168.1.74/register_users_api/update_record.php";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['id'] = widget.id;
      request.fields['price'] = priceController.text;
      request.fields['description'] = descriptionController.text;
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == "true") {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to update product"),
            duration: Duration(seconds: 2),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to update. StatusCode: ${response.statusCode}"),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Actualizar Producto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_image != null) ...[
                      SizedBox(
                        height: 150,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: const Text('Seleccionar Imagen'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: 'Precio',
                          filled: true,
                          fillColor: const Color.fromARGB(26, 76, 175, 79),
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onChanged: (value) {
                          String formattedValue = numberFormat.format(int.parse(value.replaceAll(',', '')));
                          priceController.value = TextEditingValue(
                            text: formattedValue,
                            selection: TextSelection.collapsed(offset: formattedValue.length),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Descripción',
                          filled: true,
                          fillColor: const Color.fromARGB(26, 76, 175, 79),
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _updateRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: const Text(
                        'Actualizar',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
