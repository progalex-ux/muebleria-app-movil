import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:camilamuebleria/routes/app_routes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    if (index >= 0 && index < carritoItems.length) {
      setState(() {
        carritoItems.removeAt(index);
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('carritoItems', jsonEncode(carritoItems));
    }
  }

  double _calculateTotal() {
    double total = 0;
    for (int i = 0; i < carritoItems.length; i++) {
      String priceString =
          carritoItems[i]["price"].toString().replaceAll(',', '');
      double price = double.tryParse(priceString) ?? 0;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();
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
      body: ListView(
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
          carritoItems.isEmpty
              ? const Center(child: Text('No hay productos en el carrito'))
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                                    "http://192.168.1.74/register_users_api/${carritoItems[index]["image_path"]}",
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
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              value: selectedQuantities[index],
                                              onChanged: (int? newValue) {
                                                setState(() {
                                                  selectedQuantities[index] =
                                                      newValue!;
                                                });
                                              },
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                elevation: 1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                              items: <int>[1, 2, 3, 4]
                                                  .map<DropdownMenuItem<int>>(
                                                      (int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                    '$value u.',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    carritoItems[index]["description"],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Text(
                                          'Guardar',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: () {
                                          // Acción al guardar
                                        },
                                      ),
                                      IconButton(
                                        icon: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: () {
                                          _removeFromCarrito(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 107,
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              child: Row(
                children: [
                  const Text(
                    'Total a pagar: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.metodopago);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
          ],
        ),
      ),
    );
  }
}
