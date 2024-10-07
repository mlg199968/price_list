import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:intl/intl.dart' as intl;
import 'package:price_list/services/hive_boxes.dart';
import 'package:uuid/uuid.dart';

class ExcelTools{
  ///create excel file from ware list
static Future<String?> createExcel(context,String? directory)async{
  try {
    if (directory == null) {
      showSnackBar(
          context, "مسیر ذخیره سازی انتخاب نشده است!", type: SnackType.warning);
    }
    else {
      List<Ware> wares = HiveBoxes
          .getWares()
          .values
          .toList();
      ByteData data = await rootBundle.load('assets/files/ware-list.xlsx');
      var bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);
      Sheet sheet = excel["Sheet1"];
      sheet.isRTL = true;
      sheet.setColumnWidth(0, 5);
      sheet.setColumnWidth(1, 25);
      sheet.setColumnWidth(2, 12);
      sheet.setColumnWidth(3, 10);
      sheet.setColumnWidth(4, 10);
      sheet.setColumnWidth(5, 15);
      sheet.setColumnWidth(6, 15);
      sheet.setColumnWidth(7, 15);
      sheet.setColumnWidth(8, 15);
      sheet.setColumnWidth(9, 25);
      sheet.setColumnWidth(10, 40);
      sheet.setColumnWidth(11, 30);
      ///import data to cells
      for (int i = 0; i < wares.length; i++) {
        int index = i + 2;
        Ware ware = wares[i];
        ///index
        Data indexCell = sheet.cell(CellIndex.indexByString('A$index'));
        indexCell.cellStyle=CellStyle(
            numberFormat: NumFormat.defaultNumeric
        );
        indexCell.value = IntCellValue(i+1);
        ///ware name
        Data nameCell = sheet.cell(CellIndex.indexByString('B$index'));
        nameCell.value = TextCellValue(ware.wareName);
        ///serial
        Data serialCell = sheet.cell(CellIndex.indexByString('C$index'));
        serialCell.value = TextCellValue(ware.wareSerial ?? "");
        ///quantity
        Data quantityCell = sheet.cell(CellIndex.indexByString('D$index'));
        quantityCell.cellStyle=CellStyle(
            numberFormat: NumFormat.defaultNumeric);
        quantityCell.value =DoubleCellValue(ware.quantity.toDouble());
        ///unit
        Data unitCell = sheet.cell(CellIndex.indexByString('E$index'));
        unitCell.value = TextCellValue(ware.unit);
        ///cost
        Data costCell = sheet.cell(CellIndex.indexByString('F$index'));
        costCell.cellStyle=CellStyle(
            numberFormat: NumFormat.defaultNumeric);
        costCell.value = DoubleCellValue(ware.cost.toDouble());
        ///sale
        Data saleCell = sheet.cell(CellIndex.indexByString('G$index'));
        saleCell.cellStyle=CellStyle(
            numberFormat: NumFormat.defaultNumeric);
        saleCell.value = DoubleCellValue(ware.sale.toDouble());
        ///sale2
        Data sale2Cell = sheet.cell(CellIndex.indexByString('H$index'));
        sale2Cell.cellStyle=CellStyle(
            numberFormat: NumFormat.defaultNumeric);
        sale2Cell.value =ware.sale2==null?null: DoubleCellValue(ware.sale2!.toDouble());
        ///sale3
        Data sale3Cell = sheet.cell(CellIndex.indexByString('I$index'));
        sale3Cell.cellStyle=CellStyle(
            numberFormat: NumFormat.defaultNumeric);
        sale3Cell.value = ware.sale3==null?null:DoubleCellValue(ware.sale3!.toDouble());
        ///category
        Data categoryCell = sheet.cell(CellIndex.indexByString('J$index'));
        categoryCell.value = TextCellValue(ware.groupName);
        ///description
        Data descriptionCell = sheet.cell(CellIndex.indexByString('K$index'));
        descriptionCell.value = TextCellValue(ware.description);
        ///id
        Data idCell = sheet.cell(CellIndex.indexByString('L$index'));
        idCell.value = ware.wareID == null ? null : TextCellValue(ware.wareID!);
      }

      List<int>? fileBytes = excel.save();
      String formattedDate =
      intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
      File file=await File(join('$directory/$kAppName-$formattedDate.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      showSnackBar(context, "فایل اکسل با موفقیت ذخیره شد",type: SnackType.success);
      return file.path;
    }
  }catch(e){
    ErrorHandler.errorManger(context, e,title: "خطا در ذخیره سازی فایل اکسل",route: "ExcelTools createExcel error",showSnackbar: true);
  }
  return null;
  }

  ///read excel file
  static readExcel(context)async{
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    if (result != null) {
      List<int> bytes=await File(result.files.single.path!).readAsBytes();
        Excel excel = await Excel.decodeBytes(bytes);
        Sheet sheet = excel["Sheet1"];
        Ware ware = Ware();
        for (int i = 0; i < sheet.maxRows-1; i++) {
          int index = i + 2;
          ware = Ware();
          //cell data to number function
          num cellToNumber(Data cell){
            if(cell.value == null){
              return 0;
            }
            else if(cell.value.runtimeType==IntCellValue) {
              return (cell.value as IntCellValue).value;
            }
            else if(cell.value.runtimeType==DoubleCellValue){
              return (cell.value as DoubleCellValue).value;
            }
            else if(cell.value.runtimeType==TextCellValue){
              return stringToDouble((cell.value as TextCellValue).value.text!);
            }
            else{
              showSnackBar(context, " خطا در ردیف $index  ${ware.wareName}",type: SnackType.error);
              return 0;
            }
          }
          ///ware name
          Data nameCell = sheet.cell(CellIndex.indexByString('B$index'));
          ware.wareName =
              nameCell.value == null ? "unknown" : (nameCell.value as TextCellValue).value.text!;

          ///serial
          Data serialCell = sheet.cell(CellIndex.indexByString('C$index'));
          ware.wareSerial =
              serialCell.value == null ? "" : (serialCell.value as TextCellValue).value.text;

          ///quantity
          Data quantityCell = sheet.cell(CellIndex.indexByString('D$index'));
            ware.quantity =cellToNumber(quantityCell);
          ///unit
          Data unitCell = sheet.cell(CellIndex.indexByString('E$index'));
          ware.unit =
              unitCell.value == null ? "عدد" : (unitCell.value as TextCellValue).value.text!;
          ///cost
          Data costCell = sheet.cell(CellIndex.indexByString('F$index'));
            ware.cost =cellToNumber(costCell);
          ///sale
          Data saleCell = sheet.cell(CellIndex.indexByString('G$index'));
            ware.sale =cellToNumber(saleCell);
          ///sale2
          Data sale2Cell = sheet.cell(CellIndex.indexByString('H$index'));
            ware.sale2 =cellToNumber(sale2Cell);
          ///sale3
          Data sale3Cell = sheet.cell(CellIndex.indexByString('I$index'));
            ware.sale3 =cellToNumber(sale3Cell);

          ///category
          Data categoryCell =
              sheet.cell(CellIndex.indexByString('J$index'));
          ware.groupName = categoryCell.value == null
              ? "نامشخص"
              : (categoryCell.value as TextCellValue).value.text!;

          ///description
          Data descriptionCell =
              sheet.cell(CellIndex.indexByString('K$index'));
          ware.description = descriptionCell.value == null
              ? ""
              : (descriptionCell.value as TextCellValue).value.text!;

          ///id
          Data idCell = sheet.cell(CellIndex.indexByString('L$index'));
          ware.wareID =
              idCell.value == null ? Uuid().v1() : (idCell.value as TextCellValue).value.text;

          HiveBoxes.getWares().put(ware.wareID, ware);
        }
        showSnackBar(context, "فایل اکسل با موفقیت بارگیری شد",
            type: SnackType.success);
            }
  }catch(e){
    ErrorHandler.errorManger(context, e,title: "خطا در بارگیری فایل اکسل",route: "ExcelTools readExcel error",showSnackbar: true);
  }
  }
}