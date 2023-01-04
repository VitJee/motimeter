import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailController {
  static const dbURL = "https://motimeter-98640-default-rtdb.europe-west1.firebasedatabase.app/";

  static Query getEventQuery(String eventKey) {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: dbURL
    ).ref("events/$eventKey");
  }
}