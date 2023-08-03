class AppConstants {
  AppConstants._();

  static const double webBreakPoint = 800;
  static const double creditCardAspectRatio = 0.5714;
  static const double creditCardPadding = 16;
  static RegExp lineSpaceDashRegExp = RegExp(r'^[\d\s\-]+$');
  static RegExp spaceDashRegExp = RegExp(r'[\s\-]');
  static RegExp numberBetween12And19RegExp = RegExp(r'^\d{12,19}$');
}
