class Product {
  final String description;
  final double netPrice;
  final double vatRate;
  final String currency;

  Product({
    required this.description,
    required this.netPrice,
    required this.vatRate,
    required this.currency,
  });

  double get vatPrice => netPrice * (vatRate / 100);

  double get grossPrice => netPrice + vatPrice;
}

class Invoice {
  final String invoiceNumber;
  final String issueDate;
  final String saleDate;
  final String seller;
  final String buyer;
  final List<Product> productList;
  final String additionalDescription;

  Invoice({
    required this.invoiceNumber,
    required this.issueDate,
    required this.saleDate,
    required this.seller,
    required this.buyer,
    required this.productList,
    required this.additionalDescription,
  });
}

final exampleInvoice = Invoice(
  invoiceNumber: 'FV2024-03',
  saleDate: '30.03.2024',
  issueDate: '11.04.2024',
  seller: 'Aron Soft sp. z o.o.\nŚw. Wojciecha 29A/3\n33-100 Tarnów\nPolska\nNIP: 7773375421',
  buyer: 'Mancen Sławomir - PHU Gorzelnia Mancen\nul. Prześmieszna 40\n99-001 Słupsk\nPolska\nNIP: PL 112233445566',
  productList: [
    Product(
      description: 'Usługi programistyczne',
      netPrice: 25000.0,
      vatRate: 23.0,
      currency: 'PLN',
    ),
  ],
  additionalDescription: 'Termin płatności 30.04.2024\nKonto bankowe 11 2222 3333 4444 5555 6666',
);
