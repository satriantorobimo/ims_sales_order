import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GeneralUtil {
  Future<String> getDeviceType() async {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  String deviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  bool isOdd(int val) {
    return (val & 0x01) != 0;
  }

  void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Iterable<int> range(int low, int high) sync* {
    for (int i = low; i < high; ++i) {
      yield i;
    }
  }

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static String convertToIdrNoSymbol(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static String formatIDRWithoutSymbol(String input) {
    // Remove non-numeric characters
    String cleanedInput = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse the cleaned input as an integer
    int inputValue = int.tryParse(cleanedInput) ?? 0;

    // Format the integer as IDR currency without the currency symbol
    String formattedIDR = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '', // Empty string to remove the currency symbol
    ).format(
        inputValue / 1000); // Divide by 1000 to handle the thousand separator

    return formattedIDR;
  }

  static String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  static String formatNumber(String s) =>
      NumberFormat.decimalPattern('id_ID').format(int.parse(s));

  static String get currency =>
      NumberFormat.compactSimpleCurrency(locale: 'id_ID').currencySymbol;
}

extension StringExtension on String {
  String capitalizeOnlyFirstLater() {
    if (trim().isEmpty) return "";

    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
