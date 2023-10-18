import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart' as blurhash;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash_plus/flutter_blurhash.dart';
// import 'package:flutter_blurhash_plus/flutter_blurhash.dart';
import 'package:grock/grock.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/models/postmodel.dart';

class CarouselSliders extends StatefulWidget {
  final Postmodel post;
  const CarouselSliders({super.key, required this.post});

  @override
  State<CarouselSliders> createState() => _CarouselSlidersState();
}

class _CarouselSlidersState extends State<CarouselSliders> {
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
    if (widget.post.imageLinks.length > 1) {
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
      if (_current < widget.post.imageLinks.length) {
        double itemWidth = _current == _current ? 28.0 : 20.0;
        // double maxOffset = (widget.post.imageLinks.length - 1) * (itemWidth + 8);
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
    if (widget.post.imageLinks.isNotEmpty && _isMounted) {
      for (String image in widget.post.imageLinks) {
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
    String? hash;
    generateBlurHash(String imageUrl) async {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final image = img.decodeImage(bytes);

        final blurHash = await blurhash.BlurHash.encode(
          image!,
          numCompX: 4,
          numCompY: 3,
        );
        setState(() {
          hash = blurHash.hash;
        });
        print('blurhash ${blurHash.hash}');
        return blurHash.hash;
      } else {
        throw Exception('Failed to load image');
      }
    }

    // generateBlurHashForCurrentImage();
    // print('hashs $hashs');
    generateBlurHashForCurrentImage() async {
      if (widget.post.imageLinks.isNotEmpty) {
        try {
          hash = await generateBlurHash(widget.post.imageLinks[_current]);
          print(hash);
          setState(() {});
        } catch (error) {
          print('Error generating blur hash: $error');
        }
      }
    }

    

    final color = parseColor('Color(0xff681daa)');
    log(color.toString());
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            CarouselSlider(
                carouselController: _carouselController,
                items: widget.post.imageLinks.map((e) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: widget.post.imageColor.isNotEmpty
                          ? parseColor(widget.post.imageColor[_current])
                          : Colors.black.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: CachedNetworkImage(
                        // cacheKey: UniqueKey().toString(),
                        imageUrl: e,
                        // imageBuilder: (context, imageProvider) =>
                        //     Container(
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: imageProvider,
                        //       fit: BoxFit.contain,
                        //     ),
                        //   ),
                        // ),
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: 1.6,
                          child: hash != null
                              ? BlurHash(
                                  hash: hash != null
                                      ? hash!
                                      : 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                                  // image: e,
                                  color: Colors.black,
                                )
                              : Center(
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                        ),
                        // progressIndicatorBuilder:
                        //     (context, url, downloadProgress) => Center(
                        //   child: SizedBox(
                        //     height: 150,
                        //     width: 150,
                        //     child: CircularProgressIndicator(
                        //       value: downloadProgress.progress,
                        //       strokeWidth: 2,
                        //     ),
                        //   ),
                        // ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  enlargeFactor: 1,
                  // scrollPhysics: BouncingScrollPhysics(
                  //     decelerationRate: ScrollDecelerationRate.fast),
                  pageViewKey: PageStorageKey(widget.post.imageLinks),
                  height: MediaQuery.of(context).size.height * 0.5,
                  onPageChanged: (index, reason) async {
                    setState(() {
                      _current = index;
                    });
                    _scrollToCurrentItem();
                    // await generateBlurHashForCurrentImage();
                  },
                )),
            if (widget.post.imageLinks.length > 1)
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
                          color: widget.post.imageLinks[_current].isNotEmpty
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
                            key: PageStorageKey(widget.post.imageLinks),
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
                                  // key: PageStorageKey(widget.post.imageLinks),
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
                                            widget.post.imageLinks[index],
                                          ),
                                          fit: BoxFit.cover),
                                      color: _current == index
                                          ? const Color.fromARGB(255, 0, 0, 0)
                                          : Color.fromARGB(0, 189, 189, 189)),
                                ),
                              );
                            },
                            itemCount: widget.post.imageLinks.length,
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
      ],
    );
  }
}
