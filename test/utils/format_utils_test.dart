import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';

void main() {
  group('formatCurrency', () {
    test('memformat angka bulat ke format Rupiah Indonesia', () {
      final result = formatCurrency(25000);

      expect(result, 'Rp. 25.000');
    });

    test('memformat nol ke Rp. 0', () {
      final result = formatCurrency(0);

      expect(result, 'Rp. 0');
    });

    test('memformat nominal besar dengan pemisah ribuan yang benar', () {
      final result = formatCurrency(1500000);

      expect(result, 'Rp. 1.500.000');
    });

    test('memformat nominal sangat besar', () {
      final result = formatCurrency(10000000);

      expect(result, 'Rp. 10.000.000');
    });

    test('memformat nilai kecil tanpa pemisah ribuan', () {
      final result = formatCurrency(500);

      expect(result, 'Rp. 500');
    });

    test('membulatkan desimal (tidak menampilkan sen)', () {
      final result = formatCurrency(25000.75);

      // Di locale id_ID, pemisah desimal adalah koma (,), bukan titik (.).
      // Output yang benar: tidak ada bagian desimal (koma) dalam string.
      expect(result, isNot(contains(',')));
      expect(result, contains('Rp.'));
    });
  });
}
