import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return CarouselState();
  }
}

class CarouselState extends State<Carousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // List<AppSlider> appslider = [];
  List<dynamic> appslider = [
    {
      "img": "assets/img/WowMeIcon.png",
    },
    {
      "img": "assets/img/Banner.png",
    }
  ];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // final appsliders = Provider.of<AppSliderList>(context).allSlider;
    // setState(() {
    //   appslider = appsliders;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = appslider
        .map(
          (item) => InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    item['img'],
                    // "http://192.168.89.130/access/webroot/img/zds.png",
                    fit: BoxFit.cover,
                    width: 347,
                    height: 185,
                  ),
                  // item.imageText != null
                  //     ? Positioned(
                  //         bottom: 0.0,
                  //         left: 0.0,
                  //         right: 0.0,
                  //         child: Container(
                  //           decoration: const BoxDecoration(
                  //             gradient: LinearGradient(
                  //               colors: [
                  //                 Color.fromARGB(200, 0, 0, 0),
                  //                 Color.fromARGB(0, 0, 0, 0)
                  //               ],
                  //               begin: Alignment.bottomCenter,
                  //               end: Alignment.topCenter,
                  //             ),
                  //           ),
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 10.0, horizontal: 10.0),
                  //           child: Text(
                  //             item.imageText!,
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 20.0,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : const Text(""),
                ],
              ),
            ),
          ),
        )
        .toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            // aspectRatio: 2.5,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: appslider.asMap().entries.map((entry) {
        //       return Flexible(
        //         child: GestureDetector(
        //           onTap: () => _controller.animateToPage(entry.key),
        //           child: Container(
        //             width: 12.0,
        //             height: 12.0,
        //             margin: const EdgeInsets.symmetric(
        //                 vertical: 0, horizontal: 4.0),
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: (Theme.of(context).brightness == Brightness.dark
        //                         ? Colors.white
        //                         : Colors.black)
        //                     .withOpacity(_current == entry.key ? 0.9 : 0.4)),
        //           ),
        //         ),
        //       );
        //     }).toList(),
        //   ),
        // ),
      ],
    );
  }
}
