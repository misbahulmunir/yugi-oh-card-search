# Yu-Gi-Oh! Card Search App Demo

This document provides examples of how to use the Yu-Gi-Oh! Card Search application.

## Card Search Examples

### Example 1: Search for "Blue-Eyes White Dragon"
1. Open the app and go to the "Search Cards" tab
2. Enter "Blue-Eyes White Dragon" in the search field
3. Press Enter
4. Expected results:
   - Card name: Blue-Eyes White Dragon
   - Type: Normal Monster
   - Attribute: LIGHT
   - Race: Dragon
   - Level: 8
   - ATK: 3000
   - DEF: 2500
   - Description: This legendary dragon is a powerful engine of destruction...

### Example 2: Search for "Dark Magician"
1. Enter "Dark Magician" in the search field
2. Press Enter
3. Expected results:
   - Card name: Dark Magician
   - Type: Normal Monster
   - Attribute: DARK
   - Race: Spellcaster
   - Level: 7
   - ATK: 2500
   - DEF: 2100

### Example 3: Search for "Pot of Greed"
1. Enter "Pot of Greed" in the search field
2. Press Enter
3. Expected results:
   - Card name: Pot of Greed
   - Type: Normal Spell
   - Description: Draw 2 cards.

## Deck Search Examples

### Example 1: Search for Deck ID "12345"
1. Go to the "Search Decks" tab
2. Enter "12345" in the search field
3. Press Enter
4. Expected results:
   - Deck ID: 12345
   - Main Deck: List of cards
   - Extra Deck: List of cards (if any)
   - Side Deck: List of cards (if any)

### Example 2: Search for Deck ID "67890"
1. Enter "67890" in the search field
2. Press Enter
3. Expected results:
   - Deck ID: 67890
   - Card lists for each deck section

## Popular Card Names to Try

- Blue-Eyes White Dragon
- Dark Magician
- Red-Eyes Black Dragon
- Exodia the Forbidden One
- Pot of Greed
- Monster Reborn
- Mirror Force
- Raigeki
- Harpie's Feather Duster
- Solemn Judgment

## Popular Deck IDs to Try

Note: Deck IDs are dynamic and may change. Try searching for:
- 12345
- 67890
- 11111
- 22222
- 33333

## Features to Test

### Card Search Features:
- [ ] Search by exact card name
- [ ] Search by partial card name
- [ ] View card images
- [ ] View card details
- [ ] Handle search errors
- [ ] Clear search results

### Deck Search Features:
- [ ] Search by deck ID
- [ ] View deck composition
- [ ] View individual cards in deck
- [ ] Handle invalid deck IDs
- [ ] Clear search results

### General Features:
- [ ] Bottom navigation
- [ ] Loading indicators
- [ ] Error messages
- [ ] Responsive design
- [ ] Image caching

## Troubleshooting

### Common Issues:

1. **No cards found**
   - Check spelling of card name
   - Try partial names
   - Ensure internet connection

2. **No deck found**
   - Verify deck ID is correct
   - Try different deck IDs
   - Check internet connection

3. **Images not loading**
   - Check internet connection
   - Wait for images to load
   - App will show placeholder icons

4. **App crashes**
   - Restart the app
   - Check Flutter installation
   - Verify dependencies are installed

## API Information

The app uses the Yu-Gi-Oh! API from YGOPRODeck:
- Base URL: https://db.ygoprodeck.com/api/v7/
- Card search: cardinfo.php?fname={name}
- Deck search: deck.php?deck_id={id}

For more information, visit: https://ygoprodeck.com/api-guide/ 