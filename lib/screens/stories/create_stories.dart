import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:grock/grock.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/screens/clips/ads_page.dart';
import 'package:t_hunt/screens/home/home.dart';

class CreateStories extends ConsumerStatefulWidget {
  const CreateStories({super.key});

  @override
  ConsumerState<CreateStories> createState() => _CreateStoriesState();
}

class _CreateStoriesState extends ConsumerState<CreateStories> {
  List<File> file = [];
  final captionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
        images: file, caption: captionController.text.trim(), context: context);
  }

  void onPickFiles() async {
    file = await pickFiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController editableTextController = TextEditingController();
    final currentUser = ref.watch(currentUserDetailsProvider);
    bool isLoading = ref.watch(postControllerProvider);
    return currentUser.when(
      data: (data) {
        if (isLoading || data == null) {
          return Scaffold(
            body: Center(child: Grock.loadingPopup()),
          );
        }
        return Scaffold(
          // backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          drawer: ZoomDrawer(
              menuScreenTapClose: true,
              shrinkMainScreen: true,
              menuScreen: CreateStories(),
              mainScreen: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.ads_click_rounded)),
                ),
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1695241263069-f8eb9e43f3b3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjAzNjl8MHwxfHJhbmRvbXx8fHx8fHx8fDE2OTcyNDUxNzl8&ixlib=rb-4.0.3&q=80&w=1080"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("I am posting...",
                            style: TextStyle(
                                color: Color.fromARGB(158, 255, 255, 255),
                                fontSize: 20)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(107, 3, 3, 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: captionController,
                          decoration: InputDecoration(border: InputBorder.none),
                          autocorrect: true,
                          enableSuggestions: true,
                          enableIMEPersonalizedLearning: true,
                          maxLines: 6,
                          restorationId: captionController.text,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            onPickFiles();
                          },
                          child: Icon(Icons.photo_library, color: Colors.white),
                        ),
                      ),
                      TextButton.icon(
                          onPressed: () {
                            sharePost();
                          },
                          icon: Icon(Icons.keyboard_double_arrow_up_rounded),
                          label: Text("Post")),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(Icons.info_rounded,
                          color: Color.fromARGB(255, 255, 208, 0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Please add http:// or https:// before writing your link",
                        style: TextStyle(
                            color: const Color.fromARGB(157, 255, 255, 255),
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if (file.isNotEmpty) ...{
                  Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: file.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () => showModalBottomSheet(
                                            showDragHandle: true,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                InteractiveViewer(
                                              onInteractionUpdate: (details) {
                                                print(details.rotation);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            file[index]))),
                                              ),
                                            ),
                                          ),
                                      child: Image.file(file[index])),
                                );
                              },
                            ),
                          ),
                          file.isNotEmpty
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      file = [];
                                    });
                                  },
                                  child: file.length > 1
                                      ? Text("Clear all ${file.length} images")
                                      : Text("Clear image"))
                              : Container(),
                        ],
                      ),
                    ),
                  ))
                },

                // IconButton.outlined(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //           MaterialPageRoute(builder: (context) => AdsPage()));
                //     },
                //     icon: Icon(Icons.ads_click_rounded))
              ],
            ),
          ),
        );
      },
      error: (e, st) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.toString()),
            ),
          ),
        );
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
