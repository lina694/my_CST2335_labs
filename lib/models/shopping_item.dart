/// Model class representing a shopping item.
/// Contains methods to convert to/from database map.
class ShoppingItem {
  int? id;
  String name;

  /// Constructor
  ShoppingItem({this.id, required this.name});

  /// Convert ShoppingItem to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Create ShoppingItem from database Map
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'],
      name: map['name'],
    );
  }

  /// String representation for display
  @override
  String toString() {
    return name;
  }

  /// Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}