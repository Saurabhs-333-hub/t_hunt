import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_screen_utils/responsive_screenutil.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/models/usermodel.dart';
import 'package:t_hunt/screens/feed/feedcard.dart';
import 'package:t_hunt/screens/feed/feedstory.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider);

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.black,
        body: NestedScrollView(
          // physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FeedStory(currentUser: currentUser),
                // backgroundColor: Color.fromARGB(47, 255, 255, 255),
                elevation: 1,
              ),
            ];
          },
          body: Container(
            height: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ref.watch(postsProvider).when(
                        data: (data) {
                          return MasonryGridView.builder(
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  // Text(currentUser.value!.email),
                                  PostCard(post: data[index],),
                                ],
                              );
                            },
                            itemCount: data.length,
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
                        loading: () => Scaffold(
                            body: Center(child: CircularProgressIndicator()))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
