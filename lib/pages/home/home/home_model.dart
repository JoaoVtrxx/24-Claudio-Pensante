import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/refeicao/refeicao_widget.dart';
import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  int diaSelecionado = 0;

  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // Model for refeicao component.
  late RefeicaoModel refeicaoModel1;
  // Model for refeicao component.
  late RefeicaoModel refeicaoModel2;
  // Model for refeicao component.
  late RefeicaoModel refeicaoModel3;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    refeicaoModel1 = createModel(context, () => RefeicaoModel());
    refeicaoModel2 = createModel(context, () => RefeicaoModel());
    refeicaoModel3 = createModel(context, () => RefeicaoModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    refeicaoModel1.dispose();
    refeicaoModel2.dispose();
    refeicaoModel3.dispose();
  }
}
