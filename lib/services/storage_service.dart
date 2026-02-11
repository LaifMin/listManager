import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_list.dart';

class StorageService {
  static const String _key = 'task_lists';

  static Future<List<TaskList>> loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => TaskList.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveLists(List<TaskList> lists) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(lists.map((l) => l.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
