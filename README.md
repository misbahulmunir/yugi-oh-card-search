# Yu-Gi-Oh! Card Search App

A Flutter application that allows users to search for Yu-Gi-Oh! cards and decks using the Yu-Gi-Oh! API.

## Features

### Card Search
- Search for Yu-Gi-Oh! cards by name
- View card images, details, and descriptions
- Display card attributes like ATK, DEF, Level, Type, Race, and Attribute
- Modern, responsive UI with card thumbnails

### Deck Search
- Search for decks by deck ID
- View deck composition (Main Deck, Extra Deck, Side Deck)
- See all cards in each deck section

### User Interface
- Bottom navigation for easy switching between card and deck search
- Material Design 3 with modern styling
- Loading indicators and error handling
- Cached network images for better performance
- Responsive design that works on different screen sizes

## API Endpoints Used

The application uses the following Yu-Gi-Oh! API endpoints:

1. **Card Search**: `https://db.ygoprodeck.com/api/v7/cardinfo.php?fname={card_name}`
   - Searches for cards by name
   - Returns card data including images, stats, and descriptions

2. **Deck Search**: `https://db.ygoprodeck.com/api/v7/deck.php?deck_id={deck_id}`
   - Retrieves deck information by deck ID
   - Returns deck composition with main, extra, and side deck cards

## Getting Started

### Prerequisites
- Flutter SDK (version 3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone or download this project
2. Navigate to the project directory:
   ```bash
   cd yugioh_card_search
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Usage

### Searching for Cards
1. Tap on the "Search Cards" tab
2. Enter a card name in the search field (e.g., "Blue-Eyes White Dragon")
3. Press Enter or tap the search icon
4. View the search results with card thumbnails
5. Tap on any card to see detailed information

### Searching for Decks
1. Tap on the "Search Decks" tab
2. Enter a deck ID in the search field
3. Press Enter or tap the search icon
4. View the deck information
5. Tap on the deck to see all cards in the deck

## Dependencies

- `flutter`: The Flutter framework
- `http`: For making HTTP requests to the Yu-Gi-Oh! API
- `cached_network_image`: For efficient image loading and caching
- `cupertino_icons`: For iOS-style icons

## API Information

This application uses the Yu-Gi-Oh! API provided by YGOPRODeck. For more information about the API and available endpoints, visit:
- API Guide: https://ygoprodeck.com/api-guide/
- API Documentation: https://db.ygoprodeck.com/api-guide/

## Features in Detail

### Card Details Dialog
When you tap on a card, a detailed dialog shows:
- High-resolution card image
- Card name and type
- Race and attribute
- Level (for monsters)
- ATK and DEF values (for monsters)
- Full card description

### Deck Details Dialog
When you tap on a deck, a detailed dialog shows:
- Deck ID
- Main deck cards list
- Extra deck cards list
- Side deck cards list

### Error Handling
The application includes comprehensive error handling:
- Network connection errors
- Invalid search queries
- No results found
- API rate limiting

### Performance Optimizations
- Cached network images for faster loading
- Efficient list rendering
- Proper state management
- Memory leak prevention

## Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Improving the UI/UX
- Adding more search options

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Yu-Gi-Oh! API by YGOPRODeck
- Flutter team for the amazing framework
- The Yu-Gi-Oh! community for inspiration
