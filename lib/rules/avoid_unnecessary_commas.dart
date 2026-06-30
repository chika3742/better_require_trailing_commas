import 'package:analysis_server_plugin/edit/change_builder/change_builder.dart';
import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analysis_server_plugin/edit/fix/fix.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/line_info.dart';

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
      ..addObjectPattern(this, visitor)
      ..addListPattern(this, visitor)
      ..addMapPattern(this, visitor)
      ..addBlockEnumBody(this, visitor);
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
      closingToken: node.rightDelimiter ?? node.rightParenthesis,
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
    if (node.fields.length <= 1) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitRecordPattern(RecordPattern node) {
    if (node.fields.length <= 1) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitRecordTypeAnnotation(RecordTypeAnnotation node) {
    if ((node.namedFields == null && node.positionalFields.length <= 1)) return;
    final fields = (node.namedFields?.fields ?? node.positionalFields);
    _checkTrailingComma(
      closingToken: node.namedFields?.rightBracket ?? node.rightParenthesis,
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
  void visitObjectPattern(ObjectPattern node) {
    if (node.fields.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightParenthesis,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitListPattern(ListPattern node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightBracket,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitMapPattern(MapPattern node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      closingToken: node.rightBracket,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitBlockEnumBody(BlockEnumBody node) {
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
    var lastToken = lastNode.endToken;

    // Early exit if trailing comma is not present.
    if (closingToken.previous?.type != TokenType.COMMA) return;

    // comma token and closing token are on different lines
    if (!_isSameLine(lastToken, closingToken)) {
      return;
    }

    rule.reportAtToken(closingToken.previous!);
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
    Future<void> removeComma(Token token) {
      if (token.type != .COMMA) return Future.value();
      return builder.addDartFileEdit(file, (builder) {
        builder.addDeletion(token.sourceRange);
      });
    }

    switch (node) {
      case ArgumentList(:final rightParenthesis):
        await removeComma(rightParenthesis.previous!);
      case AssertInitializer(:final rightParenthesis):
        await removeComma(rightParenthesis.previous!);
      case AssertStatement(:final rightParenthesis):
        await removeComma(rightParenthesis.previous!);
      case FormalParameterList(:final rightDelimiter, :final rightParenthesis):
        await removeComma((rightDelimiter ?? rightParenthesis).previous!);
      case ListLiteral(:final rightBracket):
        await removeComma(rightBracket.previous!);
      case SetOrMapLiteral(:final rightBracket):
        await removeComma(rightBracket.previous!);
      case RecordLiteral(:final rightParenthesis):
        await removeComma(rightParenthesis.previous!);
      case RecordPattern(:final rightParenthesis):
        await removeComma(rightParenthesis.previous!);
      case RecordTypeAnnotation(:final namedFields, :final rightParenthesis):
        await removeComma(
          (namedFields?.rightBracket ?? rightParenthesis).previous!,
        );
      case SwitchExpression(:final rightBracket):
        await removeComma(rightBracket.previous!);
      case ObjectPattern(:final rightParenthesis):
        await removeComma(rightParenthesis.previous!);
      case ListPattern(:final rightBracket):
        await removeComma(rightBracket.previous!);
      case MapPattern(:final rightBracket):
        await removeComma(rightBracket.previous!);
      case BlockEnumBody(:final semicolon, :final rightBracket):
        await removeComma((semicolon ?? rightBracket).previous!);
    }
  }
}
