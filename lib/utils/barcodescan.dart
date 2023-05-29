import '../liblist/my_lib.dart';

class BarcodeScannerService {
  static Future<String> startScan() async {
    String scanRes;
    try {
      scanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
    } catch (e) {
      scanRes = 'Failed to get platform version.';
    }
    return scanRes;
  }
}
