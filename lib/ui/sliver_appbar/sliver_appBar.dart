// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class JackUISliverAppBar extends StatefulWidget {
  final bool increaseDirection;
  final double kBasePadding;
  final double kExpandedHeight;
  final double kCollapsedPadding;
  final Widget body;
  final Color? expandedBackgroundColor;
  final Color? collapsedBackgroundColor;

  const JackUISliverAppBar({
    Key? key,
    required this.increaseDirection,
    required this.kBasePadding,
    required this.kExpandedHeight,
    required this.kCollapsedPadding,
    required this.body,
    this.expandedBackgroundColor,
    this.collapsedBackgroundColor,
  }) : super(key: key);

  @override
  State<JackUISliverAppBar> createState() => _JackUISliverAppBarState();
}

class _JackUISliverAppBarState extends State<JackUISliverAppBar> {
  /// this is the increase direction or decrease direction
  late bool _increaseDirection;

  /// this is the padding of the expanded situation
  // static const _kBasePadding = 40.0;
  late double _kBasePadding;

  /// this is the height of the expanded situation
  // static const _kExpandedHeight = 300.0;
  late double _kExpandedHeight;

  late ValueNotifier<double> _titlePaddingNotifier;

  final _scrollController = ScrollController();

  /// this is the padding of the normal original title
  // const _kCollapsedPadding = 60.0;
  // static const _kCollapsedPadding = 140.0;
  late double _kCollapsedPadding;

  /// the scrolloffset
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0.0);

  /// slope
  late double m;

  /// intercept
  late double c;

  @override
  void initState() {
    super.initState();
    _kBasePadding = widget.kBasePadding;
    _kExpandedHeight = widget.kExpandedHeight;
    _kCollapsedPadding = widget.kCollapsedPadding;
    _titlePaddingNotifier = ValueNotifier<double>(widget.kBasePadding);
    _increaseDirection = widget.increaseDirection;
    m = (_kBasePadding - _kCollapsedPadding) /
        (0 - (_kExpandedHeight - kToolbarHeight));
    c = _kBasePadding - (m * 0);
    _scrollControlListener();
  }

  void _scrollControlListener() {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
      _scrollOffset.value = _scrollController.offset;
      setState(() {});
    });
  }

  double get _horizontalTitlePadding {
    // if (_scrollController.hasClients) {
    // final aa = min(
    //     _kBasePadding + _kCollapsedPadding,
    //     _kBasePadding -
    //         (_kCollapsedPadding * _scrollController.offset) /
    //             (_kExpandedHeight - kToolbarHeight));

    // i code it for center to left but still work other but check out
    // if (aa.round() < _kBasePadding - _kCollapsedPadding) {
    //   print("----------------------leee----------------------");
    //   return _kBasePadding - _kCollapsedPadding;
    // }
    // }
    // return _kBasePadding;
    final y = (m * _scrollController.offset) + c;
    if (_increaseDirection) {
      if (y.round() > _kCollapsedPadding) return _kCollapsedPadding;
    } else {
      if (y.round() < _kCollapsedPadding) return _kCollapsedPadding;
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: widget.expandedBackgroundColor ??
                    Theme.of(context).appBarTheme.backgroundColor,
                leading: const Icon(Icons.menu),
                floating: true,
                pinned: true,
                expandedHeight: _kExpandedHeight,
                title: ValueListenableBuilder(
                    valueListenable: _scrollOffset,
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity:
                              value >= (_kExpandedHeight - kToolbarHeight) - 30
                                  ? 1.0
                                  : 0.0,
                          child: const Text('ha'));
                    }),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: false,
                  titlePadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  title: ValueListenableBuilder(
                    valueListenable: _titlePaddingNotifier,
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.only(left: value),
                        child: const Text("Title"),
                      );
                    },
                  ),
                  background: Container(
                      color: widget.expandedBackgroundColor ??
                          Theme.of(context).appBarTheme.backgroundColor),
                ),
              ),
            ];
          },
          body: widget.body,
        ),
        _buildFad(),
      ],
    );
  }

  Widget _buildFad() {
    /// default position of your desire widget
    double defaultMargin = _kExpandedHeight;

    /// default fade in start point
    double defaultStart = _kExpandedHeight - 10;

    /// default fade in end point
    double defaultEnd = defaultStart / 2;

    /// valuenotifier of the widget top position
    ValueNotifier<double> top = ValueNotifier(defaultMargin);

    /// valuenotifier of the widget scale as varies of top position
    ValueNotifier<double> scale = ValueNotifier<double>(1.0);

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top.value -= offset;
      if (offset < defaultMargin - defaultStart) {
        scale.value = 1.0;
      } else if (offset < defaultStart - defaultEnd) {
        scale.value = (defaultMargin - defaultEnd - offset) / defaultEnd;
      } else {
        scale.value = 0.0;
      }
    }

    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {
        return Positioned(
          top: value,
          right: 20,
          child: ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(value),
                child: FloatingActionButton(
                  onPressed: () {},
                ),
              );
            },
            valueListenable: scale,
          ),
        );
      },
      valueListenable: top,
    );
  }
}
