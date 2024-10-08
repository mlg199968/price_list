import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ntp/ntp.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/model/notice.dart';
import 'package:provider/provider.dart';
import '../constants/enums.dart';
import '../constants/utils.dart';
import '../model/device.dart';
import '../model/plan.dart';
import '../model/subscription.dart';
import '../providers/user_provider.dart';
import 'hive_boxes.dart';

class BackendServices {
  ///create new subscription data in host
  static Future<String?> createSubs(context,
      {required Subscription subs}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/create_subscription.php"),
          body: subs.toJson());
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          debugPrint(backData["message"] ?? "success");
          return backData["id"].toString();
        } else {
          debugPrint(backData["message"] ?? "not success");
          if (backData["error"] != null) {
            ErrorHandler.errorManger(
              null,
              backData["error"],
              title: backData["message"] ?? "backData success is false",
            );
          }
          return null;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(null, e,
          stacktrace: stacktrace, title: "BackendServices createSubs error");
    }
    return null;
  }

  ///update subscription data in host
  static Future<String?> updateSubs(context,
      {required Subscription subs}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/update_subscription.php"),
          body: subs.toJson());
      print(res.body);
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          debugPrint(backData["message"] ?? "success",);
          return backData["id"].toString();
        } else {
          debugPrint(backData["message"] ?? "not success");
          if (backData["error"] != null) {
            ErrorHandler.errorManger(
              null,
              backData["error"],
              title: backData["message"] ?? "backData success is false",
            );
          }
          return null;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace, title: "BackendServices updateSubs error");
    }
    return null;
  }
  ///update subscription data in host
  static Future<String?> removeDeviceFromServer(context,
      {required String id,}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/remove_device.php"),
          body: {"id":id,"fetch_date":DateTime.now().toIso8601String()});
      print(res.body);
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          debugPrint(backData["message"] ?? "success",);
          return backData["id"].toString();
        } else {
          debugPrint(backData["message"] ?? "not success");
          if (backData["error"] != null) {
            ErrorHandler.errorManger(
              null,
              backData["error"],
              title: backData["message"] ?? "backData success is false",
            );
          }
          return null;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace, title: "BackendServices updateSubs error");
    }
    return null;
  }

  ///read subscription data from host
  static Future<Map> readSubs(context, String phone, {String? subsId}) async {
    Map map = {"success": false, "subs": null};
    try {
      Device device = await getDeviceInfo();
      http.Response res = await http
          .post(Uri.parse("$hostUrl/user/read_subscription.php"), body: {
        "phone": phone,
        "device": device.toJson(),
        "appName": kAppName,
        if (subsId != null) "subsId": subsId,
      });
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          map["success"] = true;
          map["subs"] = backData["subsData"] == null
              ? null
              : Subscription().fromMap(backData["subsData"]);
          debugPrint("Subscription successfully being read!");
          return map;
        } else {
          showSnackBar(context, "has not being read", type: SnackType.error);
          return map;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace, title: "BackendServices-readSubs error");
    }
    return map;
  }

  ///read Notifications from host
  Future<List<Notice?>?> readNotice(context,
      {String appName = kAppName, int timeout = 20}) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$hostUrl/notification/read_notice.php"),
        body: {
          "app-name": appName,
          "platform": Platform.executable,
          "version":
              Provider.of<UserProvider>(context, listen: false).appVersion,
        },
      ).timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        // print(res.body);
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List<Notice> notices = (backData["notification-list"] as List)
              .map((e) => Notice().fromJson(e["notice_object"]))
              .toList();

          debugPrint("notifications successfully being read!");
          return notices;
        } else {
          debugPrint("error in backendServices.readNotice php api error error");
          return null;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(
        null,
        e,
        stacktrace: stacktrace,
        title: "BackendServices-readSubs error",
      );
    }
    return null;
  }

  ///get the options from mysql like the price of the app
  Future readOption(String optionName) async {
    final res = await http.post(Uri.parse("$hostUrl/user/read_options.php"),
        body: {"option_name": optionName});
    if (res.statusCode == 200) {
      var backData = jsonDecode(res.body);
      if (backData["success"] == true) {
        //return different value(price) for each platform
        if (Platform.isWindows) {
          return backData["values"]["option_json"];
        } else {
          return backData["values"]["option_json2"] ??
              backData["values"]["option_json"];
        }
      }
    }
  }

  ///read purchase plan
  Future<List<Plan>?> readPlans() async {
    try {
      Device device = await getDeviceInfo();
      final res = await http.post(Uri.parse("$hostUrl/payment/read_plans.php"),
          body: {"appName": kAppName, "platform": device.platform});
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List<Plan> planList = (backData["plans"] as List)
              .map((e) => Plan().fromMap(e))
              .toList();
          return planList;
        } else {
          ErrorHandler.errorManger(
            null,
            null,
            errorText: backData["message"],
            stacktrace: backData["error"],
            title: "BackendServices-readPlans error",
          );
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(
        null,
        e,
        stacktrace: stacktrace,
        title: "BackendServices-readPlans error",
      );
    }
    return null;
  }

  ///read coupon
  Future<Map?> readCoupon(String code, int price) async {
    try {
      Device device = await getDeviceInfo();
      final res = await http.post(Uri.parse("$hostUrl/payment/read_coupon.php"),
          body: {
            "appName": kAppName,
            "platform": device.platform,
            "code": code
          });
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          Map coupon = backData["coupon"];
          int count = int.parse(coupon["count"]);
          int? limitPrice = int.tryParse(coupon["limit"] ?? "a");
          DateTime? endDate = DateTime.tryParse(coupon["end_date"] ?? "0");
          if (count > 0 &&
              (endDate == null || endDate.isAfter(DateTime.now()))) {
            if (limitPrice == null || price > limitPrice) {
              return {
                "success": true,
                "coupon": coupon,
                "message": "کد تخفیف در دسترس است"
              };
            } else {
              return {
                "success": false,
                "message":
                    "این کد تخفیف برای خرید های بالا تر از ${addSeparator(limitPrice)} قابل دسترس است"
              };
            }
          } else if (count <= 0 ||
              (endDate != null && endDate.isBefore(DateTime.now()))) {
            return {"success": false, "message": "کد تخفیف منقضی شده است"};
          }
        } else {
          ErrorHandler.errorManger(
            null,
            null,
            errorText: backData["message"],
            stacktrace: backData["error"],
            title: "BackendServices-readCoupon php error",
          );
          return {"success": false, "message": backData["message"]};
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(
        null,
        e,
        stacktrace: stacktrace,
        title: "BackendServices-readCoupon error",
      );
    }
    return null;
  }

  ///update coupon
  Future<Map?> updateCoupon(String code, int? count) async {
    try {
      Device device = await getDeviceInfo();
      final res = await http
          .post(Uri.parse("$hostUrl/payment/update_coupon.php"), body: {
        "appName": kAppName,
        "platform": device.platform,
        "code": code,
        "count": count?.toString()
      });
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          String count = backData["count"];
          return {"count": count, "message": ""};
        } else {
          ErrorHandler.errorManger(
            null,
            null,
            errorText: backData["message"],
            stacktrace: backData["error"],
            title: "BackendServices-updateCoupon php error",
          );
          return {"message": backData["message"]};
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(
        null,
        e,
        stacktrace: stacktrace,
        title: "BackendServices-readCoupon error",
      );
    }
    return null;
  }

  ///fetch subscription
  Future<void> fetchSubs(context) async {
    try {
      Subscription? storedSubs = HiveBoxes.getShopInfo().getAt(0)?.subscription;
      if (storedSubs != null) {
        Map readSubs = await BackendServices.readSubs(context, storedSubs.phone,
            subsId: storedSubs.id.toString());
        if (readSubs["success"] == true) {
          Provider.of<UserProvider>(context, listen: false)
            ..setSubscription(readSubs["subs"])
            ..setUserLevel(readSubs["subs"]?.level ?? 0);
          if (readSubs["subs"] != null) {
            await updateFetchDate(context, readSubs["subs"]);
          }
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(null, e,
          stacktrace: stacktrace,
          title: "BackendServices fetchSubs function error");
    }
  }

  ///
  static Future<void> updateFetchDate(context, Subscription subs) async {
    DateTime startDate = DateTime.now();
    try {
      //get online date with ntp package
      int offset = await NTP
          .getNtpOffset(lookUpAddress: 'time.cloudflare.com')
          .timeout(const Duration(seconds: 5));
      print(
          'NTP DateTime offset align: ${startDate.add(Duration(milliseconds: offset))}');
      //we save the date of this fetch
      subs.fetchDate = startDate.add(Duration(milliseconds: offset));
      subs.startDate ??= startDate.add(Duration(milliseconds: offset));
      if (subs.endDate != null &&
          subs.fetchDate != null &&
          subs.endDate!.isBefore(subs.fetchDate!)) {
        subs.level = 0;
      } else if (subs.level == 0 &&
          subs.endDate != null &&
          subs.fetchDate != null &&
          subs.endDate!.isAfter(subs.fetchDate!)) {
        subs.level = 1;
      }
      BackendServices.createSubs(context, subs: subs).then((isCreated) {
        if (isCreated != null) {
          debugPrint("fetch date has been updated after fetch subscription");
        } else {
          debugPrint(
              "fetch date has not been updated after fetch subscription");
        }
      });
    } catch (e) {
      subs.fetchDate = startDate;
      subs.startDate ??= startDate;
      ErrorHandler.errorManger(null, e,
          title: "backendServices updateFetchDate error");
    }
  }

  ///get server time
  static Future<DateTime> getServerTime() async {
    try {
      final res = await http.get(Uri.parse("$hostUrl/time.php"));
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          return DateTime.parse(backData["time"]);
        } else {
          ErrorHandler.errorManger(null, backData["error"],
              title: "backendServices getServerTime  time.php error");
          return DateTime.now();
        }
      } else {
        ErrorHandler.errorManger(null, res.statusCode,
            title:
                "backendServices getServerTime connection to time.php error");
        return DateTime.now();
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(null, e,
          route: stacktrace.toString(),
          title: "backendServices getServerTime error");
      return DateTime.now();
    }
  }
}
