// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jack_components/security/encrypt%20_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerate extends StatefulWidget {
  final String data;
  final double size;
  const QRGenerate({
    Key? key,
    required this.data,
    required this.size,
  }) : super(key: key);

  @override
  State<QRGenerate> createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {
  late Timer timer;
  final JackEncryptData encryptData =
      JackEncryptData(securekey: "SabanaWOWmeDoublePlusApplication");
  late JackFernetModel encrypted;

  @override
  void initState() {
    encrypted = encryptData.encryptFernet(
        "${widget.data}%${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}");

    startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        encrypted = encryptData.encryptFernet(
            "${widget.data}%${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}");
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: encrypted.encrypted.base64,
      gapless: false,
      size: widget.size,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      embeddedImage: const AssetImage("assets/img/ApplogoYellowicon.png"),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: const Size(50, 50),
      ),
    );
  }
}
