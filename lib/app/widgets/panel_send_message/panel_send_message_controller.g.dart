// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_send_message_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PanelSendMessageController on _PanelSendMessageControllerBase, Store {
  final _$inputEnabledAtom =
      Atom(name: '_PanelSendMessageControllerBase.inputEnabled');

  @override
  bool get inputEnabled {
    _$inputEnabledAtom.reportRead();
    return super.inputEnabled;
  }

  @override
  set inputEnabled(bool value) {
    _$inputEnabledAtom.reportWrite(value, super.inputEnabled, () {
      super.inputEnabled = value;
    });
  }

  @override
  String toString() {
    return '''
inputEnabled: ${inputEnabled}
    ''';
  }
}
