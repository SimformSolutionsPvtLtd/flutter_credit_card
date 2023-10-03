class Validators {
  const Validators._();

  static String? cardNumberValidator(String? value, String errorMsg) {
    // Validate less that 13 digits +3 white spaces
    return (value?.isEmpty ?? true) || (value?.length ?? 16) < 16
        ? errorMsg
        : null;
  }

  static String? expiryDateValidator(String? value, String errorMsg) {
    if (value?.isEmpty ?? true) {
      return errorMsg;
    }

    final DateTime now = DateTime.now();
    final List<String> date = value!.split(RegExp(r'/'));

    final int month = int.parse(date.first);
    final int year = int.parse('20${date.last}');

    final int lastDayOfMonth = month < 12
        ? DateTime(year, month + 1, 0).day
        : DateTime(year + 1, 1, 0).day;

    final DateTime cardDate =
        DateTime(year, month, lastDayOfMonth, 23, 59, 59, 999);

    if (cardDate.isBefore(now) || month > 12 || month == 0) {
      return errorMsg;
    }

    return null;
  }

  static String? cvvValidator(String? value, String errorMsg) {
    return (value?.isEmpty ?? true) || ((value?.length ?? 3) < 3)
        ? errorMsg
        : null;
  }
}
