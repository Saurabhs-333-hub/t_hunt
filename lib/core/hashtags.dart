import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:t_hunt/core/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HashTagText extends StatelessWidget {
  final String text;

  HashTagText({required this.text});
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
    defaultSnackBar(context, 'ClipBoard 👋', 'Now!, its inside me! (Copied!)');
    SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(
            TextSpan(text: ' $element ', style: TextStyle(color: Colors.blue)));
      } else if (element.startsWith('www.')) {
        // Add "http://" to URLs starting with "www." if not already a valid link
        element = "http://$element";
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(element, context);
              }));
      } else if (_isValidLink(element)) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: Colors.blue),
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
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(element, context);
              }));
      } else if (element.startsWith('@')) {
        textSpans.add(TextSpan(
          text: ' $element ',
          style: TextStyle(color: Colors.blue),
        ));
      } else if (_isValidEmail(element)) {
        textSpans.add(TextSpan(
            text: ' $element ',
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchEmail(element, context);
              }));
      } else {
        textSpans.add(TextSpan(text: ' $element '));
      }
    });
    return GestureDetector(
      onLongPress: () {
        _copyToClipboard('', context);
      },
      child: RichText(
        text: TextSpan(children: textSpans),
      ),
    );
  }
}
