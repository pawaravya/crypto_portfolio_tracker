class Coin {
  final String? id;
  final String? symbol;
  final String? name;
  double? price;
  int? selectedQuantuty;
  Coin({this.id, this.symbol, this.name, this.selectedQuantuty, this.price});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String?,
      symbol: json['symbol'] as String?,
      name: json['name'] as String?,
    price:json["price"] ?? 0.00,
       selectedQuantuty:    json["selectedQuantoty"] ?? 1
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'symbol': symbol, 'name': name , "price" : price , "selectedQuantoty": selectedQuantuty};
}
