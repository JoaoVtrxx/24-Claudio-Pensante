// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class IngredienteStruct extends FFFirebaseStruct {
  IngredienteStruct({
    String? nome,
    int? calorias,
    bool? realizado,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _calorias = calorias,
        _realizado = realizado,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "calorias" field.
  int? _calorias;
  int get calorias => _calorias ?? 0;
  set calorias(int? val) => _calorias = val;

  void incrementCalorias(int amount) => calorias = calorias + amount;

  bool hasCalorias() => _calorias != null;

  // "realizado" field.
  bool? _realizado;
  bool get realizado => _realizado ?? false;
  set realizado(bool? val) => _realizado = val;

  bool hasRealizado() => _realizado != null;

  static IngredienteStruct fromMap(Map<String, dynamic> data) =>
      IngredienteStruct(
        nome: data['nome'] as String?,
        calorias: castToType<int>(data['calorias']),
        realizado: data['realizado'] as bool?,
      );

  static IngredienteStruct? maybeFromMap(dynamic data) => data is Map
      ? IngredienteStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'calorias': _calorias,
        'realizado': _realizado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'calorias': serializeParam(
          _calorias,
          ParamType.int,
        ),
        'realizado': serializeParam(
          _realizado,
          ParamType.bool,
        ),
      }.withoutNulls;

  static IngredienteStruct fromSerializableMap(Map<String, dynamic> data) =>
      IngredienteStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        calorias: deserializeParam(
          data['calorias'],
          ParamType.int,
          false,
        ),
        realizado: deserializeParam(
          data['realizado'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'IngredienteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is IngredienteStruct &&
        nome == other.nome &&
        calorias == other.calorias &&
        realizado == other.realizado;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, calorias, realizado]);
}

IngredienteStruct createIngredienteStruct({
  String? nome,
  int? calorias,
  bool? realizado,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    IngredienteStruct(
      nome: nome,
      calorias: calorias,
      realizado: realizado,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

IngredienteStruct? updateIngredienteStruct(
  IngredienteStruct? ingrediente, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ingrediente
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addIngredienteStructData(
  Map<String, dynamic> firestoreData,
  IngredienteStruct? ingrediente,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ingrediente == null) {
    return;
  }
  if (ingrediente.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && ingrediente.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ingredienteData =
      getIngredienteFirestoreData(ingrediente, forFieldValue);
  final nestedData =
      ingredienteData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ingrediente.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getIngredienteFirestoreData(
  IngredienteStruct? ingrediente, [
  bool forFieldValue = false,
]) {
  if (ingrediente == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ingrediente.toMap());

  // Add any Firestore field values
  ingrediente.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getIngredienteListFirestoreData(
  List<IngredienteStruct>? ingredientes,
) =>
    ingredientes?.map((e) => getIngredienteFirestoreData(e, true)).toList() ??
    [];
