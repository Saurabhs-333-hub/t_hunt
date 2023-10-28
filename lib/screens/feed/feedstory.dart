import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/models/usermodel.dart';
import 'package:t_hunt/screens/feed/feedstoryview.dart';

class FeedStory extends StatelessWidget {
  const FeedStory({
    super.key,
    required this.currentUser,
  });

  final AsyncValue<Usermodel?> currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text("T-Hunt",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
            ],
          ),
          Flexible(
            child: ListView.builder(
                physics: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {},
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Options"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: TextButton.icon(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.add),
                                                      label: Text("Add Story",
                                                          style: TextStyle(
                                                              // color: Colors.blue,
                                                              fontSize: 20))),
                                                ),
                                                Flexible(
                                                  child: TextButton.icon(
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          useSafeArea: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return FeedStoryView(
                                                                index: index);
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                          Icons.view_agenda),
                                                      label: Text("View Story",
                                                          style: TextStyle(
                                                              // color: Colors.blue,
                                                              fontSize: 20))),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                  isDestructiveAction: true,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel")),
                                            ],
                                          );
                                        });
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedContainer(
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeInOut,
                                            child: CircleAvatar(
                                              maxRadius: 50,
                                            )),
                                        IconButton.outlined(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add_circle,
                                              color: Colors.white,
                                              size: 30,
                                            ))
                                      ]),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(child: Text("You")),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {},
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Options"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: TextButton.icon(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.add),
                                                      label: Text("Add Story",
                                                          style: TextStyle(
                                                              // color: Colors.blue,
                                                              fontSize: 20))),
                                                ),
                                                Flexible(
                                                  child: TextButton.icon(
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          useSafeArea: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return FeedStoryView(
                                                                index: index);
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                          Icons.view_agenda),
                                                      label: Text("View Story",
                                                          style: TextStyle(
                                                              // color: Colors.blue,
                                                              fontSize: 20))),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                  isDestructiveAction: true,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel")),
                                            ],
                                          );
                                        });
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedContainer(
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeInOut,
                                            child: CircleAvatar(
                                              maxRadius: 50,
                                            )),
                                      ]),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(child: Text("user $index")),
                              ),
                            ],
                          ),
                        );
                }),
          ),
        ],
      ),
    );
  }
}
