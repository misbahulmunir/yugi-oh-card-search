import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const YugiohCardSearchApp());
}

class YugiohCardSearchApp extends StatelessWidget {
  const YugiohCardSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yu-Gi-Oh! Card Search',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9C27B0), // Purple
          secondary: Color(0xFFE1BEE7), // Light Purple
          surface: Color(0xFF1A1A1A), // Dark surface
          background: Color(0xFF121212), // Dark background
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2D2D2D),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9C27B0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF424242)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
          ),
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9C27B0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yu-Gi-Oh! Card Search'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          CardSearchPage(),
          DeckSearchPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFF9C27B0),
        unselectedItemColor: const Color(0xFF9E9E9E),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.deck),
            label: 'Search Decks',
          ),
        ],
      ),
    );
  }
}

class CardSearchPage extends StatefulWidget {
  const CardSearchPage({super.key});

  @override
  State<CardSearchPage> createState() => _CardSearchPageState();
}

class _CardSearchPageState extends State<CardSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchCards(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          // Handle both array and object responses
          if (data is List) {
            _searchResults = data;
          } else if (data is Map && data.containsKey('data')) {
            _searchResults = data['data'] ?? [];
          } else {
            _searchResults = [];
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No cards found for "$query"';
          _searchResults = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching for cards: $e';
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for cards...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchResults = [];
                        _errorMessage = null;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: _searchCards,
              ),
              const SizedBox(height: 8),

            ],
          ),
        ),
        
        // Results section
        Expanded(
          child: _buildResultsSection(),
        ),
      ],
    );
  }



  Future<Uint8List?> _loadImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      // Return null if image loading fails
    }
    return null;
  }

  Widget _buildSimpleCardImage(Map<String, dynamic> card) {
    try {
      if (card['card_images'] != null && card['card_images'].isNotEmpty) {
        final imageData = card['card_images'][0];
        final imageUrl = imageData['image_url'];
        
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FutureBuilder<Uint8List?>(
                future: _loadImageBytes(imageUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 60,
                      height: 80,
                      color: const Color(0xFF424242),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      width: 60,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  }
                  
                  return Container(
                    width: 60,
                    height: 80,
                    color: const Color(0xFF424242),
                    child: const Icon(Icons.image, color: Color(0xFF9E9E9E)),
                  );
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      // If any error occurs, return fallback
    }
    
    // Fallback for no image
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: Color(0xFF9E9E9E)),
    );
  }

  Widget _buildDetailCardImage(Map<String, dynamic> card) {
    try {
      if (card['card_images'] != null && card['card_images'].isNotEmpty) {
        final imageData = card['card_images'][0];
        final imageUrl = imageData['image_url'];
        
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return FutureBuilder<Uint8List?>(
            future: _loadImageBytes(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  color: const Color(0xFF424242),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (snapshot.hasData && snapshot.data != null) {
                return Image.memory(
                  snapshot.data!,
                  height: 200,
                  fit: BoxFit.contain,
                );
              }
              
              return Container(
                height: 200,
                color: const Color(0xFF424242),
                child: const Icon(Icons.image, size: 50, color: Color(0xFF9E9E9E)),
              );
            },
          );
        }
      }
    } catch (e) {
      // If any error occurs, return fallback
    }
    
    // Fallback for no image
    return Container(
      height: 200,
      color: const Color(0xFF424242),
      child: const Icon(Icons.image, size: 50, color: Color(0xFF9E9E9E)),
    );
  }



    Widget _buildResultsSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color(0xFF3E2723),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Color(0xFFEF5350)),
            ),
          ),
        ),
      );
    }
    
    if (_searchResults.isNotEmpty) {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final card = _searchResults[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: _buildSimpleCardImage(card),
              title: Text(
                card['name'] ?? 'Unknown Card',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                card['type'] ?? 'Unknown Type',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              onTap: () {
                _showCardDetails(card);
              },
            ),
          );
        },
      );
    }
    
    // Default state
    return const Center(
      child: Text(
        'Search for Yu-Gi-Oh! cards to see results',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  void _showCardDetails(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(card['name'] ?? 'Unknown Card'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (card['card_images'] != null &&
                  card['card_images'].isNotEmpty)
                Center(
                  child: _buildDetailCardImage(card),
                ),
              const SizedBox(height: 16),
              _buildDetailRow('Type', card['type'] ?? 'Unknown'),
              _buildDetailRow('Race', card['race'] ?? 'Unknown'),
              _buildDetailRow('Attribute', card['attribute'] ?? 'Unknown'),
              if (card['level'] != null)
                _buildDetailRow('Level', card['level'].toString()),
              if (card['atk'] != null)
                _buildDetailRow('ATK', card['atk'].toString()),
              if (card['def'] != null)
                _buildDetailRow('DEF', card['def'].toString()),
              if (card['desc'] != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(card['desc']),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class DeckSearchPage extends StatefulWidget {
  const DeckSearchPage({super.key});

  @override
  State<DeckSearchPage> createState() => _DeckSearchPageState();
}

class _DeckSearchPageState extends State<DeckSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchDecks(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://db.ygoprodeck.com/api/v7/deck.php?deck_id=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = [data]; // Wrap in list for consistency
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No deck found with ID "$query"';
          _searchResults = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching for deck: $e';
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter deck ID...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResults = [];
                    _errorMessage = null;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: _searchDecks,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            )
          else if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final deck = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        'Deck ID: ${deck['deck_id'] ?? 'Unknown'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Main Deck: ${deck['main']?.length ?? 0} cards'),
                          Text('Extra Deck: ${deck['extra']?.length ?? 0} cards'),
                          Text('Side Deck: ${deck['side']?.length ?? 0} cards'),
                        ],
                      ),
                      onTap: () {
                        _showDeckDetails(deck);
                      },
                    ),
                  );
                },
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Enter a deck ID to search for decks',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeckDetails(Map<String, dynamic> deck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deck ID: ${deck['deck_id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (deck['main'] != null && deck['main'].isNotEmpty) ...[
                const Text(
                  'Main Deck:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...deck['main'].map<Widget>((card) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• ${card['name']}'),
                    )),
                const SizedBox(height: 16),
              ],
              if (deck['extra'] != null && deck['extra'].isNotEmpty) ...[
                const Text(
                  'Extra Deck:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...deck['extra'].map<Widget>((card) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• ${card['name']}'),
                    )),
                const SizedBox(height: 16),
              ],
              if (deck['side'] != null && deck['side'].isNotEmpty) ...[
                const Text(
                  'Side Deck:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...deck['side'].map<Widget>((card) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• ${card['name']}'),
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
