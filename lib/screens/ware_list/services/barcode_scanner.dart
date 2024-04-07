


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
 late MobileScannerController mobileScannerController;
 @override
  void initState() {
    mobileScannerController=MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      torchEnabled: false,
    );
    super.initState();
  }
  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
    // fit: BoxFit.contain,
    controller: mobileScannerController,
    onDetect: (capture) {
    final List<Barcode> barcodes = capture.barcodes;
    // final Uint8List? image = capture.image;
      for(final barcode in barcodes){
    if(barcode.rawValue!=null){
      print(barcode.rawValue);
       Navigator.pop(context,barcodes.single.rawValue);
    }
      }
    },
      overlay:  Container(
        margin: EdgeInsets.all(20),
        height: 300,
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54 ,width: 1)
        ),

      ),
    );
  }
}
