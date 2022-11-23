// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralAppBar extends StatefulWidget {
  final Widget body;
  final double toolBarHeight;
  final Widget appBarLeading;
  final Widget? bottom;
  final double? titleSpacing;

  /// this app bar customize leading,actions and sticky appbar bottom
  const GeneralAppBar({
    Key? key,
    required this.body,
    required this.toolBarHeight,
    required this.appBarLeading,
    this.bottom,
    this.titleSpacing,
  }) : super(key: key);

  @override
  State<GeneralAppBar> createState() => _GeneralAppBarState();
}

class _GeneralAppBarState extends State<GeneralAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                floating: true,
                pinned: true,
                toolbarHeight: widget.toolBarHeight,
                titleSpacing: widget.titleSpacing ?? 16,
                elevation: 0,
                title: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.appBarLeading,
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                final phone = Uri.parse("tel:09756087259");
                                launchUrl(phone);
                              },
                              child: const Icon(Icons.phone),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {},
                              child: const Icon(Icons.notifications),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: widget.titleSpacing != null ? 20.0 : 0),
                            child: InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {},
                              child: const Icon(
                                Icons.qr_code_scanner,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.titleSpacing != null ? 16.0 : 0),
                    child: widget.bottom ?? Container(),
                  ),
                ]),
                // flexibleSpace: Padding(
                //   padding: const EdgeInsets.only(top: 40.0),
                //   child: FlexibleSpaceBar(
                //     collapseMode: CollapseMode.pin,
                //     centerTitle: false,
                //     titlePadding:
                //         const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                //     title:

                //     background: Container(
                //         color: widget.expandedBackgroundColor ??
                //             Theme.of(context).appBarTheme.backgroundColor),
                //   ),
                // ),
              ),
            ];
          },
          body: widget.body,
        ),
      ],
    );
  }
}
