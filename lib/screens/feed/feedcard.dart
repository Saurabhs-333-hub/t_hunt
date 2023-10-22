import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grock/grock.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/core/carousel_sliders.dart';
import 'package:t_hunt/core/hashtags.dart';
import 'package:t_hunt/models/postmodel.dart';

class PostCard extends ConsumerWidget {
  final Postmodel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(postControllerProvider);
    deletePost() {
      ref
          .read(postControllerProvider.notifier)
          .deletePost(post: post, context: context);
    }

    return ref.watch(userDetailsProvider(post.uid)).when(
      data: (data) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  post.imageLinks.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(post.imageLinks[0]),
                        )
                      : SizedBox.shrink(),
                  Expanded(child: Text(data.email)),
                  IconButton(
                      onPressed: () {
                        Grock.dialog(
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Post"),
                              content: Text("Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      deletePost();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete"))
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.more_vert))
                ],
              ),
              if (isLoading) ...{
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Deleting Post..."),
                    )
                  ],
                )),
              } else ...{
                post.imageLinks.isNotEmpty
                    ? CarouselSliders(post: post)
                    : SizedBox.shrink(),
                HashTagText(
                    text: post.caption,
                    textColor: Color.fromARGB(255, 0, 13, 255)),
              },
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return Text("Loading");
      },
    );
  }
}
