import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';


class PdfWareListApi {
  static _customTheme() async {
    return ThemeData.withFont(
        base: Font.ttf(await rootBundle.load("assets/fonts/koodak.ttf")),
        bold: Font.ttf(await rootBundle.load("assets/fonts/titr.ttf")),
        italic: Font.ttf(await rootBundle.load("assets/fonts/ariali.ttf")),
        boldItalic: Font.ttf(await rootBundle.load("assets/fonts/arialbi.ttf")),
        icons: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        fontFallback: [
          Font.ttf(await rootBundle.load("assets/fonts/tahoma.ttf")),
          Font.ttf(await rootBundle.load("assets/fonts/tahomabd.ttf")),
        ]);
  }

  //static Shop shopData = HiveBoxes.getShopInfo().get(0)!;
  //static String currency=shopData.currency;
  static Future<File> generateSimpleWareList(
      List<WareHive> wareList, mat.BuildContext context) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);

    ///generate simple price list
    final pdf = Document(theme:await _customTheme());
    final invoicePart = await simpleList(wareList, shopData);

    pdf.addPage(MultiPage(
      build: (context) => [
        invoicePart,
      ],
      // footer: (context) => Directionality(
      //     textDirection: TextDirection.rtl, child: buildFooter(shopData)),
    ));
    return PdfApi.saveDocument(name: "simple Ware List.pdf", pdf: pdf);
  }





  ///generate ticket type ware list
  static Future<File> generateTicketWareList(
      List<WareHive> wareList, mat.BuildContext context) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);
    final pdf = Document(theme:await _customTheme());
    final invoicePart = await ticketTypeList(wareList, shopData);
    pdf.addPage(MultiPage(
      build: (context) => [
        invoicePart,
      ],
    ));
    return PdfApi.saveDocument(name: "ticket Ware List.pdf", pdf: pdf);
  }

  ///******************parts*****************




  static Widget buildSupplierAddress(Shop supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.shopName),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplier.address),
    ],
  );



  /// print simple ware list
  static Future<Widget> simpleList(
      List<WareHive> list, WareProvider shopData) async {
    String currency = shopData.currency;
    final headers =
    ['#', 'نام محصول', 'قیمت فروش ($currency)'].reversed.toList();
    final data = list.map((item) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: pw.Container(
            width: 80 * PdfPageFormat.mm,
            // margin: const EdgeInsets.all(2 * PdfPageFormat.mm),
            padding: const EdgeInsets.all(2 * PdfPageFormat.mm),
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.black, width: .5),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    addSeparator(item.sale),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //ware name text
                  Flexible(
                    flex: 7,
                    child: Text(
                      item.wareName.toPersianDigit(),
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                      ),

                      maxLines: 4,
                    ),
                  ),
                ].reversed.toList()),

          ));
    }).toList();
    return Wrap(children: data);
  }

  ///ticket type model for print price ware list
  static Future<Widget> ticketTypeList(
      List<WareHive> list, WareProvider shopData) async {
    String currency = shopData.currency;
    final data = list.map((item) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: pw.Container(
            width: 50 * PdfPageFormat.mm,
            margin: const EdgeInsets.all(2 * PdfPageFormat.mm),
            padding: const EdgeInsets.all(2 * PdfPageFormat.mm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: PdfColors.black, width: 2),
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //ware name text
                      Flexible(
                        flex: 7,
                        child: Text(
                          item.wareName.toPersianDigit(),
                          style: const TextStyle(),
                          maxLines: 4,
                        ),
                      ),
                      SizedBox(),
                    ]),
                SizedBox(height: 3 * PdfPageFormat.mm),
                //sale price text
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        addSeparator(item.sale).toPersianDigit(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(),
                    ].reversed.toList()
                ),
                //ware serial number barcode if exist
                if (item.wareSerial != null && item.wareSerial != "")
                  Container(
                    height: 15 * PdfPageFormat.mm,
                    width: 40 * PdfPageFormat.mm,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: item.wareSerial.toString(),
                    ),
                  ),
              ],
            ),
          ));
    }).toList();
    return Wrap(children: data);
  }


  static Widget buildFooter(WareProvider shop) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'آدرس:', value: shop.address),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(
          title: 'شماره تماس:',
          value: "${shop.phoneNumber} - ${shop.phoneNumber2}"),
    ],
  );


  ///******************************** widgets **********************************
  static buildSimpleText({
    required String title,
    required String value,
  }) {
    const style = TextStyle(
      fontSize: 12,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),


      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    MainAxisAlignment axisAlignment = MainAxisAlignment.spaceBetween,
    bool unite = false,
  }) {
    final style = titleStyle ?? const TextStyle(color: PdfColors.black);

    return SizedBox(
        width: width,
        child: Expanded(
          child: Row(
            mainAxisAlignment: axisAlignment,
            children: [
              Text(value.toPersianDigit(),
                  style: unite ? style : valueStyle, maxLines: 3),
              SizedBox(width: 5),
              Text(title.toPersianDigit(), style: style, maxLines: 3)
            ],
          ),
        ));
  }
}
