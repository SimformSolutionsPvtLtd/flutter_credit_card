extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? false);

  bool get isNotNullAndNotEmpty => this != null && (this?.isNotEmpty ?? false);
}

extension StringExtension on String {

  String get toDate {
    return padLeft(2, '0').substring(0, 2);
  }

  String get toNumber {
    if (int.tryParse(this) != null && double.tryParse(this) != null)
      return this;
    return '';
  }

  (int?, int?) get toRecordValue {
    if (contains('/'))
      return (int.tryParse(split('/').first), int.tryParse(split('/').last));
    return (null, null);
  }
}

extension RecordsExtension on (int?, int?) {
  String get toStringValue {
    return '${(this.$1 ?? "MM").toString().toDate}/${(this.$2 ?? "YY").toString().toDate}';
  }
}
