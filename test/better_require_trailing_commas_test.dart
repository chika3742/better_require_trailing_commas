// ignore_for_file: non_constant_identifier_names

import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:better_require_trailing_commas/rules/better_require_trailing_commas.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(BetterRequireTrailingCommasTest);
  });
}

@reflectiveTest
class BetterRequireTrailingCommasTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = BetterRequireTrailingCommasRule();
    super.setUp();
  }

  void test_argumentListWithoutComma() async {
    await assertDiagnostics(
      r"""
void fn({String? arg1}) {}
void f() {
  fn(
    arg1: "value"
  );
}
    """,
      [lint(64, 1)],
    );
  }

  void test_argumentListWithComma() async {
    await assertNoDiagnostics(r"""
void fn({String? arg1}) {}
void f() {
  fn(
    arg1: "value",
  );
}
    """);
  }

  void test_assertInitializerWithoutComma() async {
    await assertDiagnostics(
      r"""
class Test {
  const Test(String foo)
      : assert(
          foo == "bar",
          "foo must be 'bar'"
        );
}
    """,
      [lint(116, 1)],
    );
  }

  void test_assertInitializerWithComma() async {
    await assertNoDiagnostics(r"""
class Test {
  const Test(String foo)
      : assert(
          foo == "bar",
          "foo must be 'bar'",
        );
}
    """);
  }

  void test_assertStatementWithoutComma() async {
    await assertDiagnostics(
      r"""
void fn() {
  final foo = "bar";
  assert(
    foo == "bar",
    "foo must be 'bar'"
  );
}
    """,
      [lint(87, 1)],
    );
  }

  void test_assertStatementWithComma() async {
    await assertNoDiagnostics(r"""
void fn() {
  final foo = "bar";
  assert(
    foo == "bar",
    "foo must be 'bar'",
  );
}
    """);
  }

  void test_formalParameterListWithoutComma() async {
    await assertDiagnostics(
      r"""
void fn1({
  String? foo,
  String? bar
}) {}
void fn2([
  String? foo,
  String? bar
]) {}
void fn3(
  String? foo,
  String? bar
) {}
void fn4(
  String? foo,
  String? bar, {
  String? baz
}) {}
    """,
      [lint(40, 1), lint(86, 1), lint(131, 1), lint(192, 1)],
    );
  }

  void test_formalParameterListWithComma() async {
    await assertNoDiagnostics(r"""
void fn1({
  String? foo,
  String? bar,
}) {}
void fn2([
  String? foo,
  String? bar,
]) {}
void fn3(
  String? foo,
  String? bar,
) {}
void fn4(
  String? foo,
  String? bar, {
  String? baz,
}) {}
    """);
  }

  void test_listLiteralWithoutComma() async {
    await assertDiagnostics(
      r"""
final list = [
  1,
  2
];
    """,
      [lint(24, 1)],
    );
  }

  void test_listLiteralWithComma() async {
    await assertNoDiagnostics(r"""
final list = [
  1,
  2,
];
    """);
  }

  void test_setOrMapLiteralWithoutComma() async {
    await assertDiagnostics(
      r"""
final set = {
  1,
  2
};
final map = {
  1: "one",
  2: "two"
};
    """,
      [lint(23, 1), lint(63, 1)],
    );
  }

  void test_setOrMapLiteralWithComma() async {
    await assertNoDiagnostics(r"""
final set = {
  1,
  2,
};
final map = {
  1: "one",
  2: "two",
};
    """);
  }

  void test_recordLiteralWithoutComma() async {
    await assertDiagnostics(
      r"""
final record1 = (
  1,
  2
);
final record2 = (
  one: 1,
  two: 2
);
    """,
      [lint(27, 1), lint(67, 1)],
    );
  }

  void test_recordLiteralWithComma() async {
    await assertNoDiagnostics(r"""
final record1 = (
  1,
  2,
);
final record2 = (
  one: 1,
  two: 2,
);
    """);
  }

  void test_recordPatternWithoutComma() async {
    await assertDiagnostics(
      r"""
void fn () {
  final (
    :name,
    :age
  ) = (name: "foo", age: 20);

  final (
    one,
    two
  ) = (1, 2);
}
    """,
      [lint(45, 1), lint(103, 1)],
    );
  }

  void test_recordPatternWithComma() async {
    await assertNoDiagnostics(r"""
void fn6 () {
  final (
    :name,
    :age,
  ) = (name: "foo", age: 20);

  final (
    one,
    two,
  ) = (1, 2);
}
    """);
  }

  void test_recordTypeAnnotationWithoutComma() async {
    await assertDiagnostics(
      r"""
typedef recordType1 = (
  int,
  int
);
typedef recordType2 = ({
  String name,
  int age
});
    """,
      [lint(37, 1), lint(90, 1)],
    );
  }

  void test_recordTypeAnnotationWithComma() async {
    await assertNoDiagnostics(r"""
typedef recordType1 = (
  int,
  int,
);
typedef recordType2 = ({
  String name,
  int age,
});
    """);
  }

  void test_switchExpressionWithoutComma() async {
    await assertDiagnostics(
      r"""
void fn() {
  final success = true;
  final foo = switch (success) {
    true => "success",
    false => "failure"
  };
}
    """,
      [lint(117, 1)],
    );
  }

  void test_switchExpressionWithComma() async {
    await assertNoDiagnostics(r"""
void fn() {
  final success = true;
  final foo = switch (success) {
    true => "success",
    false => "failure",
  };
}
    """);
  }

  void test_enumDeclarationWithoutComma() async {
    await assertDiagnostics(
      r"""
enum FooState1 {
  bar,
  baz
}
enum FooState2 {
  bar,
  baz
  ;
}

enum BarState {
  taro("taro"),
  hanako("hanako")
  ;

  const BarState(this.name);

  final String name;
}
    """,
      [lint(30, 1), lint(64, 1), lint(122, 1)],
    );
  }

  void test_enumDeclarationWithComma() async {
    await assertNoDiagnostics(r"""
enum FooState1 {
  bar,
  baz,
}
enum FooState2 {
  bar,
  baz,
  ;
}
enum FooState3 {
  bar,
  baz;
}

enum BarState {
  taro("taro"),
  hanako("hanako"),
  ;

  const BarState(this.name);

  final String name;
}
    """);
  }

  void test_useEffect() async {
    await assertDiagnostics(
      r"""
void fn() {
  useEffect(() {
    // do something
  }, []);
  useEffect(
    () {
      // do something
    },
    []
  );
}
void useEffect(void Function() cb, List<Object> dependencies) {}
    """,
      [lint(119, 1)],
    );
  }

  void test_multilineException() async {
    await assertDiagnostics(
      r"""
void fn() {
  Foo(Bar(
    baz: "baz",
  ));
  Foo(
    Bar(baz: "baz")
  );
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
      [lint(74, 1)],
    );
  }
}
