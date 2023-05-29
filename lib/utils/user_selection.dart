import 'package:expirydatefyp/utils/product_report.dart';

import '../liblist/my_lib.dart';

class UserSelection extends StatelessWidget {
  const UserSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['username']),
              onTap: () {
                // Save context and id for later use
                final ctx = context;
                final userId = document.id;

                // Run async operation
                () async {
                  // Get the user's products
                  QuerySnapshot productSnapshot = await FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(userId)
                      .collection('products')
                      .get();

                  // Map the products to a list of maps
                  List<Map<String, dynamic>> products = productSnapshot.docs
                      .map((product) => product.data() as Map<String, dynamic>)
                      .toList();

                  // Navigate to the ProductReport screen
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (context) => ProductReport(products: products),
                    ),
                  );
                }();
              },
            );
          }).toList(),
        );
      },
    );
  }
}
