import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PesosRecord extends FirestoreRecord {
  PesosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "peso" field.
  double? _peso;
  double get peso => _peso ?? 0.0;
  bool hasPeso() => _peso != null;

  // "data" field.
  DateTime? _data;
  DateTime? get data => _data;
  bool hasData() => _data != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _peso = castToType<double>(snapshotData['peso']);
    _data = snapshotData['data'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('pesos')
          : FirebaseFirestore.instance.collectionGroup('pesos');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('pesos').doc(id);

  static Stream<PesosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PesosRecord.fromSnapshot(s));

  static Future<PesosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PesosRecord.fromSnapshot(s));

  static PesosRecord fromSnapshot(DocumentSnapshot snapshot) => PesosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PesosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PesosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PesosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PesosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPesosRecordData({
  double? peso,
  DateTime? data,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'peso': peso,
      'data': data,
    }.withoutNulls,
  );

  return firestoreData;
}

class PesosRecordDocumentEquality implements Equality<PesosRecord> {
  const PesosRecordDocumentEquality();

  @override
  bool equals(PesosRecord? e1, PesosRecord? e2) {
    return e1?.peso == e2?.peso && e1?.data == e2?.data;
  }

  @override
  int hash(PesosRecord? e) => const ListEquality().hash([e?.peso, e?.data]);

  @override
  bool isValidKey(Object? o) => o is PesosRecord;
}
