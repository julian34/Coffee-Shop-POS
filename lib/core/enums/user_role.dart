enum UserRole {
  owner,
  manager,
  cashier,
  unknown;

  static UserRole fromString(String? value) {
    switch (value) {
      case 'Owner':
        return UserRole.owner;
      case 'Manager':
        return UserRole.manager;
      case 'Cashier':
        return UserRole.cashier;
      default:
        return UserRole.unknown;
    }
  }

  String get label {
    switch (this) {
      case UserRole.owner:
        return 'Owner';
      case UserRole.manager:
        return 'Manager';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.unknown:
        return 'Unknown';
    }
  }
}
