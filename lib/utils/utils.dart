import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:stockfolio/keys/api_keys.dart';
import 'package:url_launcher/url_launcher.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(milliseconds: 800),
    ),
  );
}

Future<void> openUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $url');
  }
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context, e.toString());
    }

    if (kDebugMode) {
      print(e);
    }
  }
  return image;
}

Future<http.Response> apiRequest(String url) async {
  try {
    final Uri uri = Uri.parse(url);

    final http.Response response = await http.get(uri);
    return response;
  } catch (e) {
    if (kDebugMode) {
      print('Exception in FMP API - \n$e');
    }
    return http.Response('Try-Catch Error', 999);
  }
}

Future<http.Response> financialModelRequest(String endpoint) async {
  try {
    final Uri uri = Uri.https(
      'financialmodelingprep.com',
      endpoint,
      {'apikey': kFinancialModelingPrepApi},
    );

    final http.Response response = await http.get(uri);
    return response;
  } catch (e) {
    if (kDebugMode) {
      print('Exception in FMP API - \n$e');
    }
    return http.Response('Try-Catch Error', 999);
  }
}
