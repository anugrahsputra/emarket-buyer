class Formatter {
  static String phoneFormat(String phoneNumber) {
    final formattedNumber = phoneNumber.replaceAll(RegExp('^0'), '+62');
    return formattedNumber;
  }

  static String priceFormat(int price) {
    final formattedPrice = price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
    return 'Rp. $formattedPrice';
  }
}
