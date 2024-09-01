

import 'package:flutter/material.dart';

class ValueProvider extends ChangeNotifier {

  bool _cbRemoveDevice=false;
  bool get cbRemoveDevice=>_cbRemoveDevice;
  setCbRemoveDevice(bool val){
    _cbRemoveDevice=val;
    notifyListeners();
  }

}