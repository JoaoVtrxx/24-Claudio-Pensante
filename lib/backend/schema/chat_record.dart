import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatRecord extends FirestoreRecord {
  ChatRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "mensagem" field.
  String? _mensagem;
  String get mensagem => _mensagem ?? '';
  bool hasMensagem() => _mensagem != null;

  // "enviado_do_usuario" field.
  bool? _enviadoDoUsuario;
  bool get enviadoDoUsuario => _enviadoDoUsuario ?? false;
  bool hasEnviadoDoUsuario() => _enviadoDoUsuario != null;

  // "data_hora" field.
  DateTime? _dataHora;
  DateTime? get dataHora => _dataHora;
  bool hasDataHora() => _dataHora != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _mensagem = snapshotData['mensagem'] as String?;
    _enviadoDoUsuario = snapshotData['enviado_do_usuario'] as bool?;
    _dataHora = snapshotData['data_hora'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('chat')
          : FirebaseFirestore.instance.collectionGroup('chat');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('chat').doc(id);

  static Stream<ChatRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatRecord.fromSnapshot(s));

  static Future<ChatRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatRecord.fromSnapshot(s));

  static ChatRecord fromSnapshot(DocumentSnapshot snapshot) => ChatRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatRecordData({
  String? mensagem,
  bool? enviadoDoUsuario,
  DateTime? dataHora,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'mensagem': mensagem,
      'enviado_do_usuario': enviadoDoUsuario,
      'data_hora': dataHora,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatRecordDocumentEquality implements Equality<ChatRecord> {
  const ChatRecordDocumentEquality();

  @override
  bool equals(ChatRecord? e1, ChatRecord? e2) {
    return e1?.mensagem == e2?.mensagem &&
        e1?.enviadoDoUsuario == e2?.enviadoDoUsuario &&
        e1?.dataHora == e2?.dataHora;
  }

  @override
  int hash(ChatRecord? e) => const ListEquality()
      .hash([e?.mensagem, e?.enviadoDoUsuario, e?.dataHora]);

  @override
  bool isValidKey(Object? o) => o is ChatRecord;
}
