import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/core/carousel_sliders.dart';
import 'package:t_hunt/core/hashtags.dart';
import 'package:t_hunt/models/postmodel.dart';

class PostCard extends ConsumerWidget {
  final Postmodel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(post.uid)).when(
      data: (data) {
        return Card(
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
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                ],
              ),
              post.imageLinks.isNotEmpty
                  ? CarouselSliders(imageLinks: post.imageLinks)
                  : SizedBox.shrink(),
              HashTagText(text: post.caption),
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
