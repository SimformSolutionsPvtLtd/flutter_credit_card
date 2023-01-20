import 'package:example/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<MySample> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/bg.png'),
              fit: BoxFit.fill,
            ),
            color: Colors.black,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                CreditCardWidget(
                  formKey: formKey2,
                  obscureCvv: true,
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: 'Axis Bank',
                  frontCardBorder:
                      !useGlassMorphism ? Border.all(color: Colors.grey) : null,
                  backCardBorder:
                      !useGlassMorphism ? Border.all(color: Colors.grey) : null,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: AppColors.cardBgColor,
                  backgroundImage:
                      useBackgroundImage ? 'assets/card_bg.png' : null,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                  onCreditCardModelChange: onCreditCardModelChange,
                  themeColor: Colors.blue,
                  textColor: Colors.white,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final FocusScopeNode currentFocus =
                          FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          'Card number:- $cardNumber',
                          style: const TextStyle(color: Colors.red),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                CreditCardForm(
                                  formKey: formKey,
                                  obscureCvv: true,
                                  obscureNumber: true,
                                  cardNumber: cardNumber,
                                  cvvCode: cvvCode,
                                  isHolderNameVisible: true,
                                  isCardNumberVisible: true,
                                  isExpiryDateVisible: true,
                                  cardHolderName: cardHolderName,
                                  expiryDate: expiryDate,
                                  themeColor: Colors.blue,
                                  textColor: Colors.white,
                                  cardNumberDecoration: InputDecoration(
                                    labelText: 'Number',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    focusedBorder: border,
                                    enabledBorder: border,
                                  ),
                                  expiryDateDecoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    focusedBorder: border,
                                    enabledBorder: border,
                                    labelText: 'Expired Date',
                                    hintText: 'XX/XX',
                                  ),
                                  cvvCodeDecoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    focusedBorder: border,
                                    enabledBorder: border,
                                    labelText: 'CVV',
                                    hintText: 'XXX',
                                  ),
                                  cardHolderDecoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    focusedBorder: border,
                                    enabledBorder: border,
                                    labelText: 'Card Holder',
                                  ),
                                  onCreditCardModelChange:
                                      onCreditCardModelChange,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'Glassmorphism',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Spacer(),
                                      Switch(
                                        value: useGlassMorphism,
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Colors.white,
                                        activeTrackColor: AppColors.colorE5D1B2,
                                        onChanged: (bool value) => setState(() {
                                          useGlassMorphism = value;
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'Card Image',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Spacer(),
                                      Switch(
                                        value: useBackgroundImage,
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Colors.white,
                                        activeTrackColor: AppColors.colorE5D1B2,
                                        onChanged: (bool value) => setState(() {
                                          useBackgroundImage = value;
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: _onValidate,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: <Color>[
                                          AppColors.colorB58D67,
                                          AppColors.colorB58D67,
                                          AppColors.colorE5D1B2,
                                          AppColors.colorF9EED2,
                                          AppColors.colorFFFFFD,
                                          AppColors.colorF9EED2,
                                          AppColors.colorB58D67,
                                        ],
                                        begin: Alignment(-1, -4),
                                        end: Alignment(1, 4),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Validate',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'halter',
                                        fontSize: 14,
                                        package: 'flutter_credit_card',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState!.validate() || formKey2.currentState!.validate()) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
