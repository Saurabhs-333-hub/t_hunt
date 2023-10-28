import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/models/postmodel.dart';

class FeedStoryView extends ConsumerStatefulWidget {
  final Postmodel story;
  FeedStoryView({
    required this.story,
    super.key,
  });
  @override
  ConsumerState<FeedStoryView> createState() => _FeedStoryViewState();
}

class _FeedStoryViewState extends ConsumerState<FeedStoryView> {
  int _current = 0;
  CarouselController _carouselController = CarouselController();
  List<PaletteColor> dycolors = [];
  int _index = 0;
  bool _isMounted = false;
  ScrollController? _scrollController;
  String? hashs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dycolors = [];
    _index = 0;
    _isMounted = true;
    if (widget.story.imageLinks.length > 1) {
      _scrollController = ScrollController();
    }
    // addColors();
    // print('hash $hash');

    // hashs = hash;
    // print('hashss $hashs');

    // _scrollToCurrentItem();
    // generateBlurHashForCurrentImage();
    // Grock.checkInternet(onConnect: () {
    //   return successSnackBar(context, 'Good to Go!', 'You are Online!');
    // }, onDisconnect: () {
    //   return warningSnackBar(
    //       context, 'Check your Network!', 'You are Offline!');
    // });
  }

  void _scrollToCurrentItem() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_current < widget.story.imageLinks.length) {
        double itemWidth = _current == _current ? 28.0 : 20.0;
        // double maxOffset = (widget.story.imageLinks.length - 1) * (itemWidth + 8);
        double offset = (_current * (itemWidth + 8)) -
            (MediaQuery.of(context).size.width / 3.6) +
            (itemWidth / 2);

        // Ensure offset doesn't go below 0 or beyond the maximum allowed offset
        // offset = offset.clamp(0.0, maxOffset);

        _scrollController?.animateTo(
          offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false; // Set the flag to false when the widget is disposed
    super.dispose();
    _scrollController?.dispose();
  }

  void addColors() async {
    if (widget.story.imageLinks.isNotEmpty && _isMounted) {
      for (String image in widget.story.imageLinks) {
        print('dycolors: $dycolors');

        if (image.isNotEmpty && _isMounted) {
          final PaletteGenerator paletteGenerator =
              await PaletteGenerator.fromImageProvider(NetworkImage(image),

                  // size: Size(100, 100),
                  timeout: Duration(seconds: 0));

          paletteGenerator.dominantColor == null
              ? dycolors.add(PaletteColor(Colors.black, 1))
              : dycolors.add(paletteGenerator.dominantColor!);
          // print('dycolors: $dycolors');
          // setState(() {});
        }
      }
      // await generateBlurHashForCurrentImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      child: Column(
        children: [
          Flexible(
            child: Stack(
              children: [
                CarouselSlider.builder(
                    itemCount: widget.story.imageLinks.length > 0
                        ? widget.story.imageLinks.length
                        : 1,
                    itemBuilder: (context, index, realIndex) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          color: widget.story.imageColor.isNotEmpty
                              ? parseColor(widget.story.imageColor[index])
                              : Color.fromARGB(0, 54, 54, 54),
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: widget.story.imageLinks.length > 0
                                ? Image.network(
                                    widget.story.imageLinks[index],
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  )
                                : Text(
                                    widget.story.caption,
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                          ),
                          // color: Color.fromARGB(0, 54, 54, 54),
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
                      autoPlayInterval: Duration(milliseconds: 800),
                    )),
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
                      widget.story.uid ==
                              ref.watch(currentUserProvider).value!.$id
                          ? Flexible(
                              child: ListTile(
                                  title: Text("Your Story"),
                                  subtitle: Text("Add to your story")),
                            )
                          : Flexible(
                              child: ListTile(
                                  title: Text('${widget.story.uid}'),
                                  subtitle: Text("Add to your story")),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.story.imageLinks.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      _carouselController.previousPage();
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.story.imageLinks[_current].isNotEmpty
                            ? _current >= 0 && _current < dycolors.length
                                ? dycolors[_current].color
                                : Colors.black.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: Center(
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          key: PageStorageKey(widget.story.imageLinks),
                          // physics: BouncingScrollPhysics(
                          //     decelerationRate: ScrollDecelerationRate.fast),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _carouselController.animateToPage(index);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                // key: PageStorageKey(widget.story.imageLinks),
                                width: _current == index ? 28 : 20,
                                height: _current == index ? 28 : 20,
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        color: Colors.white,
                                        width: 1),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.story.imageLinks[index],
                                        ),
                                        fit: BoxFit.cover),
                                    color: _current == index
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : Color.fromARGB(0, 189, 189, 189)),
                              ),
                            );
                          },
                          itemCount: widget.story.imageLinks.length,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _carouselController.nextPage();
                    },
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}
