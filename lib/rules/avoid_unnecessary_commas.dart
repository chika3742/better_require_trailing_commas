import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

class AvoidUnnecessaryCommasRule extends AnalysisRule {
  static const code = LintCode(
    "avoid_unnecessary_commas",
    "Unnecessary trailing comma",
    correctionMessage: "Try removing a trailing comma.",
  );

  AvoidUnnecessaryCommasRule()
      : super(
    name: "avoid_unnecessary_commas",
    description: "Enforces not adding unnecessary trailing commas.",
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
    final visitor = _AvoidUnnecessaryCommasVisitor(this, context);

    registry
      ..addCompilationUnit(this, visitor)
      ..addArgumentList(this, visitor)
      ..addAssertInitializer(this, visitor)
      ..addAssertStatement(this, visitor)
      ..addFormalParameterList(this, visitor)
      ..addListLiteral(this, visitor)
      ..addSetOrMapLiteral(this, visitor)
      ..addRecordLiteral(this, visitor)
      ..addRecordPattern(this, visitor)
      ..addRecordTypeAnnotation(this, visitor)
      ..addSwitchExpression(this, visitor)
      ..addEnumBody(this, visitor);
  }
}

class _AvoidUnnecessaryCommasVisitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  _AvoidUnnecessaryCommasVisitor(this.rule, this.context);

  late LineInfo _lineInfo;

  @override
  void visitCompilationUnit(CompilationUnit node) => _lineInfo = node.lineInfo;

  @override
  void visitArgumentList(ArgumentList node) {
    if (node.arguments.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.arguments.last,
    );
  }

  @override
  void visitAssertInitializer(AssertInitializer node) {
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.message ?? node.condition,
    );
  }

  @override
  void visitAssertStatement(AssertStatement node) {
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.message ?? node.condition,
    );
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    if (node.parameters.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.parameters.last,
    );
  }

  @override
  void visitListLiteral(ListLiteral node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightBracket,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightBracket,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitRecordLiteral(RecordLiteral node) {
    if (node.fields.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitRecordPattern(RecordPattern node) {
    if (node.fields.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitRecordTypeAnnotation(RecordTypeAnnotation node) {
    if (node.namedFields == null && node.positionalFields.isEmpty) return;
    final fields = (node.namedFields?.fields ?? node.positionalFields);
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: fields.last,
    );
  }

  @override
  void visitSwitchExpression(SwitchExpression node) {
    if (node.cases.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightBracket,
      lastNode: node.cases.last,
    );
  }

  @override
  void visitEnumBody(EnumBody node) {
    if (node.constants.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.semicolon ?? node.rightBracket,
      lastNode: node.constants.last,
    );
  }

  void _checkTrailingComma({
    required Token closingToken,
    required AstNode lastNode,
  }) {
    var lastToken = lastNode.endToken.next;

    // Early exit if trailing comma is not present.
    if (lastToken?.type != TokenType.COMMA) return;

    // comma token and closing token are on different lines
    if (!_isSameLine(lastToken!, closingToken)) {
      return;
    }

    rule.reportAtToken(lastToken);
  }

  bool _isSameLine(Token token1, Token token2) =>
      _lineInfo.getLocation(token1.offset).lineNumber ==
          _lineInfo.getLocation(token2.end).lineNumber;
}

class RemoveUnnecessaryTrailingCommaFix extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    "brtc.fix.removeUnnecessaryTrailingComma",
    DartFixKindPriority.standard,
    "Remove a trailing comma",
  );

  RemoveUnnecessaryTrailingCommaFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    await builder.addDartFileEdit(file, (builder) {
      builder.addDeletion(SourceRange(token.offset, 1));
    });
  }
}
