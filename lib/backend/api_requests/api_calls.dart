import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class DifyChatCall {
  static Future<ApiCallResponse> call({
    String? conversationId = '',
    String? userId = '',
    String? userMessage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "inputs": {},
  "query": "${escapeStringForJson(userMessage)}",
  "response_mode": "streaming",
  "conversation_id": "${escapeStringForJson(conversationId)}",
  "user": "${escapeStringForJson(userId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'DifyChat ',
      apiUrl: 'https://api.dify.ai/v1/chat-messages',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer app-lDfYz5Zi2wTUQbzDUGoQzZzQ',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? conversationid(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.conversation_id''',
      ));
  static String? resposta(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.answer''',
      ));
}

class DifyCall {
  static Future<ApiCallResponse> call({
    String? conversationId = '',
    String? userId = '',
    String? userMessage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "query": "${escapeStringForJson(userMessage)}",
  "conversation_id": "${escapeStringForJson(conversationId)}",
  "user": "${escapeStringForJson(userId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'dify',
      apiUrl:
          'https://us-central1-code-race-2aa77.cloudfunctions.net/difyProxy',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic conversationid(dynamic response) => getJsonField(
        response,
        r'''$.conversation_id''',
      );
  static dynamic answer(dynamic response) => getJsonField(
        response,
        r'''$.answer''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
