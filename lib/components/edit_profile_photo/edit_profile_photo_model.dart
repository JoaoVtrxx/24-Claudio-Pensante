import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'edit_profile_photo_widget.dart' show EditProfilePhotoWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProfilePhotoModel extends FlutterFlowModel<EditProfilePhotoWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadData5mq = false;
  FFUploadedFile uploadedLocalFile_uploadData5mq =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData5mq = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
