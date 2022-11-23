// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ImagePositionedList extends StatelessWidget {
  final List<Widget> children;
  final ItemScrollController itemScrollController;

  /// Image Positioned List
  /// ```
  /// final ItemScrollController itemScrollController  = ItemScrollController();
  /// ImagePositionedList(
  ///   itemScrollController: itemScrollController,
  ///   children: [
  ///     Container(
  ///       margin: const EdgeInsets.only(
  ///         bottom: 10,
  ///       ),
  ///       color: Colors.red,
  ///       height: 40,
  ///       child: Text('Item $index')
  ///     ),
  ///   ]
  /// );
  /// ```
  ImagePositionedList({
    Key? key,
    required this.children,
    required this.itemScrollController,
  }) : super(key: key);

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              child: ScrollablePositionedList.builder(
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          )),
        ],
      ),
    );
  }
}
