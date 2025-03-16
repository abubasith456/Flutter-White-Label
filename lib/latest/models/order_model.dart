class OrderModel {
  final String id;
  final String status;
  final String date;
  final double total;
  final List<String> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.date,
    required this.total,
    required this.items,
  });
}