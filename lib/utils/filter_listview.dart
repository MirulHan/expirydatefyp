import '../liblist/my_lib.dart';
import 'package:intl/intl.dart';

typedef ProductFilter = bool Function(DocumentSnapshot product);

class FirestoreFilteredListView extends StatelessWidget {
  final String uid;
  final ProductFilter filter;

  const FirestoreFilteredListView(
      {Key? key, required this.uid, required this.filter})
      : super(key: key);

  Stream<List<DocumentSnapshot>> getProductsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: getProductsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SpinKitFadingCube(
            color: Colors.white,
            size: 50.0,
          );
        } else {
          var documents = snapshot.data!;

          if (documents.isEmpty) {
            return const Text("No Product");
          } else {
            List<DocumentSnapshot> filteredDocuments =
                documents.where(filter).toList();

            return ListView.builder(
              itemCount: filteredDocuments.length,
              itemBuilder: (context, index) {
                DocumentSnapshot product = filteredDocuments[index];
                String formattedDate =
                    DateFormat('dd/MM/yy').format(product['expDate'].toDate());

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: CustomColors.mintWhite,
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: ListTile(
                    title: Text(
                      product['productName'],
                      style: CustomColors.headtext,
                    ),
                    subtitle: Text(
                      product['productDisc'],
                      style: CustomColors.disctext,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedDate,
                          style: CustomColors.datetext,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('products')
                                .doc(product.id)
                                .delete();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
