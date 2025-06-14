import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'refeicao_model.dart';
export 'refeicao_model.dart';

class RefeicaoWidget extends StatefulWidget {
  const RefeicaoWidget({
    super.key,
    required this.refeicao,
    required this.nomeRefeicao,
    required this.refDiario,
  });

  final RefeicaoStruct? refeicao;
  final String? nomeRefeicao;
  final DocumentReference? refDiario;

  @override
  State<RefeicaoWidget> createState() => _RefeicaoWidgetState();
}

class _RefeicaoWidgetState extends State<RefeicaoWidget>
    with TickerProviderStateMixin {
  late RefeicaoModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RefeicaoModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 70.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: Offset(40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 180.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: Offset(20.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.8, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x1F000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryBackground,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 16.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 12.0, 12.0, 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              widget!.nomeRefeicao,
                              'nome refeicao',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation1']!),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: Text(
                              'Abaixo estão os alimentos sugeridos',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation2']!),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        shape: BoxShape.circle,
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.checklist_rtl_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation2']!),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  final ingredientes =
                      widget!.refeicao?.ingredientes?.toList() ?? [];

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: ingredientes.length,
                    itemBuilder: (context, ingredientesIndex) {
                      final ingredientesItem = ingredientes[ingredientesIndex];
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Text(
                                          ingredientesItem.nome,
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Text(
                                          ingredientesItem.calorias.toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        unselectedWidgetColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                      ),
                                      child: Checkbox(
                                        value: _model.checkboxValueMap[
                                                ingredientesItem] ??=
                                            ingredientesItem.realizado,
                                        onChanged: (newValue) async {
                                          safeSetState(() => _model
                                                  .checkboxValueMap[
                                              ingredientesItem] = newValue!);
                                          if (newValue!) {
                                            if (widget!.nomeRefeicao ==
                                                'Café da manhã') {
                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                cafe: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayRemove([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          ingredientesItem,
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));

                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                cafe: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayUnion([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          IngredienteStruct(
                                                            nome:
                                                                ingredientesItem
                                                                    .nome,
                                                            calorias:
                                                                ingredientesItem
                                                                    .calorias,
                                                            realizado: _model
                                                                    .checkboxValueMap[
                                                                ingredientesItem],
                                                          ),
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));
                                            } else if (widget!.nomeRefeicao ==
                                                'Almoço') {
                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                almoco: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayRemove([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          ingredientesItem,
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));

                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                almoco: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayUnion([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          IngredienteStruct(
                                                            nome:
                                                                ingredientesItem
                                                                    .nome,
                                                            calorias:
                                                                ingredientesItem
                                                                    .calorias,
                                                            realizado: _model
                                                                    .checkboxValueMap[
                                                                ingredientesItem],
                                                          ),
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));
                                            } else {
                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                janta: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayRemove([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          ingredientesItem,
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));

                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                janta: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayUnion([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          IngredienteStruct(
                                                            nome:
                                                                ingredientesItem
                                                                    .nome,
                                                            calorias:
                                                                ingredientesItem
                                                                    .calorias,
                                                            realizado: _model
                                                                    .checkboxValueMap[
                                                                ingredientesItem],
                                                          ),
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));
                                            }

                                            await widget!.refDiario!.update({
                                              ...mapToFirestore(
                                                {
                                                  'calorias_ingeridas':
                                                      FieldValue.increment(
                                                          ingredientesItem
                                                              .calorias),
                                                },
                                              ),
                                            });
                                          } else {
                                            if (widget!.nomeRefeicao ==
                                                'Café da manhã') {
                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                cafe: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayRemove([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          ingredientesItem,
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));

                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                cafe: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayUnion([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          IngredienteStruct(
                                                            nome:
                                                                ingredientesItem
                                                                    .nome,
                                                            calorias:
                                                                ingredientesItem
                                                                    .calorias,
                                                            realizado: _model
                                                                    .checkboxValueMap[
                                                                ingredientesItem],
                                                          ),
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));
                                            } else if (widget!.nomeRefeicao ==
                                                'Almoço') {
                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                almoco: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayRemove([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          ingredientesItem,
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));

                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                almoco: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayUnion([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          IngredienteStruct(
                                                            nome:
                                                                ingredientesItem
                                                                    .nome,
                                                            calorias:
                                                                ingredientesItem
                                                                    .calorias,
                                                            realizado: _model
                                                                    .checkboxValueMap[
                                                                ingredientesItem],
                                                          ),
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));
                                            } else {
                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                janta: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayRemove([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          ingredientesItem,
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));

                                              await widget!.refDiario!.update(
                                                  createDiariosRecordData(
                                                janta: createRefeicaoStruct(
                                                  fieldValues: {
                                                    'ingredientes':
                                                        FieldValue.arrayUnion([
                                                      getIngredienteFirestoreData(
                                                        updateIngredienteStruct(
                                                          IngredienteStruct(
                                                            nome:
                                                                ingredientesItem
                                                                    .nome,
                                                            calorias:
                                                                ingredientesItem
                                                                    .calorias,
                                                            realizado: _model
                                                                    .checkboxValueMap[
                                                                ingredientesItem],
                                                          ),
                                                          clearUnsetFields:
                                                              false,
                                                        ),
                                                        true,
                                                      )
                                                    ]),
                                                  },
                                                  clearUnsetFields: false,
                                                ),
                                              ));
                                            }
                                          }
                                        },
                                        side: (FlutterFlowTheme.of(context)
                                                    .alternate !=
                                                null)
                                            ? BorderSide(
                                                width: 2,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate!,
                                              )
                                            : null,
                                        activeColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        checkColor:
                                            FlutterFlowTheme.of(context).info,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                            indent: 12.0,
                            endIndent: 12.0,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
    );
  }
}
