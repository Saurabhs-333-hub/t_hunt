import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedStoryView extends StatelessWidget {
  final int index;
  FeedStoryView({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      child: Stack(
        children: [
          Expanded(
            child: CarouselSlider.builder(
                itemCount: 10,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Text(
                          index.toString(),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      color: Color.fromARGB(0, 54, 54, 54),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  enlargeFactor: 1,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  viewportFraction: 1,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                // Spacer(),
                index == 0
                    ? Flexible(
                        child: ListTile(
                            title: Text("Your Story"),
                            subtitle: Text("Add to your story")),
                      )
                    : Flexible(
                        child: ListTile(
                            title: Text('user $index'),
                            subtitle: Text("Add to your story")),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
