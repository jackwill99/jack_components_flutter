// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageCollage extends StatelessWidget {
  final List<Widget> children;
  final Function(int index) singleTapFunc;
  final Function(int index) expandTapFunc;

  /// Image Collage
  /// ```
  /// ImageCollage(
  ///   children: urls
  ///       .map((e) => Image.network(
  ///             e,
  ///             fit: BoxFit.cover,
  ///             alignment: Alignment.topCenter,
  ///           ))
  ///       .toList(),
  /// )
  /// ```
  ImageCollage({
    Key? key,
    required this.children,
    required this.singleTapFunc,
    required this.expandTapFunc,
  }) : super(key: key);
  final patterns = [
    {
      "count": 1,
      'axisCount': 6,
      "pattern": [
        [6, 3],
      ]
    },
    {
      "count": 2,
      'axisCount': 6,
      "pattern": [
        [3, 3],
        [3, 3],
      ]
    },
    {
      "count": 3,
      'axisCount': 6,
      "pattern": [
        [3, 6],
        [3, 3],
        [3, 3],
      ]
    },
    {
      "count": 4,
      'axisCount': 6,
      "pattern": [
        [6, 3],
        [2, 2],
        [2, 2],
        [2, 2],
      ]
    },
    {
      "count": 5,
      'axisCount': 6,
      "pattern": [
        [3, 3],
        [3, 3],
        [2, 2],
        [2, 2],
        [2, 2],
      ]
    },

    // {
    //   'axisCount': 4,
    //   'pattern': [
    //     [4, 2],
    //     [1, 1],
    //     [1, 1],
    //     [1, 1],
    //     [1, 1],
    //   ]
    // }
  ];
  final maxImages = 5;

  List<Widget> buildImages() {
    int numImages = children.length;
    return List<Widget>.generate(min(numImages, maxImages), (index) {
      Widget imageItem = children[index];

      // If its the last image
      if (index == maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - maxImages;
        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return singleItem(imageItem, index);
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => expandTapFunc(maxImages - 1),
            child: Stack(
              fit: StackFit.expand,
              children: [
                imageItem,
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '+${remaining + 1}',
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return singleItem(imageItem, index);
      }
    });
  }

  Widget singleItem(Widget imageItem, int index) {
    return GestureDetector(
      child: imageItem,
      onTap: () => singleTapFunc(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StaggeredGrid.count(
        crossAxisCount: 6,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: buildImages()
            .asMap()
            .entries
            .map(
              (element) => StaggeredGridTile.count(
                crossAxisCellCount: (patterns[buildImages().length - 1]
                    ['pattern'] as List<List>)[element.key][0],
                mainAxisCellCount: (patterns[buildImages().length - 1]
                    ['pattern'] as List<List>)[element.key][1],
                child: element.value,
              ),
            )
            .toList(),
      ),
    );
  }
}
