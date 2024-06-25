// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateProducts extends StatefulWidget {
  final String id;
  final String image;
  final String price;
  final String description;

  const UpdateProducts({super.key, 
    required this.id,
    required this.image,
    required this.price,
    required this.description,
  });

  @override
  _UpdateProductsState createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
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
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      // print("Response status code: ${response.statusCode}");
      // print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == "true") {
          // print("Record updated");
          Navigator.pop(context, true); 
        } else {
          // print("Failed to update: ${responseData["error"]}");
        }
      } else {
        // print("Failed to update. StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error: $e");
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
        title: const Text("Actualizar Producto"),
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
                        child: Image.file(_image!, fit: BoxFit.contain,),
                      )
                    ],
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: const Text('Seleccionar Imagen'),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: 'Precio',
                        icon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Descripción',
                        icon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateRecord,
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
