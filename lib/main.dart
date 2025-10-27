import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShoppingListPage(),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  // Controllers for TextFields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // List to store shopping items
  List<Map<String, dynamic>> shoppingItems = [];

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // Function to add item to the list
  void _addItem() {
    String itemName = _itemController.text.trim();
    String quantityText = _quantityController.text.trim();

    // Validate input
    if (itemName.isEmpty || quantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both item name and quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Try to parse quantity as integer
    int? quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive number for quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      // Add item to list
      shoppingItems.add({
        'name': itemName,
        'quantity': quantity,
      });

      // Clear the TextFields
      _itemController.clear();
      _quantityController.clear();
    });
  }

  // Function to show delete confirmation dialog
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Do you want to delete "${shoppingItems[index]['name']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  shoppingItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // ListPage function to build the shopping list UI
  Widget listPage() {
    return Column(
      children: [
        // Input section with TextFields and Add button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Item name TextField
              Flexible(
                flex: 2,
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    labelText: 'Type the item here',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Quantity TextField
              Flexible(
                flex: 2,
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Type the quantity here',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              // Add button
              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Click here'),
              ),
            ],
          ),
        ),

        // ListView section
        Expanded(
          child: shoppingItems.isEmpty
              ? const Center(
            child: Text(
              'There are no items in the list',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: shoppingItems.length,
            itemBuilder: (context, rowNum) {
              return GestureDetector(
                onLongPress: () {
                  _showDeleteDialog(rowNum);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Row number and item name
                        Expanded(
                          child: Text(
                            '${rowNum + 1}: ${shoppingItems[rowNum]['name']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        // Right side: Quantity
                        Text(
                          'quantity: ${shoppingItems[rowNum]['quantity']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      body: listPage(),
    );
  }
}