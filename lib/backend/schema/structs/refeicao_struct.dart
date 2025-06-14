// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RefeicaoStruct extends FFFirebaseStruct {
  RefeicaoStruct({
    int? calorias,
    List<IngredienteStruct>? ingredientes,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _calorias = calorias,
        _ingredientes = ingredientes,
        super(firestoreUtilData);

  // "calorias" field.
  int? _calorias;
  int get calorias => _calorias ?? 0;
  set calorias(int? val) => _calorias = val;

  void incrementCalorias(int amount) => calorias = calorias + amount;

  bool hasCalorias() => _calorias != null;

  // "ingredientes" field.
  List<IngredienteStruct>? _ingredientes;
  List<IngredienteStruct> get ingredientes => _ingredientes ?? const [];
  set ingredientes(List<IngredienteStruct>? val) => _ingredientes = val;

  void updateIngredientes(Function(List<IngredienteStruct>) updateFn) {
    updateFn(_ingredientes ??= []);
  }

  bool hasIngredientes() => _ingredientes != null;

  static RefeicaoStruct fromMap(Map<String, dynamic> data) => RefeicaoStruct(
        calorias: castToType<int>(data['calorias']),
        ingredientes: getStructList(
          data['ingredientes'],
          IngredienteStruct.fromMap,
        ),
      );

  static RefeicaoStruct? maybeFromMap(dynamic data) =>
      data is Map ? RefeicaoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'calorias': _calorias,
        'ingredientes': _ingredientes?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'calorias': serializeParam(
          _calorias,
          ParamType.int,
        ),
        'ingredientes': serializeParam(
          _ingredientes,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static RefeicaoStruct fromSerializableMap(Map<String, dynamic> data) =>
      RefeicaoStruct(
        calorias: deserializeParam(
          data['calorias'],
          ParamType.int,
          false,
        ),
        ingredientes: deserializeStructParam<IngredienteStruct>(
          data['ingredientes'],
          ParamType.DataStruct,
          true,
          structBuilder: IngredienteStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RefeicaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RefeicaoStruct &&
        calorias == other.calorias &&
        listEquality.equals(ingredientes, other.ingredientes);
  }

  @override
  int get hashCode => const ListEquality().hash([calorias, ingredientes]);
}

RefeicaoStruct createRefeicaoStruct({
  int? calorias,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RefeicaoStruct(
      calorias: calorias,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RefeicaoStruct? updateRefeicaoStruct(
  RefeicaoStruct? refeicao, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    refeicao
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRefeicaoStructData(
  Map<String, dynamic> firestoreData,
  RefeicaoStruct? refeicao,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (refeicao == null) {
    return;
  }
  if (refeicao.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && refeicao.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final refeicaoData = getRefeicaoFirestoreData(refeicao, forFieldValue);
  final nestedData = refeicaoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = refeicao.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRefeicaoFirestoreData(
  RefeicaoStruct? refeicao, [
  bool forFieldValue = false,
]) {
  if (refeicao == null) {
    return {};
  }
  final firestoreData = mapToFirestore(refeicao.toMap());

  // Add any Firestore field values
  refeicao.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRefeicaoListFirestoreData(
  List<RefeicaoStruct>? refeicaos,
) =>
    refeicaos?.map((e) => getRefeicaoFirestoreData(e, true)).toList() ?? [];
