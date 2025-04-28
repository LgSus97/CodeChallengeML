# CodeChallengeML

A simple iOS application built with Swift that allows users to search for products on Mercado Libre and view their details.  
Created as part of a technical challenge.

---

## 🛠️ Architecture

The project follows the **VIP Architecture** (View - Interactor - Presenter).  
This architecture ensures a clear separation of concerns, making the codebase easier to maintain, scale, and test.

- **ViewController**: Displays data and handles user interactions.
- **Interactor**: Manages business logic and coordinates data fetching.
- **Presenter**: Prepares and formats data for display.
- **Entity**: Defines the data models used throughout the application.
- **Router**: Handles navigation and module assembly.

---

## 📚 Dependencies

- **RealmSwift**:  
  Used for local persistence, storing favorite products and search history.

- **Kingfisher**:  
  Used to asynchronously download and cache product images.

---

## 🖎️ Main Features

- **Product Search**:  
  Search for products by name using Mercado Libre's API.

- **Search History Persistence**:  
  The app saves and displays the last 10 search queries.

- **Filtering**:  
  Apply filters by brand and color to refine the product list.

- **Product Details**:  
  View a simple preview of each product with its image, name, price (simulated), and stock status (simulated).

- **Favorites Management**:
  - Mark or unmark products as favorites.
  - Navigate to the Favorites tab to view saved products.
  - Preview favorite products and remove them from the list.

---

## 🎬 Demo

<img src="https://github.com/user-attachments/assets/428aea18-57cf-4dc8-a244-737c2c375adf" alt="Watch the demo" width="500"/>


## ✨ Notes

- The price and stock availability are randomly generated for demonstration purposes.
- The app is designed for future scalability with minimal adjustments required to support pagination, more filters, or deeper navigation flows.

---



