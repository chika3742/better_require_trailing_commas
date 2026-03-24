# better_require_trailing_commas

Dart linter plugin to enforce trailing commas (enhanced version of `linter` built-in `require_trailing_commas`)

**The rule is simple.** If you opened parentheses intending to write multiline contents, it requires trailing commas. It's like `always-multiline`setting of `comma-dangle` rule in ESLint.

## Rules

All rules are enabled by default. You can disable each rule in `analysis_options.yaml`
(see [Installation](#installation) section).

### better_require_trailing_commas

Enforces trailing commas for multiline collections, function calls, function definitions, and other constructs that
support trailing commas.

#### ✅ Good
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

#### ❌️ Bad
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

// Records are supported
final (String, String) foo = (
  "bar",
  "baz" // <-
);

// Switch expressions are supported
final foo = switch (state) {
  State.success => 0,
  State.failure => 1 // <-
}

// Enums are supported
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

### avoid_unnecessary_commas

Disallows unnecessary trailing commas for single-line collections, function calls, function definitions, and other
constructs that support trailing commas.

#### ✅ Good
```dart
Foo(a: 1, b: 2);
Foo(Bar(
  baz: "baz",
));
```

#### ❌️ Bad
```dart
Foo(a: 1, b: 2,); // <-
Foo(Bar(
  baz: "baz",
),); // <-
```

## Installation

**Dart 3.10 or later (Flutter 3.38 or later) is required to use this plugin.**

Edit your `analysis_options.yaml` like below. You **don't** need to add this to your dependencies in pubspec (for more
information, [see here](https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server_plugin/doc/using_plugins.md)).

### For Standalone Use

v4 of `better_require_trailing_commas` supports `analyzer` v10 and v11.

```yaml
# ...
# Note: `plugins` property is TOP LEVEL.
plugins:
  better_require_trailing_commas: ^4.0.0
# ...
```

v5 of `better_require_trailing_commas` supports `analyzer` v12 which supports empty bodies syntax.

```yaml
plugins:
  better_require_trailing_commas: ^5.0.0
```

### Using with `riverpod_lint`

Since `riverpod_lint: 3.1.3` does not support `analyzer` v10, use v3 of `better_require_trailing_commas` which
supports `analyzer` v9.

```yaml
# ...
# Note: `plugins` property is TOP LEVEL.
plugins:
  # Note: Do not put `riverpod_lint` after this plugin. This may cause unexpected behavior.
  riverpod_lint: ^3.1.3 # Put this BEFORE better_require_trailing_commas
  better_require_trailing_commas: ^3.0.0
```

Each rule can be disabled by `diagnostics` section like below:

```yaml
plugins:
  better_require_trailing_commas:
    version: ^2.2.0
    diagnostics:
      avoid_unnecessary_commas: false
```

Running the linter with command line:
```shell
dart analyze
```
