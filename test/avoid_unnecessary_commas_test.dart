// ignore_for_file: non_constant_identifier_names

import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:better_require_trailing_commas/rules/avoid_unnecessary_commas.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidUnnecessaryCommasTest);
  });
}

@reflectiveTest
class AvoidUnnecessaryCommasTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = AvoidUnnecessaryCommasRule();
    super.setUp();
  }

  void test_argumentListWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn({String? arg1}) {}
void f() {
  fn(arg1: "value",);
}
    """,
      [lint(56, 1)],
    );
  }

  void test_argumentListWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(
      r"""
void fn({String? arg1}) {}
void f() {
  fn(arg1: "value");
}
    """,
    );
  }

  void test_assertInitializerWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
class Test {
  const Test(String foo)
      : assert(foo == "bar", "foo must be 'bar'",);
}
    """,
      [lint(86, 1)],
    );
  }

  void test_assertInitializerWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
class Test {
  const Test(String foo)
      : assert(foo == "bar", "foo must be 'bar'");
}
    """);
  }

  void test_assertStatementWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn() {
  final foo = "bar";
  assert(foo == "bar", "foo must be 'bar'",);
}
    """,
      [lint(75, 1)],
    );
  }

  void test_assertStatementWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
void fn() {
  final foo = "bar";
  assert(foo == "bar", "foo must be 'bar'");
}
    """);
  }

  void test_formalParameterListWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn1({String? foo, String? bar,}) {}
void fn2([String? foo, String? bar,]) {}
void fn3(String? foo, String? bar,) {}
void fn4(String? foo, String? bar, {String? baz,}) {}
    """,
      [lint(34, 1), lint(75, 1), lint(115, 1), lint(168, 1)],
    );
  }

  void test_formalParameterListWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
void fn1({String? foo, String? bar}) {}
void fn2([String? foo, String? bar]) {}
void fn3(String? foo, String? bar) {}
void fn4(String? foo, String? bar, {String? baz}) {}
    """);
  }

  void test_listLiteralWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
final list = [1, 2,];
    """,
      [lint(18, 1)],
    );
  }

  void test_listLiteralWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
final list = [1, 2];
    """);
  }

  void test_setOrMapLiteralWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
final set = {1, 2,};
final map = {1: "one", 2: "two",};
    """,
      [lint(17, 1), lint(52, 1)],
    );
  }

  void test_setOrMapLiteralWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
final set = {1, 2};
final map = {1: "one", 2: "two"};
    """);
  }

  void test_recordLiteralWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
final record1 = (1, 2,);
final record2 = (one: 1, two: 2,);
    """,
      [lint(21, 1), lint(56, 1)],
    );
  }

  void test_recordLiteralWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
final record1 = (1, 2);
final record2 = (one: 1, two: 2);
    """);
  }

  void test_recordPatternWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn () {
  final (:name, :age,) = (name: "foo", age: 20);
  final (one, two,) = (1, 2);
}
    """,
      [lint(33, 1), lint(79, 1)],
    );
  }

  void test_recordPatternWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
void fn () {
  final (:name, :age) = (name: "foo", age: 20);
  final (one, two) = (1, 2);
}
    """);
  }

  void test_recordTypeAnnotationWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
typedef recordType1 = (int, int,);
typedef recordType2 = ({String name, int age,});
    """,
      [lint(31, 1), lint(79, 1)],
    );
  }

  void test_recordTypeAnnotationWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
typedef recordType1 = (int, int);
typedef recordType2 = ({String name, int age});
    """);
  }

  void test_switchExpressionWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn() {
  final success = true;
  final foo = switch (success) { true => "success", false => "failure", };
}
    """,
      [lint(106, 1)],
    );
  }

  void test_switchExpressionWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
void fn() {
  final success = true;
  final foo = switch (success) { true => "success", false => "failure" };
}
    """);
  }

  void test_enumDeclarationWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
enum FooState1 { bar, baz, }
enum FooState2 {
  bar,
  baz,;
}
enum BarState {
  taro("taro"),
  hanako("hanako"),;

  const BarState(this.name);

  final String name;
}
    """,
      [lint(25, 1), lint(58, 1), lint(113, 1)],
    );
  }

  void test_enumDeclarationWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
enum FooState1 { bar, baz }
enum FooState2 {
  bar,
  baz;
}
enum BarState {
  taro("taro"),
  hanako("hanako");

  const BarState(this.name);

  final String name;
}
    """);
  }

  void test_useEffectWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn() {
  useEffect(() {
    // ...
  }, [],);
}
void useEffect(void Function() cb, List<Object> dependencies) {}
    """,
      [lint(47, 1)],
    );
  }

  void test_useEffectWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
void fn() {
  useEffect(() {
    // ...
  }, []);
}
void useEffect(void Function() cb, List<Object> dependencies) {}
    """);
  }

  void test_multilineExceptionWithUnnecessaryComma() async {
    await assertDiagnostics(
      r"""
void fn() {
  Foo(Bar(
    baz: "baz",
  ),);
}
class Foo {
  final Object foo;
  Foo(this.foo);
}
class Bar {
  final String baz;
  Bar({required this.baz});
}
    """,
      [lint(42, 1)],
    );
  }

  void test_multilineExceptionWithoutUnnecessaryComma() async {
    await assertNoDiagnostics(r"""
void fn() {
  Foo(Bar(
    baz: "baz"
  ));
}
class Foo {
  final Object foo;
  Foo(this.foo);
}
class Bar {
  final String baz;
  Bar({required this.baz});
}
    """);
  }
}
