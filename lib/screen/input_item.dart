import 'package:expirydatefyp/liblist/my_lib.dart';
import 'package:intl/intl.dart';
import '../utils/notification_widget.dart';
import '../utils/sidebar.dart';

class InputItem extends StatefulWidget {
  const InputItem({Key? key}) : super(key: key);

  @override
  State<InputItem> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDisc = TextEditingController();
  DateTime? _selectedDate;

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> startScan() async {
    String scanRes = await BarcodeScannerService.startScan();

    if (!mounted) return;

    // Split the result and update the textfields
    List<String> splitResult = scanRes.split(',');
    if (splitResult.length >= 3) {
      _productName.text = splitResult[0].trim();
      _productDisc.text = splitResult[1].trim();

      // Assume the date is in 'dd/MM/yyyy' format
      DateFormat format = DateFormat("dd/MM/yyyy");
      try {
        DateTime expDate = format.parse(splitResult[2].trim());
        setState(() {
          _selectedDate = expDate;
        });
      } catch (e) {
        // Handle error, e.g., show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing date: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> saveToFirestore() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      String productName = _productName.text;
      String productDisc = _productDisc.text;

      if (_selectedDate == null) {
        throw Exception('No date selected');
      }
      DateTime expDate = _selectedDate!;

      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user currently signed in');
      }
      String uid = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('products')
          .doc()
          .set({
        'productName': productName,
        'productDisc': productDisc,
        'expDate': expDate,
      });

      NotificationWidget.scheduleProductExpiryNotifications(
        productName: productName,
        productDescription: productDisc,
        expiryDate: expDate,
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Saved Successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      _productName.clear();
      _productDisc.clear();
      setState(() {
        _selectedDate = null;
      });
    } catch (e) {
      _productName.clear();
      _productDisc.clear();
      setState(() {
        _selectedDate = null;
      });
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: const CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(gradient: getFixedGradient()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: CustomColors.darkMain,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Text(
                          'Manual Input',
                          style: CustomColors.htext,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _productName,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          prefixIcon: Icon(Icons.add_box_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _productDisc,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => selectDate(),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => saveToFirestore(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.darkMain,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                        ),
                        child: Text(
                          'Add Product',
                          style: CustomColors.buttext,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColors.darkMain,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Center(
                          child: Text(
                            'Scanner',
                            style: CustomColors.htext,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => startScan(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.darkMain,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.qr_code_scanner),
                              const SizedBox(width: 10),
                              Text(
                                'Start Scan',
                                style: CustomColors.buttext,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarApp(
        context: context,
        bottomNavigationBarIndex: 1,
      ),
    );
  }
}
