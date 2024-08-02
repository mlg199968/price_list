import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class PdfWareListApi {
  const PdfWareListApi(
    this.context,
    this.wareList, {
    required this.scale,
    required this.show,
    this.showHeader = true,
    this.showFooter = true,
    required this.pdfFont,
  });
  final mat.BuildContext context;
  final List<Ware> wareList;
  final bool showHeader;
  final bool showFooter;
  final double scale;
  final String pdfFont;
  final Map<String, bool> show;
  UserProvider get shopData =>
      Provider.of<UserProvider>(context, listen: false);
  String get currency =>
      shopData.replacedCurrency ? "تومان" : shopData.currency;

  _customTheme() async {
    return ThemeData.withFont(
        base: Font.ttf(await rootBundle.load("assets/fonts/$pdfFont.ttf")),
        bold: Font.ttf(await rootBundle.load("assets/fonts/$pdfFont.ttf")),
        italic: Font.ttf(await rootBundle.load("assets/fonts/ariali.ttf")),
        boldItalic: Font.ttf(await rootBundle.load("assets/fonts/arialbi.ttf")),
        icons: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        fontFallback: [
          Font.ttf(await rootBundle.load("assets/fonts/tahoma.ttf")),
          Font.ttf(await rootBundle.load("assets/fonts/tahomabd.ttf")),
        ]);
  }

  ///simple ware list
  Future<File> generateSimpleWareList({
    double scale = 1,
  }) async {
    ///generate simple price list
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await simpleList();
    final invoiceHeader = await buildTitle();
    pdf.addPage(MultiPage(
      maxPages: 500,
      build: (context) => [
        invoicePart,
      ],
      header: showHeader ? (context) => invoiceHeader : null,
      footer: showFooter ? (context) => buildFooter() : null,
    ));
    return PdfApi.saveDocument(name: "simple Ware List.pdf", pdf: pdf);
  }

  ///generate ticket type ware list
  Future<File> generateTicketWareList() async {
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await ticketTypeList();
    pdf.addPage(MultiPage(
      maxPages: 100,
      build: (context) => [
        invoicePart,
      ],
    ));
    return PdfApi.saveDocument(name: "ticket Ware List.pdf", pdf: pdf);
  }

  ///generate catalog list
  Future<File> generateCatalog() async {
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await catalogType();
    final invoiceHeader = await buildTitle();
    pdf.addPage(MultiPage(
      margin: EdgeInsets.all(10),
      maxPages: 100,
      build: (context) => [
        invoicePart,
      ],
      header: showHeader ? (context) => invoiceHeader : null,
      footer: showFooter ? (context) => buildFooter() : null,
    ));
    return PdfApi.saveDocument(name: "catalog Ware List.pdf", pdf: pdf);
  }

  ///generate legacy ware list
  Future<File> generateLegacyWareList() async {
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await legacyList();
    final invoiceHeader = await buildTitle();
    pdf.addPage(
      MultiPage(
        maxPages: 100,
        build: (context) => [
          invoicePart,
        ],
        header: showHeader ? (context) => invoiceHeader : null,
        footer: showFooter ? (context) => buildFooter() : null,
      ),
    );
    return PdfApi.saveDocument(name: "legacy Ware List.pdf", pdf: pdf);
  }

  ///generate custom ware list
  Future<File> generateCustomWareList() async {
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await customList();
    final invoiceHeader = await buildTitle();
    pdf.addPage(
      MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        build: (context) => [
          invoicePart,
        ],
        header: showHeader ? (context) => invoiceHeader : null,
        footer: showFooter ? (context) => buildFooter() : null,
      ),
    );
    return PdfApi.saveDocument(name: "custom Ware List.pdf", pdf: pdf);
  }

  ///******************parts*****************
  Future<Widget> buildTitle() async {
    File? logoImageFile = shopData.logoImage != null
        ? (await File(shopData.logoImage!).exists()
            ? File(shopData.logoImage!)
            : null)
        : null;

    return Directionality(
        textDirection: TextDirection.rtl,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: 50,
            width: 50,
            //   child: BarcodeWidget(
            //     barcode: Barcode.qrCode(),
            //     data:
            //     " شماره فاکتور: ${bill.billNumber}, قابل پرداخت: ${addSeparator(bill.payable)},",
            //   ),
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                " ${shopData.shopName}",
                style: TextStyle(
                  fontSize: 24 * scale,
                ),
              ),
              if (shopData.shopCode.isNotEmpty)
                Text(
                  " ${shopData.shopCode}",
                  style: TextStyle(
                    fontSize: 15 * scale,
                  ),
                ),
              SizedBox(height: 0.1 * PdfPageFormat.cm),
              Text(shopData.description,
                  maxLines: 4, style: TextStyle(fontSize: 12 * scale)),
              SizedBox(height: 0.8 * PdfPageFormat.cm),
            ],
          )),
          SizedBox(width: .1 * PdfPageFormat.cm),

          ///shop logo holder
          Container(
              height: 50,
              width: 50,
              child: logoImageFile == null
                  ? SizedBox()
                  : Image(pw.MemoryImage(logoImageFile.readAsBytesSync()),
                      fit: BoxFit.fill)),
        ]));
  }

  Widget buildSupplierAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shopData.shopName),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(shopData.address),
        ],
      );

  /// print simple ware list
  Future<Widget> simpleList() async {
    final data = wareList.map((item) {
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
                    addSeparator(item.saleConverted),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14 * scale),
                  ),
                  //ware name text
                  Flexible(
                    flex: 7,
                    child: Text(
                      item.wareName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14 * scale),
                      maxLines: 4,
                    ),
                  ),
                ].reversed.toList()),
          ));
    }).toList();
    return Wrap(children: data);
  }

  /// print custom ware list
  Future<Widget> customList() async {
    final headers = [
      '#',
      'نام محصول',
      if (show["serial"]!) 'سریال',
      if (show["count"]!) 'تعداد',
      if (show["cost"]!) 'قیمت خرید ($currency)',
      if (show["sale"]!) 'قیمت فروش ($currency)',
      if (show["sale2"]!) 'قیمت فروش2 ($currency)',
      if (show["sale3"]!) 'قیمت فروش3 ($currency)',
      if (show["des"]!) 'توضیحات',
    ].reversed.toList();
    final data = wareList.map((item) {
      return [
        "${wareList.indexOf(item) + 1}".toPersianDigit(),
        item.wareName.toPersianDigit(),
        if (show["serial"]!) item.wareSerial,
        if (show["count"]!) '${item.quantity}'.toPersianDigit(),
        if (show["cost"]!) addSeparator(item.cost),
        if (show["sale"]!) addSeparator(item.sale),
        if (show["sale2"]!) addSeparator(item.sale2 ?? 0),
        if (show["sale3"]!) addSeparator(item.sale3 ?? 0),
        if (show["des"]!) item.description,
      ].reversed.toList();
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TableHelper.fromTextArray(
        headers: headers,
        data: data,
        //border: null,
        headerStyle: TextStyle(
          fontSize: 12 * scale,
        ),
        headerDecoration: const BoxDecoration(
          color: PdfColors.grey300,
        ),
        cellHeight: 30,
        cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * scale),
        // columnWidths: {2: const FixedColumnWidth(20)},
        headerAlignment: Alignment.center,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
          5: Alignment.centerRight,
        },
        oddCellStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * scale),
      ),
    );
  }

  ///ticket type model for print price ware list
  Future<Widget> ticketTypeList() async {
    final data = wareList.map((item) {
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
                          style: TextStyle(fontSize: 15 * scale),
                          maxLines: 4,
                        ),
                      ),
                      SizedBox(),
                    ]),
                SizedBox(height: 3 * PdfPageFormat.mm),
                //sale price text
                priceHolder(item),
                SizedBox(height: 1 * PdfPageFormat.mm),
                ///ware serial number barcode if exist
                if (item.wareSerial != null &&
                    item.wareSerial != "" &&
                    show["serial"]!)
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

  ///catalog type print with image
  Future<Widget> catalogType() async {
    final emptyImage = (await rootBundle.load("assets/images/empty-image.jpg"))
        .buffer
        .asUint8List();
    final data = wareList.map((item) {
      File? itemImage;
      if (item.imagePath != null) {
        itemImage = File(item.imagePath!);
      }

      return Directionality(
          textDirection: TextDirection.rtl,
          child: pw.Container(
            width: 95 * PdfPageFormat.mm,
            margin: const EdgeInsets.all(2 * PdfPageFormat.mm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: PdfColors.black, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(2 * PdfPageFormat.mm),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///ware name text
                        Flexible(
                          child: Text(
                            item.wareName.toPersianDigit(),
                            style: TextStyle(fontSize: 15 * scale),
                            maxLines: 4,
                          ),
                        ),
                        SizedBox(height: 3 * PdfPageFormat.mm),

                        ///catalog description
                        if (show["des"]!)
                          Flexible(
                            child: Text(
                              item.description.toPersianDigit(),
                              style: TextStyle(
                                  fontSize: 10 * scale,
                                  color: PdfColors.blueGrey),
                              maxLines: 4,
                            ),
                          ),
                        SizedBox(height: 3 * PdfPageFormat.mm),
                        if (show["sale"]!)

                          ///sale price text
                          priceHolder(item),
                      ]),
                )),

                ///catalog image holder
                Container(
                  alignment: Alignment.center,
                  height: 40 * PdfPageFormat.mm,
                  width: 40 * PdfPageFormat.mm,
                  decoration: BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: itemImage == null
                          ? MemoryImage(emptyImage)
                          : MemoryImage(itemImage.readAsBytesSync()),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }).toList();
    return Center(
      child: Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.end,
          children: data),
    );
  }

  ///
  Future<Widget> legacyList() async {
    String currency = shopData.currency;
    final headers =
        ['#', 'نام محصول', 'قیمت فروش ($currency)'].reversed.toList();
    final data = wareList.map((item) {
      return [
        "${wareList.indexOf(item) + 1}".toPersianDigit(),
        item.wareName.toPersianDigit(),
        //'${item.quantity}'.toPersianDigit(),
        // addSeparator(item.cost),
        addSeparator(item.saleConverted),
      ].reversed.toList();
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TableHelper.fromTextArray(
        headers: headers,
        data: data,
        //border: null,
        headerStyle: TextStyle(
          fontSize: 12 * scale,
        ),
        headerDecoration: const BoxDecoration(
          color: PdfColors.grey300,
        ),
        cellHeight: 30,
        cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * scale),
        columnWidths: {2: const FixedColumnWidth(20)},
        headerAlignment: Alignment.center,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          // 2: Alignment.centerRight,
          // 3: Alignment.centerRight,
          2: Alignment.centerRight,
        },
        oddCellStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * scale),
      ),
    );
  }

  ///page footer info
  Widget buildFooter() => Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'آدرس:', value: shopData.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'شماره تماس:',
              value: "${shopData.phoneNumber} - ${shopData.phoneNumber2}"),
        ],
      ));

  ///******************************** widgets **********************************
   buildSimpleText({
    required String title,
    required String value,

  }) {
    final style = TextStyle(
      fontSize: 12 * scale,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(value, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(title, style: style),
      ].reversed.toList(),
    );
  }

  ///
   buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    MainAxisAlignment axisAlignment = MainAxisAlignment.spaceBetween,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(color: PdfColors.black, fontSize: 11 * scale);
    final valStyle =
        valueStyle ?? TextStyle(color: PdfColors.black, fontSize: 12 * scale);

    return SizedBox(
        width: width,
        child: Expanded(
          child: Row(
            mainAxisAlignment: axisAlignment,
            children: [
              Text(title.toPersianDigit(), style: style, maxLines: 3),
              SizedBox(width: 5),
              Text(value.toPersianDigit(),
                  style: unite ? style : valueStyle ?? valStyle, maxLines: 3),
            ],
          ),
        ));
  }
  ///
  priceHolder(Ware ware) {
    return Column(
      children: [
        ///main price
        if (ware.discount != null && ware.discount! > 0)
          Text(
            addSeparator(ware.selectedSale),
            style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: PdfColors.blueGrey,
                fontSize: 13),
          ),

        ///with discount price
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: PdfColors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///discount percent
              if (ware.discount != null && ware.discount! > 0)
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                        color: PdfColors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "${ware.discount}%".toPersianDigit(),
                      style: const TextStyle(color: PdfColors.white),
                    )),
              Text(
                addSeparator(ware.saleConverted),
                style: const TextStyle(color: PdfColors.white, fontSize: 16),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                currency,
                style: TextStyle(color: PdfColors.blueGrey, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

