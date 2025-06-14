import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _conversationId = '';
  String get conversationId => _conversationId;
  set conversationId(String value) {
    _conversationId = value;
  }

  String _userMessage = '';
  String get userMessage => _userMessage;
  set userMessage(String value) {
    _userMessage = value;
  }

  String _aiResponse = '';
  String get aiResponse => _aiResponse;
  set aiResponse(String value) {
    _aiResponse = value;
  }
}
