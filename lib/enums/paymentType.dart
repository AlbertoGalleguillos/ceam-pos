import 'package:ceam_pos/constants.dart' as Constants;

enum PaymentType {
  debit,
  cash,
  credit,
}

extension PaymentTypeExtension on PaymentType {
  String get description {
    switch (this) {
      case PaymentType.debit:
        return Constants.PAYMENT_TYPE_DEBIT;
      case PaymentType.cash:
        return Constants.PAYMENT_TYPE_CASH;
      case PaymentType.credit:
        return Constants.PAYMENT_TYPE_CREDIT;
      default:
        return Constants.PAYMENT_TYPE_CASH;
    }
  }
}
