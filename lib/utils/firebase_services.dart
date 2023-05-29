import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUsername() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user currently signed in');
    }

    String uid = user.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      if (data != null && data['username'] != null) {
        return data['username'];
      } else {
        throw Exception('Username not found');
      }
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<DateTime>> getProductExpiryDates() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user currently signed in');
    }
    String uid = user.uid;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('products')
        .get();
    List<DateTime> expiryDates = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data();
      if (data['expDate'] != null) {
        DateTime expiryDate = data['expDate'].toDate();
        expiryDates.add(expiryDate);
      } else {
        throw Exception('Expiry date not found');
      }
    }
    return expiryDates;
  }
}
