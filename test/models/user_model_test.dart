import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/user_model.dart';

void main() {
  group('UserModel', () {
    final tUser = UserModel(
      uid: 'uid-001',
      name: 'Siti Rahma',
      email: 'siti@example.com',
      role: 'Cashier',
      approved: true,
      active: true,
    );

    // ── toMap ─────────────────────────────────────────────────────────────

    test('toMap() mengembalikan semua field yang benar', () {
      final map = tUser.toMap();

      expect(map['uid'], 'uid-001');
      expect(map['name'], 'Siti Rahma');
      expect(map['email'], 'siti@example.com');
      expect(map['role'], 'Cashier');
      expect(map['approved'], true);
      expect(map['active'], true);
    });

    test('toMap() mengandung tepat 6 field', () {
      final map = tUser.toMap();

      expect(map.keys.length, 6);
    });

    test('toMap() untuk role Owner', () {
      final owner = UserModel(
        uid: 'uid-owner',
        name: 'Bos Besar',
        email: 'owner@cafe.id',
        role: 'Owner',
        approved: true,
        active: true,
      );

      expect(owner.toMap()['role'], 'Owner');
    });

    test('toMap() untuk role Manager', () {
      final manager = UserModel(
        uid: 'uid-mgr',
        name: 'Ahmad Manager',
        email: 'mgr@cafe.id',
        role: 'Manager',
        approved: true,
        active: true,
      );

      expect(manager.toMap()['role'], 'Manager');
    });

    test('toMap() untuk akun yang belum aktif', () {
      final inactiveUser = UserModel(
        uid: 'uid-inactive',
        name: 'User Baru',
        email: 'baru@cafe.id',
        role: 'Cashier',
        approved: false,
        active: false,
      );

      final map = inactiveUser.toMap();

      expect(map['approved'], false);
      expect(map['active'], false);
    });

    // ── field access ──────────────────────────────────────────────────────

    test(
      'field uid, name, email, role, approved, active terbaca dengan benar',
      () {
        expect(tUser.uid, 'uid-001');
        expect(tUser.name, 'Siti Rahma');
        expect(tUser.email, 'siti@example.com');
        expect(tUser.role, 'Cashier');
        expect(tUser.approved, true);
        expect(tUser.active, true);
      },
    );
  });
}
