import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseManager {
  Future getcountid() async {
    var counter = await FirebaseFirestore.instance.collection('counter').get();
    var itemid = counter.docs[1].data()['countid'];

    return itemid;
  }
}
