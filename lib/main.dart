import 'dart:async';

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:better_require_trailing_commas/rules/avoid_unnecessary_commas.dart';

import 'rules/better_require_trailing_commas.dart';

final plugin = _BetterRequireTrailingCommasPlugin();

class _BetterRequireTrailingCommasPlugin extends Plugin {
  @override
  String get name => "Better Require Trailing Commas";

  @override
  FutureOr<void> register(PluginRegistry registry) {
    registry
      ..registerWarningRule(BetterRequireTrailingCommasRule())
      ..registerFixForRule(
        BetterRequireTrailingCommasRule.code,
        AddTrailingCommaFix.new,
      )
      ..registerWarningRule(AvoidUnnecessaryCommasRule())
      ..registerFixForRule(
        AvoidUnnecessaryCommasRule.code,
        RemoveUnnecessaryTrailingCommaFix.new,
      );
  }
}
