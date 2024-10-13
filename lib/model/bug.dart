import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'bug.g.dart';

@HiveType(typeId: 10)
class Bug extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? errorText;
  @HiveField(2)
  int count = 1;
  @HiveField(3)
  String? directory;
  @HiveField(4)
  late DateTime bugDate;
  @HiveField(5)
  late String bugId;
  @HiveField(6)
  String? stacktrace;
  @HiveField(7)
  String? device;
  @HiveField(8)
  String? subscriber;
  @HiveField(9)
  String? appVersion;

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "errorText": this.errorText,
      "count": this.count,
      "directory": this.directory,
      "bugDate": this.bugDate.toIso8601String(),
      "bugId": this.bugId,
      "stacktrace": this.stacktrace,
      "device": this.device,
      "subscriber": this.subscriber,
      "appVersion": this.appVersion,
    };
  }

  Bug fromMap(Map<String, dynamic> json) {
    Bug bug = Bug()
      ..title = json["title"] ?? ""
      ..errorText = json["errorText"]
      ..count = int.tryParse(json["count"] ?? "1") ?? 1
      ..directory = json["directory"]
      ..bugDate = DateTime.parse(json["bugDate"])
      ..bugId = json["bugId"] ?? Uuid().v1()
      ..stacktrace = json["stacktrace"]
      ..device = json["device"]
      ..appVersion = json["appVersion"]
      ..subscriber = json["subscriber"];
    return bug;
  }
//
String toJson()=>json.encode(toMap());
Bug fromJson(String source)=>fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs
