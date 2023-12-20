# [4.0.2](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/4.0.2) [UNRELEASED]

- Fixed floating event stream bad state exception [#157](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/157).

# [4.0.1](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/4.0.1)

- Fixed glare effect issue [#154](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/154).
- Added desktop support for example app [#155](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/155).

# [4.0.0+1](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/4.0.0+1)

- Added web support for example app [#148](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/148).
- Added card float animation [#144](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/144).
- Fixed credit card padding in RTL [#139](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/139).
- Fixed [#138](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/138) 
  AutoValidateMode only applied to Card Number text field.
- Added dart 3 support [#146](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/146).
- Fixed package structure and improved code overall [#150](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/150).
- Fixed and improved card type detection logic [#151](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/151).
- [BREAKING] Fixed [#136](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/136)
  Application theme not applied to `CreditCardForm`. 
  - Removed `themeColor`, `textColor`, `cursorColor` from `CreditCardForm`. You can check example app
  to know how to apply those using `Theme`. 
- [BREAKING] Added `InputDecoration` class [#153](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/153).
  - The `cardNumberDecoration`, `expiryDateDecoration`, `cvvCodeDecoration`, and `cardHolderDecoration`
     properties are moved to the newly added `InputDecoration` class that also has `textStyle` properties
     for all the textFields of the `CreditCardForm`.

# [3.0.7](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.7)

- Enhancement [#133](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/133) Add valid thru label customization.
- Enhancement [#142](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/142) Adding RuPay as card-type for users centric to India

# [3.0.6](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.6)

- Add documentation for public apis.
- Fixed [#126](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/126) Add a flag to disable autofill hints for credit card number as workaround to fix incorrect keyboard.
- Enhancement [#129](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/129) Obscure initial character in credit card widget
- Enhancement [#131](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/131) Add a flag to enable/disable cvv in credit card form

# [3.0.5](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.5)

- New card brands (Elo/Hipercard) was added [#109](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/109) 
- Enhancement [#111](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/111) Added Support for controlling the internal padding.
- Fixed [#112](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/112) Update bg color gradient.
- Added cardBorder parameter on CreditCardWidget widget.
- CreditCardWidget UI updated.

# [3.0.4](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.4)

- Dependencies Upgraded [#97](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/97) 
- Fixed [#66](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/66) The expiry date on the cards should be based on the last day of that month.
- Fixed [#86](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/86) Added a custom validator to each TextField.
- Enhancement [#55](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/55) Added Support for optional function to execute onEditingComplete callback.
- Enhancement [#72](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/72) Automatically add leading 0 to expiry date when it starts with 2-9.
- Enhancement [#94](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/pull/94) Allowing separate form field keys gives control to developer validating separate fields.

# [3.0.3](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.3)

- Fixed [#47](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/47) - Added Bank name above card number
- Fixed [#6](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/6) - Initialize values

# [3.0.2](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.2)

- Fixed [#73](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/73) - Pass AutovalidateMode to CreditCardForm
- Fixed [#82](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/82) - Added support to add network image as card background
- Fixed [#46](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/46) - Card number Regex issue for safari and web

# [3.0.1](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/3.0.1)

- Fixed [#40](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/40) - Absence of focus node in credit_card_form.dart
- Fixed [#57](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/57) - Can we specify a custom card type logos
- License update from BSD 2-Clause "Simplified" to MIT

# 3.0.0

- Glassmorphism UI.
- Image background for card.
- Chip option for card.
- Card rotation on swipe gesture.
- Example with new changes

# 2.0.0

- Migrated to null safety.
- Fixed [#17](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/17) - Added translations for captions.
- Fixed [#16](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/16) - Validate Input card details.
- Fixed [15](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/15) - Change hint Color and enabled border color
- Fixed [#9](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/9) - change labelText and hintText
- Fixed [#2](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/issues/2) - textfield validation

# 0.1.4
*   Feature : Added number and CVV obfuscation
*   Feature : Added input decorations
*   Feature : Added simple card input validations

# 0.1.3
*   Feature : Applied Default ThemeData.

# 0.1.2
*   Added CreditCard with Form Widget `CreditCardForm`.
*   Bug and Lint check fixes

# 0.1.1
*   Code Improvements

# 0.1.0
*   First Release
