import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:camilamuebleria/routes/app_routes.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteItems();
  }

  Future<void> _loadFavoriteItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? favoriteItemsString = prefs.getString('favoriteItems');
    if (favoriteItemsString != null) {
      setState(() {
        favoriteItems = List<Map<String, dynamic>>.from(jsonDecode(favoriteItemsString));
      });
    }
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
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Favoritos',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          favoriteItems.isEmpty
              ? const Center(child: Text('No hay productos en favorito '))
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: favoriteItems.length,
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
                                  placeholder: const AssetImage('assets/loading.gif'),
                                  image: NetworkImage(
                                    "http://192.168.1.74/register_users_api/${favoriteItems[index]["image_path"]}",
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
                                  Text(
                                    "\$${favoriteItems[index]["price"]}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    favoriteItems[index]["description"],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(onPressed: () {}, child:const Text('Eliminar')),
                                      TextButton(onPressed: () {}, child:const Text('Agregar al carrito'))
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
        ],
      ),
    );
  }
}
