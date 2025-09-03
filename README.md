# Hotel Management System (HKMS)

This is a comprehensive hotel management system built with Ruby on Rails that handles various aspects of hotel operations.

## System Overview

The application follows the Model-View-Controller (MVC) architecture pattern with a layered approach:

1. **Frontend**: Uses Rails' built-in view system with HTML, CSS, and JavaScript
2. **Backend**: Ruby on Rails framework with controllers handling business logic
3. **Database**: SQLite for data storage with ActiveRecord ORM
4. **Authentication**: Session-based authentication for different user roles

## Key Features

### User Roles
The system supports multiple user roles:
- **Admin**: System administrator with full access
- **Customer**: Hotel guests who place orders
- **Chef/Kitchen Staff**: Prepares food orders
- **Cashier**: Handles billing and payments
- **Store Keeper**: Manages inventory and supplies
- **Manager**: Oversees operations and inventory

### Main Functional Areas

#### Customer Journey
1. Entry Point: Customers access the system through the splash screen
2. Role Selection: Customers select their role
3. Table Selection: Customers choose a table either by scanning a QR code or manual selection
4. Menu Browsing: View current menu items
5. Order Placement: Add items to their order and place it
6. Order Tracking: Monitor order status (pending → cooking → ready)
7. Payment: Receive bill from cashier
8. Feedback: Provide feedback on their experience

#### Other Roles
- **Kitchen Operations**: Dashboard for viewing and processing orders
- **Cashier Operations**: Billing and payment processing
- **Store Keeper Functions**: Inventory management
- **Manager Functions**: Overview dashboard and menu management
- **Admin Functions**: User management and system analytics

## Technology Stack

- Ruby on Rails 8.0
- SQLite Database
- Bootstrap 5 for UI
- Hotwire (Turbo and Stimulus)
- Puma Web Server

## How to Run

1. Install Ruby and Rails dependencies
2. Run database migrations: `rails db:migrate`
3. Start the server: `rails server`
4. Access the application at `http://localhost:3000`