import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/core/utils.dart';
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
            style: TextStyle(color: widget.textColor, fontSize: 16),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(ModalBottomSheetRoute(
                    builder: (context) {
                      return ref.watch(hashtagpostsProvider(element)).when(
                        data: (data) {
                          return SafeArea(
                            child: Scaffold(
                                appBar: AppBar(
                                  title: Text(element),
                                ),
                                body: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text('data[index].caption'),
                                    );
                                  },
                                )),
                          );
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
                    showDragHandle: true));
              }));
      } else if (element.startsWith('www,.')) {
        // Add "http://" to URLs starting with "www." if not already a valid link
        element = "http://$element";
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(
              color: widget.textColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(element, context);
              }));
      } else if (_isValidLink(element)) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(
              color: widget.textColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(element, context);
              }));
      } else if (_isValidLink("http://$element") ||
          _isValidLink("https://$element")) {
        // Check if element becomes a link by adding "http://" or "https://"
        element = "http://$element";
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(
              color: widget.textColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(element, context);
              }));
      } else if (element.startsWith('@')) {
        textSpans.add(TextSpan(
          text: ' $element ',
          style: TextStyle(
            color: widget.textColor,
          ),
        ));
      } else if (_isValidEmail(element)) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(
              color: widget.textColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchEmail(element, context);
              }));
      } else {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: Colors.white, fontSize: 16)));
      }
    });
    return GestureDetector(
      onLongPress: () {
        _copyToClipboard(widget.text, context);
      },
      child: RichText(
        text: TextSpan(children: textSpans),
      ),
    );
  }
}
