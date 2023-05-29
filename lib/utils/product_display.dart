import 'package:expirydatefyp/liblist/my_lib.dart';
import 'package:intl/intl.dart';

class FirestoreListView extends StatefulWidget {
  final String uid;
  final ValueNotifier<DateTime?> selectedDateNotifier;

  const FirestoreListView(
      {Key? key, required this.uid, required this.selectedDateNotifier})
      : super(key: key);

  @override
  FirestoreListViewState createState() => FirestoreListViewState();
}

class FirestoreListViewState extends State<FirestoreListView> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    widget.selectedDateNotifier.addListener(() {
      setState(() {
        selectedDate = widget.selectedDateNotifier.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('products')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SpinKitPianoWave(
            color: Colors.white,
            size: 50.0,
          );
        } else {
          var documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return const Text("No Product");
          } else {
            List<DocumentSnapshot> filteredDocuments;
            if (selectedDate != null) {
              String targetDate = DateFormat('dd/MM/yy').format(selectedDate!);
              filteredDocuments = documents.where((product) {
                String productDate =
                    DateFormat('dd/MM/yy').format(product['expDate'].toDate());
                return productDate == targetDate;
              }).toList();
            } else {
              filteredDocuments = documents;
            }

            return ListView.builder(
              itemCount: filteredDocuments.length,
              itemBuilder: (context, index) {
                DocumentSnapshot products = filteredDocuments[index];
                String formattedDate =
                    DateFormat('dd/MM/yy').format(products['expDate'].toDate());
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: CustomColors.mintWhite,
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: ListTile(
                    title: Text(
                      products['productName'],
                      style: CustomColors.headtext,
                    ),
                    subtitle: Text(
                      products['productDisc'],
                      style: CustomColors.disctext,
                    ),
                    trailing: Text(
                      formattedDate,
                      style: CustomColors.datetext,
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
