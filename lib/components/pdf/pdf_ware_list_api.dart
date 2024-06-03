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
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';

class PdfWareListApi {
  const PdfWareListApi(
    this.context,
    this.wareList,
  {this.showHeader=true, this.showFooter=true ,required this.pdfFont,}
  );
  final mat.BuildContext context;
  final List<Ware> wareList;
  final bool showHeader;
  final bool showFooter;
  final String pdfFont;
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

  //static Shop shopData = HiveBoxes.getShopInfo().get(0)!;
  //static String currency=shopData.currency;
  ///simple ware list
  Future<File> generateSimpleWareList({double scale = 1,}) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);

    ///generate simple price list
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await simpleList(wareList, shopData, scale: scale);
    final invoiceHeader = await buildTitle(shopData, scale: scale);
    pdf.addPage(MultiPage(
      maxPages: 500,
      build: (context) => [
        invoicePart,
      ],
      header:showHeader? (context) => invoiceHeader:null,
      footer:showFooter? (context) => buildFooter(shopData, scale: scale):null,
    ));
    return PdfApi.saveDocument(name: "simple Ware List.pdf", pdf: pdf);
  }

  ///generate ticket type ware list
  Future<File> generateTicketWareList({double scale = 1}) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await ticketTypeList(wareList, shopData, scale: scale);
    pdf.addPage(MultiPage(
      maxPages: 100,
      build: (context) => [
        invoicePart,
      ],
    ));
    return PdfApi.saveDocument(name: "ticket Ware List.pdf", pdf: pdf);
  }

  ///generate catalog list
  Future<File> generateCatalog({double scale = 1,required Map<String,bool> show}) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await catalogType(wareList, shopData, scale: scale,show:show);
    final invoiceHeader = await buildTitle(shopData, scale: scale);
    pdf.addPage(MultiPage(
      margin: EdgeInsets.all(10),
      maxPages: 100,
      build: (context) => [
        invoicePart,
      ],
      header:showHeader? (context) => invoiceHeader:null,
      footer:showFooter? (context) => buildFooter(shopData, scale: scale):null,
    ));
    return PdfApi.saveDocument(name: "catalog Ware List.pdf", pdf: pdf);
  }

  ///generate legacy ware list
  Future<File> generateLegacyWareList({double scale = 1}) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await legacyList(wareList, shopData, scale: scale);
    final invoiceHeader = await buildTitle(shopData, scale: scale);
    pdf.addPage(
      MultiPage(
        maxPages: 100,
          build: (context) => [
                invoicePart,
              ],
        header:showHeader? (context) => invoiceHeader:null,
        footer:showFooter? (context) => buildFooter(shopData, scale: scale):null,
      ),
    );
    return PdfApi.saveDocument(name: "legacy Ware List.pdf", pdf: pdf);
  }

  ///generate custom ware list
  Future<File> generateCustomWareList({double scale = 1,required Map<String,bool> show}) async {
    WareProvider shopData = Provider.of<WareProvider>(context, listen: false);
    final pdf = Document(theme: await _customTheme());
    final invoicePart = await customList(wareList, shopData,show: show, scale: scale);
    final invoiceHeader = await buildTitle(shopData, scale: scale);
    pdf.addPage(
      MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          build: (context) => [
                invoicePart,
              ],
        header:showHeader? (context) => invoiceHeader:null,
        footer:showFooter? (context) => buildFooter(shopData, scale: scale):null,
      ),
    );
    return PdfApi.saveDocument(name: "custom Ware List.pdf", pdf: pdf);
  }

  ///******************parts*****************
  static Future<Widget> buildTitle(WareProvider shopData,
      {double scale = 1}) async {
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
          Flexible(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                " ${shopData.shopName}",
                style: TextStyle(
                  fontSize: 24 * scale,
                ),
              ),
               if(shopData.shopCode.isNotEmpty)
               Text(
                " ${shopData.shopCode}",
                style: TextStyle(
                  fontSize: 15 * scale,
                ),
              ),
              SizedBox(height: 0.1 * PdfPageFormat.cm),
              Text(shopData.description,
                  maxLines: 4,
                  style: TextStyle(fontSize: 12 * scale)),

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

  static Widget buildSupplierAddress(Shop supplier, {double scale = 1}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.shopName),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  /// print simple ware list
  static Future<Widget> simpleList(List<Ware> list, WareProvider shopData,
      {double scale = 1}) async {
    // String currency = shopData.currency;
    // final headers =
    // ['#', 'نام محصول', 'قیمت فروش ($currency)'].reversed.toList();
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
  static Future<Widget> customList(List<Ware> list, WareProvider shopData,
      {double scale = 1,required Map<String,bool> show}) async {
    String currency = shopData.currency;
    final headers =
    ['#',
      'نام محصول',
      if(show["serial"]!)
      'سریال',
      if(show["count"]!)
      'تعداد',
      if(show["cost"]!)
      'قیمت خرید ($currency)',
      if(show["sale"]!)
      'قیمت فروش ($currency)',
      if(show["des"]!)
      'توضیحات',

    ].reversed.toList();
    final data = list.map((item) {
      return [
        "${list.indexOf(item) + 1}".toPersianDigit(),
        item.wareName.toPersianDigit(),
        if(show["serial"]!)
          item.description,
        if(show["count"]!)
        '${item.quantity}'.toPersianDigit(),
        if(show["cost"]!)
         addSeparator(item.cost),
        if(show["sale"]!)
        addSeparator(item.saleConverted),
        if(show["des"]!)
          item.description,
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
  static Future<Widget> ticketTypeList(
      List<Ware> list, WareProvider shopData,
      {double scale = 1}) async {
    // String currency = shopData.currency;
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
                          style: TextStyle(fontSize: 15 * scale),
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
                        addSeparator(item.saleConverted),
                        style: TextStyle(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(),
                    ].reversed.toList()),
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

  ///catalog type print with image
  static Future<Widget> catalogType(List<Ware> list, WareProvider shopData,
      {double scale = 1,required Map<String,bool> show}) async {
    final emptyImage = (await rootBundle.load("assets/images/empty-image.jpg"))
        .buffer
        .asUint8List();
    String currency = shopData.currency;
    final data = list.map((item) {
      File? itemImage;
      if (item.imagePath != null) {
        itemImage = File(item.imagePath!);
      }

      return Directionality(
          textDirection: TextDirection.rtl,
          child: pw.Container(
            width: 95 * PdfPageFormat.mm,
            margin: const EdgeInsets.all(2 * PdfPageFormat.mm),
            padding: const EdgeInsets.all(2 * PdfPageFormat.mm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: PdfColors.black, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
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
                        ///description
                        if(show["des"]!)
                        Flexible(
                          child: Text(
                            item.description.toPersianDigit(),
                            style: TextStyle(fontSize: 10 * scale,color: PdfColors.blueGrey),
                            maxLines: 4,
                          ),
                        ),
                        SizedBox(height: 3 * PdfPageFormat.mm),

                        ///sale price text
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: PdfColors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                addSeparator(item.saleConverted),
                                style: TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 13 * scale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currency,
                                style: TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 10 * scale,
                                ),
                              ),
                            ])),
                      ]),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40 * PdfPageFormat.mm,
                  width: 40 * PdfPageFormat.mm,
                  decoration: BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: BorderRadius.circular(7),
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

  static Future<Widget> legacyList(List<Ware> list, WareProvider shopData,
      {double scale = 1}) async {
    String currency = shopData.currency;
    final headers =
        ['#', 'نام محصول', 'قیمت فروش ($currency)'].reversed.toList();
    final data = list.map((item) {
      return [
        "${list.indexOf(item) + 1}".toPersianDigit(),
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
  static Widget buildFooter(WareProvider shop, {double scale = 1}) =>
      Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(),
              SizedBox(height: 2 * PdfPageFormat.mm),
              buildSimpleText(
                  title: 'آدرس:', value: shop.address, scale: scale),
              SizedBox(height: 1 * PdfPageFormat.mm),
              buildSimpleText(
                  title: 'شماره تماس:',
                  value: "${shop.phoneNumber} - ${shop.phoneNumber2}",
                  scale: scale),
            ],
          ));

  ///******************************** widgets **********************************
  static buildSimpleText({
    required String title,
    required String value,
    double scale = 1,
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

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    MainAxisAlignment axisAlignment = MainAxisAlignment.spaceBetween,
    bool unite = false,
    double scale = 1,
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
}
