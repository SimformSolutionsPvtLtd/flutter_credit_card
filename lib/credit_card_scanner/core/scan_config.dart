class ScanConfig {
  const ScanConfig({
    this.requiresCardNum = true,
    this.requiresExpiryDate = false,
    this.requiresCardHolderName = false,
  });

  final bool requiresCardNum;
  final bool requiresExpiryDate;
  final bool requiresCardHolderName;
}
