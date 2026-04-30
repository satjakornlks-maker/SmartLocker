class BookingPromotion {
  final String id;
  final String labelEn;
  final String labelTh;
  final String bookingType; // 'hour' or 'day'
  final int minQuantity;
  final double percentOff;
  final int flatOff;

  const BookingPromotion({
    required this.id,
    required this.labelEn,
    required this.labelTh,
    required this.bookingType,
    required this.minQuantity,
    this.percentOff = 0,
    this.flatOff = 0,
  });

  bool isEligible(String type, int quantity) =>
      bookingType == type && quantity >= minQuantity;

  int computeDiscount(int subtotal) {
    if (percentOff > 0) return (subtotal * percentOff / 100).round();
    return flatOff;
  }

  String label(String locale) => locale == 'th' ? labelTh : labelEn;

  String conditionText(String locale) {
    if (locale == 'th') {
      final unit = bookingType == 'day' ? 'วัน' : 'ชั่วโมง';
      return '$minQuantity $unit ขึ้นไป';
    }
    final unit = bookingType == 'day' ? 'day(s)' : 'hour(s)';
    return '$minQuantity+ $unit';
  }

  String discountText(String locale) {
    if (locale == 'th') {
      return percentOff > 0
          ? 'ลด ${percentOff.toStringAsFixed(0)}%'
          : 'ลด $flatOff บาท';
    }
    return percentOff > 0
        ? '${percentOff.toStringAsFixed(0)}% off'
        : '-$flatOff Baht';
  }
}

const List<BookingPromotion> mockPromotions = [
  BookingPromotion(
    id: 'HOUR5',
    labelEn: '5+ hours: 10% off',
    labelTh: '5 ชั่วโมงขึ้นไป: ลด 10%',
    bookingType: 'hour',
    minQuantity: 5,
    percentOff: 10,
  ),
  BookingPromotion(
    id: 'DAY2',
    labelEn: '2+ days: -10 Baht',
    labelTh: '2 วันขึ้นไป: ลด 10 บาท',
    bookingType: 'day',
    minQuantity: 2,
    flatOff: 10,
  ),
  BookingPromotion(
    id: 'DAY7',
    labelEn: '7+ days: 15% off',
    labelTh: '7 วันขึ้นไป: ลด 15%',
    bookingType: 'day',
    minQuantity: 7,
    percentOff: 15,
  ),
];
