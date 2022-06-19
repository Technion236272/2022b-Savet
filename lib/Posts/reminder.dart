import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../auth/auth_repository.dart';

class reminder {
  void love() {
    var datetime = DateFormat('d.M.yyyy , HH:mm').parse(widget._time);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    if (_isSaved == false) {
      scheduleNotification(
          notifsPlugin,
          DateTime.now().toString(),
          widget._title,
          "you have event soon!",
          datetime.subtract(Duration(minutes: 10)),
          Ticket.id);
      widget.notif_id = Ticket.id;

      _firestore.collection("users/${user?.uid}/favorites").add({
        'ref': widget.ref,
        'id': Ticket.id++,
      });
    } else {
      _firestore
          .collection("users/${user?.uid}/favorites")
          .where('id', isEqualTo: widget.notif_id)
          .get()
          .then((collection) => {
                collection.docs.forEach((element) {
                  element.reference.delete();
                })
              });
      notifsPlugin.cancel(widget.notif_id!);
    }
    setState(() {
      _isSaved = !_isSaved;
    });
  }
}
