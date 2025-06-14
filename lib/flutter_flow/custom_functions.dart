import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

int taxaBasal(
  int idade,
  int altura,
  int peso,
  bool masculino,
) {
  if (masculino) {
    return (10 * peso + 6.25 * altura - 5 * idade + 5).toInt();
  } else {
    return (10 * peso + 6.25 * altura - 5 * idade - 161).toInt();
  }
}
