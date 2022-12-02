// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jack_components/security/encrypt_decrypt/encrypt%20_data.dart';
import 'package:ntp/ntp.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerate extends StatefulWidget {
  final String data;
  final double size;
  final DateTime initialDate;
  final bool passNTP;
  const QRGenerate({
    Key? key,
    required this.data,
    required this.size,
    required this.initialDate,
    required this.passNTP,
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
    super.initState();
    encrypted = encryptData.encryptFernet(
        "${widget.data}%${DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.initialDate)}");

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      DateTime date = widget.passNTP ? DateTime.now() : await NTP.now();
      setState(() {
        encrypted = encryptData.encryptFernet(
            "${widget.data}%${DateFormat("yyyy-MM-dd HH:mm:ss").format(date)}");
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
        size: const Size(40, 40),
      ),
    );
  }
}
