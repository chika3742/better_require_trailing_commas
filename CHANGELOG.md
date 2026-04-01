## 2.4.0
- Since this version, I separated the minor versions depending on the supported `analyzer` version.
  - `2.3.0` supports analyzer `^9.0.0`
  - `2.4.0` supports analyzer `>=10.0.1 <12.0.0`
  - `2.5.0` supports analyzer `^12.0.0`
- Added support for `analyzer` 11.x.

## 2.2.0
- Added `avoid_unnecessary_commas` lint rule.
- Fix detection logic for formal parameter lists and record type annots.

## 2.1.0
- Require `analyzer` 10.0.1 or higher

## 2.0.5
- Update README

## 2.0.4
- Enabled the lint rule by default. Now `diagnostics` config in `analysis_options.yaml` is no longer needed.
- Update README

## 2.0.3
- Allow analyzer 8.x
- Update README

## 2.0.2
- Update README

## 2.0.1
- Update README

## 2.0.0
- Rewrite using `analysis_server_plugin` instead of `custom_lint`
  - **Requires `analyzer ^9.0.0` and Dart SDK `^3.10` (Flutter `^3.38`)**

## 1.0.4
- Support `analyzer` v8.0.0

## 1.0.3
- Upgrade `custom_lint_builder` to v0.8.0 (`analyzer` ^7.5.0)

## 1.0.2
- Update package description
- Update README

## 1.0.1
- Update README
- Upgrade `analyzer_plugin` to v0.13

## 1.0.0
- Initial version.
