# Currency Converter App

A Flutter application for converting currencies using a Go backend that fetches data from a public API.

# Features

- Convert between major world currencies (BRL, USD, EUR, GBP, etc.)

- Real-time exchange rates fetched via a Go backend

- Simple and intuitive Flutter UI

- Supports multiple currencies with automatic updates

# Architecture

- Frontend: Flutter

- Backend: Go

The Flutter app communicates with the Go backend to fetch the latest exchange rates, keeping the UI lightweight and responsive.

# Installation

### Frontend (Flutter)
```
git clone github.com/VitorFranciscoDev/CurrencyConverter

cd CurrencyConverter

flutter pub get

usecases/currency_converter.dart
- use your [IP] where is marked

flutter run

Make sure the backend server is running and accessible by the app.
```

### Backend (Go)

```
go to github.com/VitorFranciscoDev/CurrencyConverterAPI to install
```

# Usage

1. Open the app.

2. Select the currency you want to convert from and to.

3. Enter the amount.

4. See the converted value instantly.
