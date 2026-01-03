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

**Dart 3.10 or later (Flutter 3.38 or later) is required to use this plugin.**

Edit your `analysis_options.yaml` like below. You don't need to add this to your dependencies (for more information, [see here](https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server_plugin/doc/using_plugins.md)).

```yaml
# ...
# Note: `plugins` property is TOP LEVEL.
plugins:
  better_require_trailing_commas:
    version: ^2.0.0
  # Note: Do not put `riverpod_lint` after this plugin.
  #       This may cause unexpected behavior.
  # riverpod_lint: ^3.1.0 # Put this BEFORE better_require_trailing_commas
# ...
```

Running the linter with command line:
```shell
dart analyze
```
