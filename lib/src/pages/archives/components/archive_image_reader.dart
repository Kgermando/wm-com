import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ArchiveImageReader extends StatefulWidget {
  const ArchiveImageReader({super.key, required this.url});
  final String url;

  @override
  State<ArchiveImageReader> createState() => _ArchiveImageReaderState();
}

class _ArchiveImageReaderState extends State<ArchiveImageReader> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archive";

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, 'View'),
        drawer: const DrawerMenu(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenu())),
            Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(
                      top: Responsive.isMobile(context) ? 0.0 : p20,
                      bottom: p8,
                      right: Responsive.isMobile(context) ? 0.0 : p20,
                      left: Responsive.isMobile(context) ? 0.0 : p20),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CachedNetworkImageBuilder(
                          url: widget.url,
                          builder: (image) {
                            return Center(
                                child: Image.file(
                              image,
                              height: sized.height / 1.2,
                            ));
                          },
                          // Optional Placeholder widget until image loaded from url
                          placeHolder: Center(child: loading()),
                          // Optional error widget
                          errorWidget: Image.asset('assets/images/error.png'),
                          // Optional describe your image extensions default values are; jpg, jpeg, gif and png
                          imageExtensions: const ['jpg', 'png'],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
