# better_require_trailing_commas

Dart linter plugin to enforce trailing commas (enhanced version of `linter` built-in `require_trailing_commas`)

**The rule is simple.** If you opened parentheses intending to write multiline contents, it requires trailing commas. It's like `always-multiline`setting of `comma-dangle` rule in ESLint.

### ✅ Good
```dart
Foo(
  a: 1,
  b: 2,
);

Foo(Bar(
  a: 1,
  b: 2,
));

useEffect(() {
  // ...
}, []);
```

### ❌️ Bad
```dart
Foo(
  a: 1,
  b: 2 // <-
);

Foo(Bar(
  a: 1,
  b: 2 // <-
));

useEffect(
  () {
    // ...
  },
  [] // <-
);
```
Records are supported
```dart
final (String, String) foo = (
  "bar",
  "baz" // <-
);
```
Switch expressions are supported
```dart
final foo = switch (state) {
  State.success => 0,
  State.failure => 1 // <-
}
```

Enums are supported
```dart
enum FooState {
  bar,
  baz // <-
}

enum BarState {
  taro("taro"),
  hanako("hanako") // <-
  ;
  
  const BarState(this.name);

  final String name;
}
```

Of course, also have quick fixes.

## Installation

Just add this package to your dependencies. **This plugin requires Dart SDK >= 3.10 or Flutter SDK >= 3.38.**

```shell
dart pub add dev:better_require_trailing_commas
# or
flutter pub add dev:better_require_trailing_commas
```

If you're using an IDE like VSCode, edit your `analysis_options.yaml` like this:
```yaml
# ...
# Note: `plugins` property is TOP LEVEL.
plugins:
  better_require_trailing_commas:
    version: ^2.0.0
    diagnostics:
      better_require_trailing_commas: true
# ...
```

Running the linter with command line:
```shell
dart analyze
```
