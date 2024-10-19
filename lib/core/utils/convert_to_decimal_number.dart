double convertToDecimal(int number) {
  // تقسیم عدد بر 100 تا دو رقم اعشاری ایجاد بشه
  double decimal = number / 100;

  // تبدیل به رشته با دو رقم بعد از اعشار
  return double.parse(decimal.toStringAsFixed(2));
}
