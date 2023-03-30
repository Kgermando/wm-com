import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';

class ArchivePdfViewer extends StatefulWidget {
  const ArchivePdfViewer({super.key, required this.url});
  final String url;

  @override
  State<ArchivePdfViewer> createState() => _ArchivePdfViewerState();
}

class _ArchivePdfViewerState extends State<ArchivePdfViewer> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archive";

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_up,
                          ),
                          onPressed: () {
                            _pdfViewerController.previousPage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          onPressed: () {
                            _pdfViewerController.nextPage();
                          },
                        )
                      ]),
                      Expanded(
                        child: SfPdfViewer.network(
                          widget.url,
                          controller: _pdfViewerController,
                          enableDocumentLinkAnnotation: false,
                          key: _pdfViewerKey,
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
