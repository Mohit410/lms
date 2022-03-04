import 'dart:convert';

import 'package:http/http.dart';
import 'package:lms/utils/constants.dart';

class NotificationServices {
  static Future<Response> sendNotification(
      String heading, String content, List<String> tokenIds) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": appId,
        "include_player_ids": tokenIds,
        "android_accent_color": "FF9976D2",
        "headings": {"en": heading},
        "contents": {"en": content},
      }),
    );
  }
}
