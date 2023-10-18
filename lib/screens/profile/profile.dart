import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grock/grock.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:t_hunt/controllers/post_controller.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Profile>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
    fetchproducts();
  }

  Future<Object> fetchproducts() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse(
          "https://api.unsplash.com/photos/?client_id=LUS9d7Koy2yhqQJWI4dJm2Wzm_qPCRZ32_y2_JH2zQM");
      var response = await http.get(
        url,
      );
      print(response.body);
      var res = jsonDecode(response.body);
      // List<Map<String, dynamic>> products =
      //     List<Map<String, dynamic>>.from(res);
      // print(products);
      return response.body;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF242424),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  backgroundColor: const Color.fromARGB(0, 76, 175, 79),
                  expandedHeight: 600,
                  floating: true,
                  // snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: Image.network(
                            "https://images.unsplash.com/photo-1695726594598-3cc937112d7d?ixid=M3w1MTUzNjZ8MHwxfHJhbmRvbXx8fHx8fHx8fDE2OTcyNDE3NTd8&ixlib=rb-4.0.3",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 450,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(0, 255, 255, 255),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 70,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 450,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFF2C2C2C),
                                        Color.fromARGB(255, 45, 45, 45),
                                        Color(0xFF242424)
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 28,
                                child: FilledButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        minimumSize: Size(100, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)))),
                              ),
                              Positioned(
                                right: 10,
                                top: 28,
                                child: FilledButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        minimumSize: Size(100, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)))),
                              ),
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                    "https://images.unsplash.com/photo-1695241263069-f8eb9e43f3b3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjAzNjl8MHwxfHJhbmRvbXx8fHx8fHx8fDE2OTcyNDUxNzl8&ixlib=rb-4.0.3&q=80&w=1080"),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ];
          },
          body: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: Container(
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF242424), Color(0x000D1220)],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.50,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Colors.white.withOpacity(0.25),
                  ),
                  // borderRadius: BorderRadius.circular(48),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C1B2440),
                    blurRadius: 38,
                    offset: Offset(0, -14),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF111111), Color(0xFF111111)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: TabBar(
                          isScrollable: true,
                          dividerColor: Colors.transparent,
                          splashBorderRadius: BorderRadius.circular(30),
                          // controller: _tabController,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.transparent),
                          // isScrollable: true,
                          labelColor: Colors.white,
                          padding: EdgeInsets.all(8),
                          tabs: [
                            Tab(
                                icon: Icon(
                              Icons.grid_view,
                              // size: 30,
                            )),
                            Tab(
                                icon: Icon(
                              Icons.list,
                              // size: 30,
                            )),
                          ]),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    // controller: _tabController,
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        child: ref.watch(postsProvider).when(
                              data: (data) {
                                if (data.isNotEmpty) {
                                  return MasonryGridView.builder(
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              double aspectRatio = 0.6;
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => ImagePage(
                                                  data: data,
                                                  initialIndex: index,
                                                  aspectRatio: aspectRatio,
                                                ),
                                              ));
                                            },
                                            child: Hero(
                                              tag: data[index].postid,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Stack(
                                                    children: [
                                                      if (data[index]
                                                              .imageLinks
                                                              .isNotEmpty &&
                                                          data[index]
                                                                  .imageLinks
                                                                  .length >
                                                              1) ...{
                                                        Image.network(
                                                          data[index]
                                                              .imageLinks[0],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      } else if (data[index]
                                                              .imageLinks
                                                              .isNotEmpty &&
                                                          data[index]
                                                                  .imageLinks
                                                                  .length <
                                                              2) ...{
                                                        Image.network(
                                                          data[index]
                                                              .imageLinks[0],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      } else ...{
                                                        Text(
                                                            data[index].caption,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      }
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Center(
                                    child: Text("No Posts"),
                                  );
                                }
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: Text(error.toString()),
                                );
                              },
                              loading: () {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              skipLoadingOnRefresh: true,
                              skipLoadingOnReload: true,
                            ),
                      ),
                      Container(
                        child: ref.watch(postsProvider).when(
                              data: (data) {
                                if (data.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              double aspectRatio = 0.6;
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => ImagePage(
                                                  data: data,
                                                  initialIndex: index,
                                                  aspectRatio: aspectRatio,
                                                ),
                                              ));
                                            },
                                            child: Hero(
                                              tag: data[index].postid,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Stack(
                                                    children: [
                                                      if (data[index]
                                                              .imageLinks
                                                              .isNotEmpty &&
                                                          data[index]
                                                                  .imageLinks
                                                                  .length >
                                                              1) ...{
                                                        Image.network(
                                                          data[index]
                                                              .imageLinks[0],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      } else if (data[index]
                                                              .imageLinks
                                                              .isNotEmpty &&
                                                          data[index]
                                                                  .imageLinks
                                                                  .length <
                                                              2) ...{
                                                        Image.network(
                                                          data[index]
                                                              .imageLinks[0],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      } else ...{
                                                        Text(
                                                            data[index].caption,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      }
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Center(
                                    child: Text("No Posts"),
                                  );
                                }
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: Text(error.toString()),
                                );
                              },
                              loading: () {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              skipLoadingOnRefresh: true,
                              skipLoadingOnReload: true,
                            ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final data;
  final int initialIndex;
  final double aspectRatio; // Aspect ratio of the clicked image

  ImagePage(
      {required this.data,
      required this.initialIndex,
      required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    double totalHeight = 0.0;

    for (int i = 0; i < initialIndex; i++) {
      // Calculate total height of previous items based on aspect ratio
      double itemHeight = MediaQuery.of(context).size.width / aspectRatio;
      totalHeight += itemHeight;
    }

    ScrollController _scrollController =
        ScrollController(initialScrollOffset: totalHeight);

    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: Text(data[initialIndex].caption),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) => Hero(
              tag: data[index].postid,
              child: Container(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Column(
                    children: [
                      if (data[index].imageLinks.isNotEmpty) ...{
                        Image.network(
                          data[index].imageLinks[0],
                          fit: BoxFit.contain,
                        ),
                      },
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data[index].caption,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Add to Cart"),
                      ),
                      Expanded(child: Text(data[index].postid))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
