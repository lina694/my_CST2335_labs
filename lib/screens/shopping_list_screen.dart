import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../database/database_helper.dart';

/// Main screen for shopping list application.
/// Displays list of items and allows adding/deleting items.
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _textController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<ShoppingItem> _shoppingList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItemsFromDatabase();
  }

  /// Load all items from database when app starts
  /// Requirement: Items should load when application restarts (1 mark)
  Future<void> _loadItemsFromDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<ShoppingItem> items = await _dbHelper.getAllItems();
      setState(() {
        _shoppingList = items;
        _isLoading = false;
      });

      // Show toast message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded ${items.length} items from database'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading items: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Add new item to list and database
  /// Requirement: Add button saves to database (1 mark)
  Future<void> _addItem() async {
    String itemName = _textController.text.trim();

    // Validate input
    if (itemName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create new shopping item
    ShoppingItem newItem = ShoppingItem(name: itemName);

    try {
      // Insert into database and get generated id
      int id = await _dbHelper.insertItem(newItem);
      newItem.id = id;

      // Update UI
      setState(() {
        _shoppingList.add(newItem);
      });

      // Clear text field
      _textController.clear();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Delete item from list and database
  /// Requirement: Delete from database on long press (1 mark)
  Future<void> _deleteItem(int index) async {
    ShoppingItem itemToDelete = _shoppingList[index];

    // Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete "${itemToDelete.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion
    if (confirm == true) {
      try {
        // Delete from database
        await _dbHelper.deleteItem(itemToDelete.id!);

        // Update UI
        setState(() {
          _shoppingList.removeAt(index);
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item deleted'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting item: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Input section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter item name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Instructions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Long press to delete item',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Shopping list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _shoppingList.isEmpty
                ? const Center(
              child: Text(
                'No items yet.\nAdd your first item!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      _shoppingList[index].name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(
                      Icons.shopping_cart,
                      color: Colors.grey,
                    ),
                    onLongPress: () => _deleteItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}