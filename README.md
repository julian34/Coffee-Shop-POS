# pos_coffee_shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Features

1. Order Management: Add, edit, and remove orders.
2. Menu Management: Display items with images, prices, and descriptions.
3. Payment Processing: Accept cash, credit, and digital payments.
4. Receipts & Invoices: Generate receipts for customers.
5. Sales Analytics: Track daily, weekly, and monthly sales.
6. Inventory Management: Keep track of stock levels.
7. User Authentication: Secure access for staff and admins.
8. Table & Takeaway Orders: Differentiate between dine-in and takeaway.
9. Printer & QR Code Integration: Print receipts and generate QR codes for mobile payments.

lib/
│── main.dart # Entry point of the app
│
├── core/ # Core configurations & constants
│ ├── app_constants.dart # App-wide constants
│ ├── theme.dart # Theme & styling
│ ├── routes.dart # Navigation routes
│
├── models/ # Data models
│ ├── user_model.dart # User model
│ ├── product_model.dart # Product model
│ ├── order_model.dart # Order model
│
├── services/ # Business logic & API calls
│ ├── auth_service.dart # Authentication service (Firebase)
│ ├── product_service.dart # Fetch products from Firestore
│ ├── order_service.dart # Handle orders & payments
│ ├── payment_service.dart # Stripe/Razorpay payment logic
│ ├── print_service.dart # Print receipts & invoices
│
├── providers/ # State management (Provider/Riverpod)
│ ├── auth_provider.dart # Authentication state
│ ├── cart_provider.dart # Shopping cart logic
│ ├── order_provider.dart # Orders state
│
├── screens/ # UI screens
│ ├── auth/  
│ │ ├── login_screen.dart # Login screen
│ │ ├── register_screen.dart # Register screen
│ │
│ ├── home/  
│ │ ├── home_screen.dart # Home screen with menu
│ │ ├── product_details.dart # Product details screen
│ │
│ ├── cart/  
│ │ ├── cart_screen.dart # Cart summary
│ │ ├── checkout_screen.dart # Checkout process
│ │
│ ├── orders/  
│ │ ├── orders_screen.dart # List of past orders
│ │ ├── order_details.dart # Order details & invoice
│ │
│ ├── admin/  
│ │ ├── admin_dashboard.dart # Admin panel
│ │ ├── manage_products.dart # Add/edit/delete products
│ │ ├── sales_report.dart # View sales & analytics
│
├── widgets/ # Reusable UI components
│ ├── custom_button.dart # Custom button widget
│ ├── product_card.dart # Product item card
│ ├── order_tile.dart # Order list item
│
├── utils/ # Utility functions/helpers
│ ├── format_utils.dart # Currency, date formatters
│ ├── qr_utils.dart # QR code generation
│ ├── pdf_utils.dart # Generate PDF receipts
│
├── database/ # Local storage (SQLite)
│ ├── db_helper.dart # SQLite database helper
│ ├── product_dao.dart # Product data access object
│ ├── order_dao.dart # Order data access object
│
└── assets/ # Static assets (images, fonts, etc.)
├── images/ # Image assets
├── fonts/ # Custom fonts
├── icons/ # App icons

## Documentation

- [UML diagrams: use case, class, and sequence](docs/uml-diagrams.md)
