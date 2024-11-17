

import 'package:flutter/material.dart';

class ValueProvider extends ChangeNotifier {
/// this option is for exist form subscription dialog and remove device form database to log in to the new device
  bool _cbRemoveDevice=false;
  bool get cbRemoveDevice=>_cbRemoveDevice;
  setCbRemoveDevice(bool val){
    _cbRemoveDevice=val;
    notifyListeners();
  }
///
 bool _invertSort=false;
  bool get invertSort=>_invertSort;
  setInvertSort(bool val){
    _invertSort=val;
    notifyListeners();
  }


}