import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DiariosRecord extends FirestoreRecord {
  DiariosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "data" field.
  DateTime? _data;
  DateTime? get data => _data;
  bool hasData() => _data != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "almoco" field.
  RefeicaoStruct? _almoco;
  RefeicaoStruct get almoco => _almoco ?? RefeicaoStruct();
  bool hasAlmoco() => _almoco != null;

  // "cafe" field.
  RefeicaoStruct? _cafe;
  RefeicaoStruct get cafe => _cafe ?? RefeicaoStruct();
  bool hasCafe() => _cafe != null;

  // "janta" field.
  RefeicaoStruct? _janta;
  RefeicaoStruct get janta => _janta ?? RefeicaoStruct();
  bool hasJanta() => _janta != null;

  // "calorias_ingeridas" field.
  int? _caloriasIngeridas;
  int get caloriasIngeridas => _caloriasIngeridas ?? 0;
  bool hasCaloriasIngeridas() => _caloriasIngeridas != null;

  void _initializeFields() {
    _userId = snapshotData['userId'] as DocumentReference?;
    _data = snapshotData['data'] as DateTime?;
    _id = snapshotData['id'] as String?;
    _almoco = snapshotData['almoco'] is RefeicaoStruct
        ? snapshotData['almoco']
        : RefeicaoStruct.maybeFromMap(snapshotData['almoco']);
    _cafe = snapshotData['cafe'] is RefeicaoStruct
        ? snapshotData['cafe']
        : RefeicaoStruct.maybeFromMap(snapshotData['cafe']);
    _janta = snapshotData['janta'] is RefeicaoStruct
        ? snapshotData['janta']
        : RefeicaoStruct.maybeFromMap(snapshotData['janta']);
    _caloriasIngeridas = castToType<int>(snapshotData['calorias_ingeridas']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('diarios');

  static Stream<DiariosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DiariosRecord.fromSnapshot(s));

  static Future<DiariosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DiariosRecord.fromSnapshot(s));

  static DiariosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DiariosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DiariosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DiariosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DiariosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DiariosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDiariosRecordData({
  DocumentReference? userId,
  DateTime? data,
  String? id,
  RefeicaoStruct? almoco,
  RefeicaoStruct? cafe,
  RefeicaoStruct? janta,
  int? caloriasIngeridas,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userId': userId,
      'data': data,
      'id': id,
      'almoco': RefeicaoStruct().toMap(),
      'cafe': RefeicaoStruct().toMap(),
      'janta': RefeicaoStruct().toMap(),
      'calorias_ingeridas': caloriasIngeridas,
    }.withoutNulls,
  );

  // Handle nested data for "almoco" field.
  addRefeicaoStructData(firestoreData, almoco, 'almoco');

  // Handle nested data for "cafe" field.
  addRefeicaoStructData(firestoreData, cafe, 'cafe');

  // Handle nested data for "janta" field.
  addRefeicaoStructData(firestoreData, janta, 'janta');

  return firestoreData;
}

class DiariosRecordDocumentEquality implements Equality<DiariosRecord> {
  const DiariosRecordDocumentEquality();

  @override
  bool equals(DiariosRecord? e1, DiariosRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.data == e2?.data &&
        e1?.id == e2?.id &&
        e1?.almoco == e2?.almoco &&
        e1?.cafe == e2?.cafe &&
        e1?.janta == e2?.janta &&
        e1?.caloriasIngeridas == e2?.caloriasIngeridas;
  }

  @override
  int hash(DiariosRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.data,
        e?.id,
        e?.almoco,
        e?.cafe,
        e?.janta,
        e?.caloriasIngeridas
      ]);

  @override
  bool isValidKey(Object? o) => o is DiariosRecord;
}
