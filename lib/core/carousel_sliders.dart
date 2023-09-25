import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliders extends StatefulWidget {
  final List imageLinks;
  const CarouselSliders({super.key, required this.imageLinks});

  @override
  State<CarouselSliders> createState() => _CarouselSlidersState();
}

class _CarouselSlidersState extends State<CarouselSliders> {
  int _current = 0;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            CarouselSlider(
                carouselController: carouselController,
                items: widget.imageLinks.map((e) => Image.network(e)).toList(),
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                )),
            if (widget.imageLinks.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        carouselController.previousPage();
                      },
                      icon: Icon(Icons.arrow_back_ios_new)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    carouselController.animateToPage(index);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: _current == index ? 28 : 20,
                                  height: _current == index ? 28 : 20,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              widget.imageLinks[index]),
                                          fit: BoxFit.cover),
                                      color: _current == index
                                          ? Colors.blue
                                          : Colors.grey.shade400),
                                ),
                              );
                            },
                            itemCount: widget.imageLinks.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        carouselController.nextPage();
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                ],
              )
            else
              SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
