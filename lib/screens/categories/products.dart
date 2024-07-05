import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:camilamuebleria/routes/app_routes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:camilamuebleria/models/model_products.dart';
import 'package:camilamuebleria/data/data_products_carousel.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Map<String, dynamic>> record = [];
  List<bool> favorites = [];
  List<bool> carrito = [];

  Future<void> imageformdb() async {
    try {
      String url = "http://192.168.1.74/register_users_api/view_data.php";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          record = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          _loadFavorites();
          _loadCarrito();
        });
      } else {
        // print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    imageformdb();
    super.initState();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites');
    setState(() {
      if (savedFavorites != null) {
        favorites = List<bool>.generate(record.length, (index) {
          return savedFavorites.length > index && savedFavorites[index] == 'true';
        });
      } else {
        favorites = List<bool>.filled(record.length, false);
      }
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', favorites.map((e) => e.toString()).toList());
    List<Map<String, dynamic>> favoriteItems = record
        .asMap()
        .entries
        .where((entry) => favorites[entry.key])
        .map((entry) => entry.value)
        .toList();
    prefs.setString('favoriteItems', jsonEncode(favoriteItems));
  }

  Future<void> _loadCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    String? carritoItemsString = prefs.getString('carritoItems');
    setState(() {
      if (carritoItemsString != null) {
        List<Map<String, dynamic>> carritoItems = List<Map<String, dynamic>>.from(jsonDecode(carritoItemsString));
        carrito = List<bool>.generate(record.length, (index) {
          return carritoItems.any((item) => item["id"] == record[index]["id"]);
        });
      } else {
        carrito = List<bool>.filled(record.length, false);
      }
    });
  }

  Future<void> _saveCarrito(int index) async {
    final prefs = await SharedPreferences.getInstance();

    String? carritoItemsString = prefs.getString('carritoItems');
    List<Map<String, dynamic>> carritoItems = [];
    if (carritoItemsString != null) {
      carritoItems = List<Map<String, dynamic>>.from(jsonDecode(carritoItemsString));
    }

    if (!carrito[index]) {
      carrito[index] = true;
      carritoItems.add(record[index]);
    }

    prefs.setString('carritoItems', jsonEncode(carritoItems));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Añadido al carrito"),
      duration: Duration(seconds: 2),
    ));
  }

  void _toggleFavorite(int index) {
    setState(() {
      favorites[index] = !favorites[index];
      _saveFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Row(
          children: [
            const Spacer(),
            Image.asset(
              'assets/image/camila_logo_bg.png',
              height: 55,
            ),
            const Text('      '),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.favorite);
                  },
                  icon: const Icon(
                    Icons.favorite_outline,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.carrito);
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  )),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: record.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const ImageCarousel(),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: record.length,
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
                                height: 200,
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
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text(record[index]["description"],
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    favorites.length > index && favorites[index]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: favorites.length > index &&
                                            favorites[index]
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    _toggleFavorite(index);
                                  },
                                ),
                                IconButton(
                                    onPressed: () {
                                      _saveCarrito(index); 
                                    },
                                    icon: const Icon(
                                        Icons.shopping_cart_outlined))
                              ],
                            )
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

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carouselImages.length,
      itemBuilder: (context, index, realIndex) {
        return CardImages(carouselImages: carouselImages[index]);
      },
      options: CarouselOptions(
        height: 150,
        autoPlay: false,
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 5),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class CardImages extends StatelessWidget {
  final Imagenes carouselImages;
  const CardImages({super.key, required this.carouselImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {},
          child: FadeInImage(
            placeholder: const AssetImage("assets/loading.gif"),
            image: AssetImage(carouselImages.image),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
