// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camilamuebleria/routes/app_routes.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({super.key});

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  List<Map<String, dynamic>> record = [];

  Future<void> imageformdb() async {
    try {
      String url = "http://192.168.1.74/register_users_api/view_data.php";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          record = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        // print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> deleteProduct(int id) async {
    String deleteUrl =
        "http://192.168.1.74/register_users_api/delete_record.php";
    try {
      var response = await http.post(
        Uri.parse(deleteUrl),
        body: {'id': id.toString()},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado exitosamente'),
              duration: Duration(seconds: 2),
            ),
          );
          imageformdb();
        } else {
          // print("Error al eliminar el producto: ${responseData['message']}");
        }
      } else {
        // print("Error al eliminar el producto. StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error en la conexión: $e");
    }
  }

  @override
  void initState() {
    imageformdb();
    super.initState();
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
        title: const Text('Productos', style: TextStyle(color: Colors.white)),
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
      body: ListView.builder(
        itemCount: record.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: SizedBox(
                      height: 120,
                      width: 100,
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/loading.gif'),
                        image: NetworkImage(
                          "http://192.168.1.74/register_users_api/${record[index]["image_path"]}",
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("\$${record[index]["price"]}",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(record[index]["description"],
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () async {
                          var success = await Navigator.pushNamed(
                            context,
                            AppRoutes.update,
                            arguments: {
                              'id': record[index]["id"].toString(),
                              'image': record[index]["image_path"],
                              'price': record[index]["price"].toString(),
                              'description': record[index]["description"],
                            },
                          );

                          if (success == true) {
                            imageformdb();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Eliminar Producto"),
                              content: const Text(
                                  "¿Estás seguro de eliminar este producto?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    int productId =
                                        int.parse(record[index]["id"]);
                                    deleteProduct(productId);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Eliminar"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
