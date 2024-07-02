import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:camilamuebleria/routes/app_routes.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  List<Map<String, dynamic>> carritoItems = [];
  List<int> selectedQuantities = [];

  @override
  void initState() {
    _loadCarritoItems();
    super.initState();
  }

  Future<void> _loadCarritoItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? carritoItemsString = prefs.getString('carritoItems');
    if (carritoItemsString != null && carritoItemsString.isNotEmpty) {
      setState(() {
        carritoItems =
            List<Map<String, dynamic>>.from(jsonDecode(carritoItemsString));
        selectedQuantities = List<int>.filled(carritoItems.length, 1);
      });
    }
  }

  Future<void> _removeFromCarrito(int index) async {
    setState(() {
      carritoItems.removeAt(index);
      selectedQuantities.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('carritoItems', jsonEncode(carritoItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.productos);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Row(
          children: [
            const Text('         '),
            const Spacer(),
            Image.asset(
              'assets/image/camila_logo_bg.png',
              height: 55,
            ),
            const Spacer(),
            const Text('                   ')
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Carrito de compras',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: carritoItems.isEmpty
                ? const Center(child: Text('No hay productos en el carrito'))
                : ListView.builder(
                    itemCount: carritoItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
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
                                    placeholder:
                                        const AssetImage('assets/loading.gif'),
                                    image: NetworkImage(
                                      "http://192.168.1.70/register_users_api/${carritoItems[index]["image_path"]}",
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
                                    Row(
                                      children: [
                                        Text(
                                            "\$${carritoItems[index]["price"]}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: DropdownButton<int>(
                                            value: selectedQuantities[index],
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                selectedQuantities[index] =
                                                    newValue!;
                                              });
                                            },
                                            
                                            items: <int>[
                                              1,
                                              2,
                                              3,
                                            ].map<DropdownMenuItem<int>>(
                                                (int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text('$value u.'),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(carritoItems[index]["description"],
                                        style: const TextStyle(fontSize: 14)),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Text(
                                            'guardar',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          onPressed: () {
                                            // Acción al guardar
                                          },
                                        ),
                                        IconButton(
                                          icon: const Text(
                                            'eliminar',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          onPressed: () {
                                            _removeFromCarrito(index);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: TextButton(
            onPressed: () {

            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
              ),
            ),
            child: const Text(
              'Continuar compra',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
