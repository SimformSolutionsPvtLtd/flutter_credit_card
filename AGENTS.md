# AGENTS.md — Maintainer guide for flutter_credit_card

## Package overview

`flutter_credit_card` is a single-package Flutter plugin providing:
- `CreditCardWidget` — visual card display (flip and float animations, glassmorphism, card brand detection)
- `CreditCardForm` — validated form for card number, expiry date, CVV, and holder name
- `CreditCardModel` — shared state between widget and form

## Project conventions

- `lib/src/credit_card_widget.dart` — widget display logic
- `lib/src/credit_card_form.dart` — form logic and validation
- `lib/src/models/` — `CreditCardModel`, `CreditCardBrand`, `GlassmorphismConfig`, `CustomCardTypeIcon`, `InputConfiguration`
- `lib/src/utils/enumerations.dart` — `CardType`, `FloatingType`
- `lib/src/floating_animation/` — floating card effect implementation

Keep docs, CHANGELOG, and skills in sync with any API or parameter change.

## Skills

Skills live in `skills/flutter-credit-card/`. The skill name must start with the package name (`flutter-credit-card`).

### Naming rules
- Directory name = frontmatter `name` = package name with underscores → hyphens, plus optional `-topic` suffix
- Lowercase, digits and single hyphens only
- Frontmatter: `name` and `description` only (max 1024 chars)

### File structure
```
skills/
  flutter-credit-card/
    SKILL.md                     ← main skill (≤500 lines)
    references/
      widget-api.md              ← full parameter table
```

### Rules
- One skill per user task; extend rather than splitting into new skills
- Long tables go in `references/` and are linked relatively from the skill root
- Dart examples in SKILL.md must compile against `lib/`
- Document only behaviour verified in `lib/`
- `skills/` must not be excluded by `.gitignore` or `.pubignore`

## Validating skills

Install `skills_lint` globally (requires Dart SDK ≥ 3.12):

```sh
dart pub global activate skills_lint
dart pub global run skills_lint --package . --fix
```

## Testing a skill install

Create a throwaway app with a path dependency on this package, then:

```sh
dart run skills@ get --all --agent claude
```

Check that `.claude/skills/flutter-credit-card.md` was created.

## Changelog and versioning

- Add entries under `## [Unreleased]` only; do not bump the version in `pubspec.yaml`
- Version bumps happen in a separate release PR

## Windows note

If you use symlinks in `references/` in future, clone with symlinks enabled:

```sh
git clone -c core.symlinks=true https://github.com/SimformSolutionsPvtLtd/flutter_credit_card.git
```