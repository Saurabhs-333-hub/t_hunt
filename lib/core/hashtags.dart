import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_screen_utils/responsive_screenutil.dart';
import 'package:grock/grock.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/core/emailheader.dart';
import 'package:t_hunt/core/hashtagheader.dart';
import 'package:t_hunt/core/utils.dart';
import 'package:t_hunt/core/websiteheader.dart';
import 'package:t_hunt/models/postmodel.dart';
import 'package:t_hunt/screens/feed/feedcard.dart';
import 'package:url_launcher/url_launcher.dart';

class HashTagText extends ConsumerStatefulWidget {
  final String text;
  final Color textColor;

  HashTagText({required this.text, required this.textColor});

  @override
  ConsumerState<HashTagText> createState() => _HashTagTextState();
}

class _HashTagTextState extends ConsumerState<HashTagText> {
  Future<void> _launchEmail(String url, BuildContext context) async {
    print(url);
    if (await canLaunchUrl(Uri(scheme: 'mailto', path: url))) {
      try {
        await launchUrl(
            mode: LaunchMode.externalApplication,
            Uri(
                scheme: 'mailto',
                path: url,
                queryParameters: {'subject': 'Hi'}));
      } catch (e) {
        print(e);
      }
      // await launchUrl(
      //     mode: LaunchMode.externalApplication,
      //     Uri(scheme: 'mailto', path: url, queryParameters: {'subject': 'Hi'}));
    } else {
      return warningSnackBar(context, "Email! 🥺", "Could Not Email!");
    }
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    print(url);
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(mode: LaunchMode.externalApplication, Uri.parse(url));
    } else {
      return warningSnackBar(context, "Url! 🥺", "Could Not Launch!");
    }
  }

  bool _isValidEmail(String email) {
    // Regular expression for a simple email validation.
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidLink(String link) {
    final linkRegex = RegExp(
        r'^(http:\/\/|https:\/\/|www\.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/\S*)?$');
    return linkRegex.hasMatch(link);
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    defaultSnackBar(context, 'ClipBoard 👋', 'Copied! (Now!, its inside me!)');
    SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    widget.text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: widget.textColor, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showModalBottomSheet(
                  showDragHandle: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return ref.watch(hashtagpostsProvider(element)).when(
                      data: (data) {
                        List<Postmodel> filteredData = data
                            .where((post) =>
                                post.hashtags.any((link) => link == element))
                            .toList();
                        return HashtagHeader(
                            filteredData: filteredData, element: element);
                      },
                      error: (error, stackTrace) {
                        return Text(error.toString());
                      },
                      loading: () {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  },
                  isScrollControlled: true,
                );
              }));
      } else if (element.startsWith('www.')) {
        // Add "http://" to URLs starting with "www." if not already a valid link
        element = "http://$element";
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: widget.textColor, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              _launchUrl(element, context);
                            },
                            child: Text("Visit Website")),
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              showModalBottomSheet(
                                showDragHandle: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return ref
                                      .watch(weblinkpostsProvider(element))
                                      .when(
                                    data: (data) {
                                      List<Postmodel> filteredData = data
                                          .where((post) => post.weblinks
                                              .any((link) => link == element))
                                          .toList();
                                      return WebsiteHeader(
                                          filteredData: filteredData,
                                          element: element);
                                    },
                                    error: (error, stackTrace) {
                                      return Text(error.toString());
                                    },
                                    loading: () {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                },
                                isScrollControlled: true,
                              );
                            },
                            child: Text("View Related Posts"))
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                          isDestructiveAction: true),
                    );
                  },
                );
              }));
      } else if (_isValidLink(element)) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: widget.textColor, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              _launchUrl(element, context);
                            },
                            child: Text("Visit Website")),
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              showModalBottomSheet(
                                showDragHandle: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return ref
                                      .watch(weblinkpostsProvider(element))
                                      .when(
                                    data: (data) {
                                      List<Postmodel> filteredData = data
                                          .where((post) => post.weblinks
                                              .any((link) => link == element))
                                          .toList();
                                      return WebsiteHeader(
                                          filteredData: filteredData,
                                          element: element);
                                    },
                                    error: (error, stackTrace) {
                                      return Text(error.toString());
                                    },
                                    loading: () {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                },
                                isScrollControlled: true,
                              );
                            },
                            child: Text("View Related Posts"))
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                          isDestructiveAction: true),
                    );
                  },
                );
              }));
      } else if (_isValidLink("http://$element") ||
          _isValidLink("https://$element")) {
        // Check if element becomes a link by adding "http://" or "https://"
        element = "http://$element";
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: widget.textColor, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              _launchUrl(element, context);
                            },
                            child: Text("Visit Website")),
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              showModalBottomSheet(
                                showDragHandle: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return ref
                                      .watch(weblinkpostsProvider(element))
                                      .when(
                                    data: (data) {
                                      List<Postmodel> filteredData = data
                                          .where((post) => post.weblinks
                                              .any((link) => link == element))
                                          .toList();
                                      return WebsiteHeader(
                                          filteredData: filteredData,
                                          element: element);
                                    },
                                    error: (error, stackTrace) {
                                      return Text(error.toString());
                                    },
                                    loading: () {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                },
                                isScrollControlled: true,
                              );
                            },
                            child: Text("View Related Posts"))
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                          isDestructiveAction: true),
                    );
                  },
                );
              }));
      } else if (element.startsWith('@')) {
        textSpans.add(TextSpan(
          text: ' $element ',
          style: TextStyle(color: widget.textColor, fontSize: 12),
        ));
      } else if (_isValidEmail(element)) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: widget.textColor, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      title: Text("Options"),
                      message: Text("Select & Go!"),
                      actions: [
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              _launchEmail(element, context);
                            },
                            child: Text("Lets Email!")),
                        CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();

                              showModalBottomSheet(
                                showDragHandle: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return ref
                                      .watch(emailpostsProvider(element))
                                      .when(
                                    data: (data) {
                                      List<Postmodel> filteredData = data
                                          .where((post) => post.emails
                                              .any((link) => link == element))
                                          .toList();
                                      return EmailHeader(
                                          filteredData: filteredData,
                                          element: element);
                                    },
                                    error: (error, stackTrace) {
                                      return Text(error.toString());
                                    },
                                    loading: () {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                },
                                isScrollControlled: true,
                              );
                            },
                            child: Text("View Related Posts"))
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                          isDestructiveAction: true),
                    );
                  },
                );
              }));
      } else {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: Colors.white, fontSize: 12)));
      }
    });
    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          _copyToClipboard(widget.text, context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichReadMoreText(
            settings: LineModeSettings(
                trimLines: 3,
                trimCollapsedText: 'more...',
                trimExpandedText: ' less...',
                onPressReadMore: () {
                  /// specific method to be called on press to show more
                },
                onPressReadLess: () {
                  /// specific method to be called on press to show less
                },
                moreStyle: TextStyle(color: Colors.lightBlue, fontSize: 12),
                lessStyle: TextStyle(color: Colors.lightBlue, fontSize: 12)),
            TextSpan(children: textSpans),
          ),
        ),
      ),
    );
  }
}
