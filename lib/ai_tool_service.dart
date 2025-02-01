import 'dart:convert';
import 'package:flutter/services.dart';
import 'ai_tool_model.dart';

class AiToolService {
  Future<List<AiTool>> loadAiTools() async {
    String jsonString = await rootBundle.loadString('assets/Ai-tools.json');
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => AiTool.fromJson(json)).toList();
  }
}
