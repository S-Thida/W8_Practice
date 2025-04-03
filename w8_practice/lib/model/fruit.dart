class Fruit {
  final String id;
  final String name;
  final double price;

  Fruit({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    return other is Fruit && other.id == id;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode;
}