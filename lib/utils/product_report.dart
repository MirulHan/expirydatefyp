import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class ProductReport extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductReport({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // Group products by month
    var groupedProducts = groupBy(products, (product) {
      Timestamp timestamp = product['expDate']; // get the timestamp
      DateTime date = timestamp.toDate(); // convert the timestamp to DateTime
      return DateTime(date.year,
          date.month); // Returns a DateTime with only year and month for grouping
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Report'),
      ),
      body: ListView.builder(
        itemCount: groupedProducts.keys.length,
        itemBuilder: (ctx, index) {
          var date = groupedProducts.keys.elementAt(index);
          var productsForMonth = groupedProducts[date]!;

          return ExpansionTile(
            title: Text('${date.month}/${date.year}'),
            children: productsForMonth.map((product) {
              return ListTile(
                title: Text(product[
                    'productName']), // assuming you have a productName field
                // add other product fields here...
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
