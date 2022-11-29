// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JackImageCollectionView extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final int position;

  ///
  /// * Children like that
  ///```
  /// widget.post.images.map((e) {
  ///   return Center(
  ///     child: Image.network(e.image),
  ///   );
  /// }).toList()
  /// ```
  ///
  /// * To show up the widget
  ///
  ///```
  /// showCupertinoModalBottomSheet(
  ///   useRootNavigator: true,
  ///   context: context,
  ///   builder: (context) => JackImageCollectionView(
  ///     title: widget.businessDetail.title,
  ///     position: index,
  ///     children: item.images.map((e) {
  ///       return Center(
  ///         child: Image.network(e.image),
  ///       );
  ///     }).toList(),
  ///   ),
  /// );
  /// ```
  const JackImageCollectionView({
    Key? key,
    required this.children,
    required this.title,
    required this.position,
  }) : super(key: key);

  @override
  State<JackImageCollectionView> createState() =>
      _JackImageCollectionViewState();
}

class _JackImageCollectionViewState extends State<JackImageCollectionView> {
  /// page controller
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.position);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: appBar(context),
            body: PageView(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              onPageChanged: (page) => {print(page.toString())},
              pageSnapping: true,
              scrollDirection: Axis.vertical,
              children: widget.children,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: ClipRect(
        child: Container(
          color: Colors.white,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 30,
                        padding: const EdgeInsets.only(left: 10),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.65,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          overflow: TextOverflow.fade,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    )
                  ],
                ),
                10.verticalSpace,
                const Divider(height: 1),
              ],
            );
          }),
        ),
      ),
    );
  }
}
