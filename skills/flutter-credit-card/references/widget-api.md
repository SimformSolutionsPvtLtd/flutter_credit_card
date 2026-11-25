# CreditCardWidget — full parameter reference

All parameters for `CreditCardWidget` (v4.1.0).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `cardNumber` | `String` | yes | — | Card number; spaces are accepted |
| `expiryDate` | `String` | yes | — | Expiry date in `MM/YY` format |
| `cardHolderName` | `String` | yes | — | Holder name shown on front face |
| `cvvCode` | `String` | yes | — | 3–4 digit CVV |
| `showBackView` | `bool` | yes | — | `true` = flip to back (CVV face) |
| `onCreditCardWidgetChange` | `Function(CreditCardBrand)` | yes | — | Fires when detected card brand changes |
| `bankName` | `String?` | no | `null` | Optional bank name on front |
| `animationDuration` | `Duration` | no | 500ms | Flip animation duration |
| `height` | `double?` | no | `null` | Card height; auto-sized from width if null |
| `width` | `double?` | no | `null` | Card width; fills parent if null |
| `textStyle` | `TextStyle?` | no | `null` | Base text style for card labels |
| `cardBgColor` | `Color` | no | `#222D65` | Background color when no image is set |
| `obscureCardNumber` | `bool` | no | `true` | Mask middle 8 digits of card number |
| `obscureCardCvv` | `bool` | no | `true` | Mask CVV on back face |
| `obscureInitialCardNumber` | `bool` | no | `false` | Mask entire number before first input |
| `labelCardHolder` | `String` | no | `'CARD HOLDER'` | Placeholder label for holder name |
| `labelExpiredDate` | `String` | no | `'MM/YY'` | Expiry hint label |
| `labelValidThru` | `String` | no | `'VALID\nTHRU'` | Label above expiry |
| `cardType` | `CardType?` | no | `null` | Force a specific card type icon |
| `isHolderNameVisible` | `bool` | no | `false` | Show holder name on card |
| `backgroundImage` | `String?` | no | `null` | Asset image path for card background |
| `backgroundNetworkImage` | `String?` | no | `null` | Network URL for card background |
| `glassmorphismConfig` | `Glassmorphism?` | no | `null` | Glassmorphism blur/gradient config |
| `isChipVisible` | `bool` | no | `true` | Show chip on front face |
| `isSwipeGestureEnabled` | `bool` | no | `true` | Allow swipe to flip card |
| `customCardTypeIcons` | `List<CustomCardTypeIcon>` | no | `[]` | Override icons for specific card types |
| `padding` | `EdgeInsetsGeometry` | no | `16.0` | Inner card padding |
| `chipColor` | `Color?` | no | `null` | Chip widget color |
| `frontCardBorder` | `Border?` | no | `null` | Border on front face |
| `backCardBorder` | `Border?` | no | `null` | Border on back face |
| `enableFloatingCard` | `bool` | no | `false` | Enable gyroscope/pointer float effect |
| `floatingConfig` | `FloatingConfig` | no | default | Float behavior configuration |

## CardType enum values

```dart
CardType.otherBrand
CardType.mastercard
CardType.visa
CardType.rupay
CardType.americanExpress
CardType.unionpay
CardType.discover
CardType.elo
CardType.hipercard
CardType.mir
```

## FloatingConfig fields

| Field | Type | Default | Description |
|---|---|---|---|
| `floatingType` | `FloatingType?` | auto | `pointer` (web/desktop) or `gyroscope` (mobile) |
| `onFloatingEvent` | `Function(FloatingEvent)?` | `null` | Called with rotation data on each frame |

## Glassmorphism fields

| Field | Type | Description |
|---|---|---|
| `blurX` | `double` | Horizontal blur radius |
| `blurY` | `double` | Vertical blur radius |
| `gradient` | `Gradient` | Overlay gradient (use semi-transparent whites) |

`Glassmorphism.defaultConfig()` returns a ready-to-use preset.