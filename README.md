# Tech Gadol — Product Catalog App

A Flutter application that displays a product catalog using a custom design system, consuming data from the DummyJSON Products API.

## 1. Setup & Run Instructions

**Flutter version:** 3.35.3 (stable channel)

```bash
# Clone the repository
git clone <repo-url>
cd tech_gadol

# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run analysis
flutter analyze
```

No additional setup is required. The app uses the public DummyJSON API (`https://dummyjson.com`) — no API keys or environment variables needed.

## 2. Architecture Overview

### Folder Structure

```
lib/
├── core/
│   ├── extensions/          # BuildContext extensions (responsive breakpoints)
│   ├── routing/             # GoRouter config + centralized route paths
│   ├── services/
│   │   ├── api_services/    # Dio HTTP client, connectivity wrapper, API constants
│   │   └── local_storage_services/  # Hive-based product cache
│   ├── theme/               # AppColors, LightTheme, DarkTheme
│   └── widgets/             # Design system components (reusable across features)
├── features/
│   ├── products/
│   │   ├── data/
│   │   │   ├── models/      # ProductModel, ProductsResponse
│   │   │   └── repositories/ # ProductRepository (API + cache integration)
│   │   └── presentation/
│   │       ├── bloc/         # ProductsBloc, events, state
│   │       └── views/        # Screens (list, detail, responsive layout)
│   └── showcase/
│       └── presentation/views/  # Component showcase screen
├── app.dart                  # Root widget with BLoC providers + MaterialApp.router
└── main.dart                 # Entry point + Hive init
```

### Architecture Pattern

**Feature-first** with clean separation of data and presentation layers per feature:

- **Data layer:** Models with JSON parsing + validation, Repository pattern wrapping API calls with caching
- **Presentation layer:** BLoC for state management, screens consume state via `BlocBuilder`

### State Management

**BLoC (flutter_bloc)** with Equatable for predictable, testable state:

- Single `ProductsBloc` manages products, categories, search, pagination, and product selection
- All states handled explicitly: `initial`, `loading`, `loaded`, `error`
- Timer-based search debounce (300ms) — no extra dependency
- Combined search + category filtering (client-side filtering when both active, since DummyJSON doesn't support this server-side)

### Navigation

**GoRouter** with centralized route definitions in `AppRoutes`:

- `/products` — product list (responsive layout)
- `/products/:id` — product detail (deep linking supported)
- `/showcase` — component showcase (debug)
- Responsive master-detail layout handled at the routing level: wide screens (≥768px) show side-by-side, narrow screens use push navigation

### Networking

**Dio** singleton with:

- Per-request cancel tokens
- Comprehensive error mapping (`ErrorEntity`)
- Connectivity check before every request (via `connectivity_plus`)
- Toast notification when offline
- Repository-level `try/catch` with `debugPrintStack` for traceability

## 3. Design System Rationale

### Component API

All design system widgets live in `core/widgets/` and are theme-aware (they read colors/styles from `Theme.of(context)` rather than hardcoding values):

| Component | Purpose |
|---|---|
| `AppSearchBar` | Text field with clear button, delegates debounce to BLoC |
| `CategoryChip` | `FilterChip` that formats slug labels (e.g. `smart-phones` → `Smart Phones`) |
| `ProductCard` | Horizontal card with thumbnail, title, brand, price, rating, stock indicator |
| `PriceTag` | Displays price with discount badge; shows "Price unavailable" for invalid prices |
| `RatingBar` | 5-star display with half-star support |
| `CachedImage` | `CachedNetworkImage` wrapper with loading spinner and error placeholder |
| `ShimmerLoading` | Skeleton placeholder cards matching `ProductCard` layout |
| `ErrorState` | Error icon + message + retry button |
| `EmptyState` | Empty results icon + message |
| `StaggeredListItem` | Fade+slide animation wrapper for list items |

### Theming

- Full light and dark themes using Material 3 (`ColorScheme`, text theme, card/chip/input decoration themes)
- System theme mode by default (`ThemeMode.system`)
- Showcase screen includes an independent light/dark toggle for testing

### Data Validation

Handled in `ProductModel.fromJson` with sensible defaults:

- Missing brand → `"Unknown brand"` + warning log
- Missing/negative price → stored as `-1`, UI shows `"Price unavailable"` + error log
- Invalid image URLs → filtered out + warning log
- Missing title → `"Untitled Product"`
- Rating → clamped between 0–5

## 4. Limitations

With more time, I would improve:

- **Domain layer:** Add use cases (e.g. `GetProductsUseCase`) and repository interfaces for full clean architecture
- **Dependency injection:** Use `get_it` or `injectable` instead of manual constructor injection
- **Search + category:** Currently does client-side filtering when both are active. Ideally the API would support this natively
- **Offline support depth:** Currently only caches the first page of products and categories. Could cache all paginated pages and individual product details
- **Test coverage:** Add integration tests, golden tests for design system components, and test the responsive layout breakpoints
- **Accessibility:** Add semantic labels to images, ensure proper contrast ratios
- **Error messages:** Make user-facing error messages more specific (network timeout vs server error vs no internet)

## 5. AI Tools Usage

The AI mainly used was claude,
it was a fair experience, used to help me cut down development time alot,
but it made the following mistakes:
- Wrong theme usage on the app
- Incomplete error handling on API calls
- Wrong use of Hero widgets that threw exceptions all of the console

So, for some, I had to manually edit or re-query giving out specific guideliness on how to edit and go about them.

<!-- Fill in your own experience here -->
