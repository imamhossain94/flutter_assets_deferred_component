import 'package:flutter/material.dart';

class Images {
  static Future<List<ImageProvider>> load(int page) async {
    List<ImageProvider> images = [];
    for (int i = (page == 1 ? 1 : 29); i <= (page == 1 ? 28 : 56); i++) {
      String imagePath = 'assets/deferred/juz/$page/$i.png';
      images.add(AssetImage(imagePath));
    }
    return images;
  }
}
