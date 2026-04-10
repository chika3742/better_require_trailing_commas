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
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

class BetterRequireTrailingCommasRule extends AnalysisRule {
  static const code = LintCode(
    "better_require_trailing_commas",
    "Missing trailing comma",
    correctionMessage: "Try adding a trailing comma.",
  );

  BetterRequireTrailingCommasRule()
      : super(
    name: "better_require_trailing_commas",
    description: "Enforces trailing commas.",
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
      RuleVisitorRegistry registry,
      RuleContext context,
      ) {
    final visitor = _RequireTrailingCommasVisitor(this, context);

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
      ..addMapPattern(this, visitor)
      ..addListPattern(this, visitor)
      ..addBlockEnumBody(this, visitor);
  }
}

class _RequireTrailingCommasVisitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  _RequireTrailingCommasVisitor(this.rule, this.context);

  late LineInfo _lineInfo;

  @override
  void visitCompilationUnit(CompilationUnit node) => _lineInfo = node.lineInfo;

  @override
  void visitArgumentList(ArgumentList node) {
    if (node.arguments.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightParenthesis,
      firstNode: node.arguments.first,
      lastNode: node.arguments.last,
    );
  }

  @override
  void visitAssertInitializer(AssertInitializer node) {
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightParenthesis,
      firstNode: node.condition,
      lastNode: node.message ?? node.condition,
    );
  }

  @override
  void visitAssertStatement(AssertStatement node) {
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightParenthesis,
      firstNode: node.condition,
      lastNode: node.message ?? node.condition,
    );
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    if (node.parameters.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightDelimiter ?? node.rightParenthesis,
      firstNode: node.parameters.first,
      lastNode: node.parameters.last,
      errorToken: node.rightDelimiter ?? node.rightParenthesis,
    );
  }

  @override
  void visitListLiteral(ListLiteral node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftBracket,
      closingToken: node.rightBracket,
      firstNode: node.elements.first,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftBracket,
      closingToken: node.rightBracket,
      firstNode: node.elements.first,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitRecordLiteral(RecordLiteral node) {
    if (node.fields.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightParenthesis,
      firstNode: node.fields.first,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitRecordPattern(RecordPattern node) {
    if (node.fields.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightParenthesis,
      firstNode: node.fields.first,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitRecordTypeAnnotation(RecordTypeAnnotation node) {
    if (node.namedFields == null && node.positionalFields.isEmpty) return;
    final fields = (node.namedFields?.fields ?? node.positionalFields);
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.namedFields?.rightBracket ?? node.rightParenthesis,
      firstNode: fields.first,
      lastNode: fields.last,
      errorToken: node.namedFields?.rightBracket ?? node.rightParenthesis,
    );
  }

  @override
  void visitSwitchExpression(SwitchExpression node) {
    if (node.cases.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftBracket,
      closingToken: node.rightBracket,
      firstNode: node.cases.first,
      lastNode: node.cases.last,
    );
  }

  @override
  void visitObjectPattern(ObjectPattern node) {
    if (node.fields.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftParenthesis,
      closingToken: node.rightParenthesis,
      firstNode: node.fields.first,
      lastNode: node.fields.last,
    );
  }

  @override
  void visitMapPattern(MapPattern node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftBracket,
      closingToken: node.rightBracket,
      firstNode: node.elements.first,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitListPattern(ListPattern node) {
    if (node.elements.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftBracket,
      closingToken: node.rightBracket,
      firstNode: node.elements.first,
      lastNode: node.elements.last,
    );
  }

  @override
  void visitBlockEnumBody(BlockEnumBody node) {
    if (node.constants.isEmpty) return;
    _checkTrailingComma(
      openingToken: node.leftBracket,
      closingToken: node.semicolon ?? node.rightBracket,
      firstNode: node.constants.first,
      lastNode: node.constants.last,
    );
  }

  void _checkTrailingComma({
    required Token openingToken,
    required Token closingToken,
    required AstNode firstNode,
    required AstNode lastNode,
    Token? errorToken,
  }) {
    errorToken ??= closingToken;

    // Early exit if trailing comma is present.
    if (lastNode.endToken.next?.type == TokenType.COMMA) return;

    // If the expression is not intended to be multi-line, ignore it.
    if (!_isMultiline(openingToken, closingToken, firstNode, lastNode)) {
      return;
    }

    rule.reportAtToken(errorToken);
  }

  /// Returns `true` if the opening and closing tokens are on different lines
  /// than the child nodes.
  bool _isMultiline(
      Token openingToken,
      Token closingToken,
      AstNode firstNode,
      AstNode lastNode,
      ) {
    if (!_isSameLine(openingToken, firstNode.beginToken) &&
        !_isSameLine(closingToken, lastNode.endToken)) {
      return true;
    }
    return false;
  }

  bool _isSameLine(Token token1, Token token2) =>
      _lineInfo.getLocation(token1.offset).lineNumber ==
          _lineInfo.getLocation(token2.end).lineNumber;
}

class AddTrailingCommaFix extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    "brtc.fix.addTrailingComma",
    DartFixKindPriority.standard,
    "Add a trailing comma",
  );

  AddTrailingCommaFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    Future<void> insertCommaAfter(Token token) {
      return builder.addDartFileEdit(file, (builder) {
        builder.addSimpleInsertion(token.end, ",");
      });
    }

    switch (node) {
      case ArgumentList(:final rightParenthesis):
        await insertCommaAfter(rightParenthesis.previous!);
      case AssertInitializer(:final rightParenthesis):
        await insertCommaAfter(rightParenthesis.previous!);
      case AssertStatement(:final rightParenthesis):
        await insertCommaAfter(rightParenthesis.previous!);
      case FormalParameterList(:final rightDelimiter, :final rightParenthesis):
        await insertCommaAfter((rightDelimiter ?? rightParenthesis).previous!);
      case ListLiteral(:final rightBracket):
        await insertCommaAfter(rightBracket.previous!);
      case SetOrMapLiteral(:final rightBracket):
        await insertCommaAfter(rightBracket.previous!);
      case RecordLiteral(:final rightParenthesis):
        await insertCommaAfter(rightParenthesis.previous!);
      case RecordPattern(:final rightParenthesis):
        await insertCommaAfter(rightParenthesis.previous!);
      case RecordTypeAnnotation(:final namedFields, :final rightParenthesis):
        await insertCommaAfter(
          (namedFields?.rightBracket ?? rightParenthesis).previous!,
        );
      case SwitchExpression(:final rightBracket):
        await insertCommaAfter(rightBracket.previous!);
      case ObjectPattern(:final rightParenthesis):
        await insertCommaAfter(rightParenthesis.previous!);
      case ListPattern(:final rightBracket):
        await insertCommaAfter(rightBracket.previous!);
      case MapPattern(:final rightBracket):
        await insertCommaAfter(rightBracket.previous!);
      case BlockEnumBody(:final semicolon, :final rightBracket):
        await insertCommaAfter((semicolon ?? rightBracket).previous!);
    }
  }
}
