import 'package:ceam_pos/enums/paymentType.dart';
import 'package:ceam_pos/constants.dart' as Constants;

class Invoice {
  int number;
  String date;
  PaymentType paymentType;
  int amount;
  String sign;

  Invoice({
    this.number,
    this.date,
    this.paymentType,
    this.amount,
    this.sign,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      number: json['number'],
      date: json['date'],
      paymentType: getPaymentType(json['paymentType']),
      amount: json['amount'],
      sign: json['sign'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'date': date,
      'paymentType': paymentType.description,
      'amount': amount,
      'sign': sign,
    };
  }

  static PaymentType getPaymentType(String type) {
    switch (type) {
      case Constants.PAYMENT_TYPE_DEBIT:
        return PaymentType.debit;
      case Constants.PAYMENT_TYPE_CASH:
        return PaymentType.cash;
      case Constants.PAYMENT_TYPE_CREDIT:
        return PaymentType.credit;
      default:
        return PaymentType.cash;
    }
  }
}
