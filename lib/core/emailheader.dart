import 'package:flutter/material.dart';
import 'package:responsive_screen_utils/responsive_screenutil.dart';
import 'package:t_hunt/models/postmodel.dart';
import 'package:t_hunt/screens/feed/feedcard.dart';
class EmailHeader extends StatelessWidget {
  const EmailHeader({
    super.key,
    required this.filteredData,
    required this.element,
  });

  final List<Postmodel> filteredData;
  final String element;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: ResponsiveScreenUtil().setHeight(120),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: Offset(0, 10),
                            )
                          ],
                          border:
                              Border.all(color: Colors.black.withOpacity(0.2)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(0, 66, 66, 66),
                              Color.fromARGB(0, 66, 66, 66),
                            ],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ResponsiveScreenUtil().setHeight(28),
                          ),
                          Expanded(
                            child: Center(
                              child: ListTile(
                                title: Text(element),
                                subtitle: Text('${filteredData.length} Posts'),
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: IconButton.outlined(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.email_rounded,
                                    )),
                                tileColor:
                                    const Color.fromARGB(66, 158, 158, 158),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  // physics:
                  //     NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: filteredData[index]);
                  },
                ),
              ),
            ],
          )),
    ));
  }
}
