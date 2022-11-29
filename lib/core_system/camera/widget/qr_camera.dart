// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jack_components/core_system/camera/change_to_encrypted.dart';
import 'package:jack_components/jack_components.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class JackQRScanResult {
  final String scannedValue;
  final String actualValue;
  final String dateString;
  final String code;
  final DateTime date;
  final bool decrypt;
  final String? normalCode;
  JackQRScanResult({
    required this.scannedValue,
    required this.actualValue,
    required this.dateString,
    required this.code,
    required this.date,
    required this.decrypt,
    this.normalCode,
  });
}

class JackQRCamera extends StatefulWidget {
  final String securePassword;
  final Color? borderColor;
  final double? borderWidth;
  final Color? overlayColor;
  final double? borderRadius;
  final double? borderLength;
  final double? scanArea;
  final Text? title;
  final Color? resultColor;
  const JackQRCamera({
    Key? key,
    this.borderColor,
    this.borderWidth,
    this.overlayColor,
    this.borderRadius,
    this.borderLength,
    this.scanArea,
    this.title,
    this.resultColor,
    required this.securePassword,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JackQRCameraState();
}

class _JackQRCameraState extends State<JackQRCamera> {
  JackQRScanResult? result;
  QRViewController? controller;
  late double scanArea;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'JackQR');

  /// encrypted value
  late JackEncryptData encryptData;

  @override
  void initState() {
    encryptData = JackEncryptData(securekey: widget.securePassword);
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // we check how width or tall the device is and change the scanArea and overlay accordingly.
    scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Flexible(child: _buildQrView(context)),
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 15,
              ),
              height: 60,
              width: 60,
              // decoration: BoxDecoration(
              //   color: const Color.fromARGB(92, 0, 0, 0),
              //   borderRadius: BorderRadius.circular(50),
              // ),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: scanArea + 100),
                child: widget.title ??
                    const Text('Scan QR code to proceed WOW Point'),
              ),
            ),
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: scanArea + 150),
                  child: IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.flashlight_on_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
            ),
            if (result != null && result!.decrypt)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 50,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        result!.code.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                      Text(
                        result!.dateString.toString(),
                        style: TextStyle(
                            color: DateTime.now()
                                        .difference(result!.date)
                                        .inSeconds >
                                    15
                                ? Colors.red
                                : Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            if (result != null && !result!.decrypt)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 50,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    result!.normalCode.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        overlayColor: widget.overlayColor ?? const Color.fromRGBO(0, 0, 0, 80),
        borderColor: widget.borderColor ?? Colors.purple,
        borderRadius: widget.borderRadius ?? 10,
        borderLength: widget.borderLength ?? 30,
        borderWidth: widget.borderWidth ?? 10,
        cutOutSize: widget.scanArea ?? scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    if (Platform.isAndroid) {
      controller.resumeCamera();
    }
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (scanData.code != null) {
          late JackQRScanResult scanned;
          try {
            final actualValue = encryptData
                .decryptFernet(changeToEncrypted(base64Decode(scanData.code!)));
            final dateString = actualValue.split("%")[1];
            final code = actualValue.split("%")[0];
            final date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
            scanned = JackQRScanResult(
              scannedValue: scanData.code!,
              actualValue: actualValue.split("%")[0],
              dateString: dateString,
              code: code,
              date: date,
              decrypt: true,
            );
          } catch (e) {
            scanned = JackQRScanResult(
              scannedValue: "",
              actualValue: "",
              dateString: "",
              code: "",
              date: DateTime.now(),
              decrypt: false,
              normalCode: scanData.code,
            );
          }
          result = scanned;
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


// Expanded(
//               flex: 1,
//               child: FittedBox(
//                 fit: BoxFit.contain,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     if (result != null)
//                       Text(
//                           'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                     else
//                       const Text('Scan a code'),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           margin: const EdgeInsets.all(8),
//                           child: ElevatedButton(
//                               onPressed: () async {
//                                 await controller?.toggleFlash();
//                                 setState(() {});
//                               },
//                               child: FutureBuilder(
//                                 future: controller?.getFlashStatus(),
//                                 builder: (context, snapshot) {
//                                   return Text('Flash: ${snapshot.data}');
//                                 },
//                               )),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.all(8),
//                           child: ElevatedButton(
//                               onPressed: () async {
//                                 await controller?.flipCamera();
//                                 setState(() {});
//                               },
//                               child: FutureBuilder(
//                                 future: controller?.getCameraInfo(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.data != null) {
//                                     return Text(
//                                         'Camera facing ${describeEnum(snapshot.data!)}');
//                                   } else {
//                                     return const Text('loading');
//                                   }
//                                 },
//                               )),
//                         )
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           margin: const EdgeInsets.all(8),
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.pauseCamera();
//                             },
//                             child: const Text('pause',
//                                 style: TextStyle(fontSize: 20)),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.all(8),
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.resumeCamera();
//                             },
//                             child: const Text('resume',
//                                 style: TextStyle(fontSize: 20)),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
          