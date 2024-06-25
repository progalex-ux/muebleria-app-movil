import 'package:camilamuebleria/data/data_image_carousel.dart';
import 'package:camilamuebleria/routes/app_routes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:camilamuebleria/models/model_image_carousel.dart';
import 'package:camilamuebleria/data/data_categories.dart';
import 'package:camilamuebleria/models/model_categories.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 233, 232, 232),
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          
          automaticallyImplyLeading: false,
          centerTitle: false,
          
          title: Row(
            children: [
              const Text('         '),
              const Spacer(),
              Image.asset(
                'assets/image/camila_logo_bg.png',
                height: 55, 
              ),
              const Spacer(),
              SizedBox(
                width: 55,
                child: IconButton(onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                }, icon:const Icon(Icons.exit_to_app, color: Colors.lightGreen,)
                )
              // child: CupertinoSearchTextField(
              //     placeholder: 'Search',
              //   ),
              ),
              
              
            ],
          ),
        ),
    
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(),
            const SizedBox(height: 20),
            const ImageCarousel(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Categorias',
                style: GoogleFonts.abel(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const IconTextCarousel(),
            const SizedBox(height: 20,),
            const CardRow(),
            const SizedBox(height: 20,),
          ],
        ),
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
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class IconTextCarousel extends StatelessWidget {
  const IconTextCarousel({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: CarouselSlider.builder(
        itemCount: iconTextCarouselItems.length,
        itemBuilder: (context, index, realIndex) {
          return GestureDetector(
            onTap: () {
              String route = _getRoute(index);
              if (route.isNotEmpty) {
                Navigator.pushNamed(context, route);
              }
            },
            child: IconTextItem(
              model: iconTextCarouselItems[index],
            ),
          );
        },
        options: CarouselOptions(
          height: 70,
          aspectRatio: 4 / 2,
          viewportFraction: 0.33,
          initialPage: 1,
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: true,
        ),
      ),
    );
  }

  String _getRoute(int index) {
    switch (index) {
      case 0:
        // return AppRoutes.recamarasScreen;
      case 1:
        // return AppRoutes.salasScreen;
      case 2:
        return AppRoutes.cocinasScreen;
      case 3:
        // return AppRoutes.lineaBlanca;
      case 4:
        // return AppRoutes.electronicaScreen;
      case 5:
        // return AppRoutes.motosScreen;
      default:
        return '';
    }
  }
}

class IconTextItem extends StatelessWidget {
  final IconTextItemModel model;

  const IconTextItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 80,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            model.icon,
            color: Colors.white70,
            size: 25,
          ),
          const SizedBox(height: 2),
          Text(
            model.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


class CardRow extends StatelessWidget {
  const CardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
            child: CardProductos(imageSuperior: 'assets/card/iphone_icon.png', title: '\$4999', description: 'Iphone 11 64gb Color negro',), 
            ),
            SizedBox(width: 8),
            Expanded(
              child: CardProductos(imageSuperior: 'assets/card/laptop_icon.png', title: '\$8,999', description: 'Laptop HP Ryzen 3 5450u 16gb ram 256ssd',),
            ),   
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CardProductos(imageSuperior: 'assets/card/television_icon.png', title: '\$6,999', description: "Smart TV LG 42'Pulgadas ",), 
            ),
            SizedBox(width: 8),
            Expanded(
              child: CardProductos(imageSuperior: 'assets/card/refrigerador_icon.png', title: '\$12,999', description: 'Refrigerador Samsung Duplex',),
            ),
      
          ],
        ),
       ],
      )
    );
  }
}



class CardProductos extends StatelessWidget {
  final String imageSuperior;
  final String title;
  final String description;

  const CardProductos({
    super.key,
    required this.imageSuperior,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color:Colors.white,
      child: Container(
        padding: const EdgeInsets.all(0.0),
        height: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.maxFinite,
              height: 175,
              decoration: BoxDecoration(
                borderRadius:const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage(imageSuperior),
                  fit: BoxFit.contain,
                  
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
