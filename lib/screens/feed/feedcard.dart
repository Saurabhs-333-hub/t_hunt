import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grock/grock.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/core/carousel_sliders.dart';
import 'package:t_hunt/core/hashtags.dart';
import 'package:t_hunt/models/postmodel.dart';

class PostCard extends ConsumerStatefulWidget {
  final Postmodel post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    deletePost() {
      ref
          .read(postControllerProvider.notifier)
          .deletePost(post: widget.post, context: context);
    }

    return ref.watch(userDetailsProvider(widget.post.uid)).when(
      data: (data) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  widget.post.imageLinks.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.post.imageLinks[0]),
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
              } else ...[
                widget.post.imageLinks.isNotEmpty
                    ? CarouselSliders(post: widget.post)
                    : SizedBox.shrink(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(),
                    ),
                    HashTagText(
                        text: widget.post.caption, textColor: Colors.lightBlue),
                  ],
                )
              ],
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
