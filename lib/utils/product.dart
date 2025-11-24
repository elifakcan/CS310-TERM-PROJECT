class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final List<String> sizes;
  final String color;
  final String composition;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.sizes,
    required this.color,
    required this.composition,
  });
}
