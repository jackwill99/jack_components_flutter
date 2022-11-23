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
      "img": "assets/img/WowMeIcon.png",
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
                  Image.asset(item['img'],
                      // "http://192.168.89.130/access/webroot/img/zds.png",
                      fit: BoxFit.cover,
                      width: 1000.0),
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
      ],
    );
  }
}
